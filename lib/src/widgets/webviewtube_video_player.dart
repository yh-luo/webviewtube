import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../webviewtube.dart';

/// {@template webviewtube_video_player}
/// A widgets-decorated [WebviewtubePlayer].
///
/// It's less performant but has more customized widgets. The player can be
/// configured by [options] and controlled by [controller]. If a controller is
/// not provided, a [WebviewtubeController] with default options will be created
/// using `ChangeNotifierProvider` constructor. It will be automatically
/// disposed when the [WebviewtubeVideoPlayer] widget is removed from the
/// widget tree. Otherwise the user is responsible for disposing the given
/// controller.
///
/// Example:
/// ```dart
/// Scaffold(
///   body: WebviewtubeVideoPlayer(videoId: '4AoFA19gbLo'),
/// );
/// ```
///
/// With controller:
/// ```dart
/// final webviewtubeController = WebviewtubeController();
///
/// // Remember to dispose the controller to avoid memory leak
/// @override
/// void dispose() {
///   webviewtubeController.dispose();
///   super.dispose();
/// }
///
/// Scaffold(
///   body: WebviewtubeVideoPlayer(
///     videoId: '4AoFA19gbLo',
///     controller: webviewtubeController),
/// );
/// ```
/// {@endtemplate}
class WebviewtubeVideoPlayer extends StatelessWidget {
  /// Constructor for [WebviewtubeVideoPlayer].
  WebviewtubeVideoPlayer(
      {Key? key,
      required this.videoId,
      WebviewtubeOptions? options,
      WebviewtubeController? controller})
      : _controller = controller,
        _options = options?.copyWith(showControls: false) ??
            const WebviewtubeOptions(showControls: false),
        super(key: key);

  /// The video id of the video to play.
  final String videoId;

  /// Additional options to control the player.
  final WebviewtubeOptions _options;

  /// The controller to control the player.
  final WebviewtubeController? _controller;

  late final _child =
      _WebviewtubeVideoPlayerView(videoId: videoId, options: _options);

  @override
  Widget build(BuildContext context) {
    final controller = _controller;

    return controller != null
        ? ChangeNotifierProvider<WebviewtubeController>.value(
            value: controller,
            child: _child,
          )
        : ChangeNotifierProvider<WebviewtubeController>(
            create: (_) => WebviewtubeController(),
            child: _child,
          );
  }
}

/// The player view.
class _WebviewtubeVideoPlayerView extends StatelessWidget {
  const _WebviewtubeVideoPlayerView({
    Key? key,
    required this.videoId,
    required this.options,
  }) : super(key: key);

  /// The video id of the video to play.
  final String videoId;

  final WebviewtubeOptions options;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        WebviewtubePlayer(
          videoId: videoId,
          options: options,
          controller: context.read<WebviewtubeController>(),
        ),
        Selector<WebviewtubeController, bool>(
          selector: (_, controller) => controller.value.isReady,
          builder: (context, value, __) {
            if (value) {
              return const SizedBox.shrink();
            }

            return const LoadingIndicator();
          },
        ),
        Selector<WebviewtubeController, PlayerState>(
          selector: (_, controller) => controller.value.playerState,
          builder: (context, value, child) {
            if (value == PlayerState.ended) {
              return Positioned(
                left: 10,
                bottom: -5,
                child: IconButton(
                  onPressed: () =>
                      context.read<WebviewtubeController>().replay(),
                  icon: const Icon(Icons.replay, color: Colors.white),
                ),
              );
            }

            return Positioned(
              left: 10,
              bottom: -5,
              child: AnimatedOpacity(
                opacity: value == PlayerState.playing ? 0 : 1,
                duration: const Duration(milliseconds: 300),
                child: IgnorePointer(
                  ignoring: value == PlayerState.playing,
                  child: child,
                ),
              ),
            );
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              DurationIndicator(),
              VolumeButton(),
              PlaybackSpeedButton(),
            ],
          ),
        ),
        Selector<WebviewtubeController, PlayerState>(
          selector: (_, controller) => controller.value.playerState,
          builder: (context, value, child) {
            return Positioned(
              left: 5,
              right: 5,
              bottom: 35,
              child: AnimatedOpacity(
                opacity: value == PlayerState.playing ? 0 : 1,
                duration: const Duration(milliseconds: 300),
                child: IgnorePointer(
                  ignoring: value == PlayerState.playing,
                  child: child,
                ),
              ),
            );
          },
          child: const ProgressBar(),
        ),
      ],
    );
  }
}
