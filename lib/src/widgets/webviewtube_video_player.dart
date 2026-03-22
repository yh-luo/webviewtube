import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../webviewtube.dart';
import 'widgets.dart';

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
/// final webviewtubeController = WebviewtubeController(
///   options: const WebviewtubeOptions(showControls: false));
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
  /// {@macro webviewtube_video_player}
  WebviewtubeVideoPlayer({
    super.key,
    required this.videoId,
    WebviewtubeController? controller,
    this.loadingBuilder,
    this.controlsBuilder,
    this.progressBarBuilder,
  }) : _controller = controller;

  /// The video id of the video to play.
  final String videoId;

  /// The controller to control the player.
  final WebviewtubeController? _controller;

  /// Builder for the loading overlay. Receives [isReady] to indicate whether
  /// the player is ready. Defaults to [LoadingIndicator].
  final Widget Function(BuildContext context, bool isReady)? loadingBuilder;

  /// Builder for the controls overlay. Receives [playerState] to reflect the
  /// current playback state. Defaults to replay, duration, volume, and speed
  /// controls.
  final Widget Function(BuildContext context, PlayerState playerState)?
      controlsBuilder;

  /// Builder for the progress bar overlay. Receives [playerState] to reflect
  /// the current playback state. Defaults to [ProgressBar].
  final Widget Function(BuildContext context, PlayerState playerState)?
      progressBarBuilder;

  late final _child = _WebviewtubeVideoPlayerView(
    videoId: videoId,
    loadingBuilder: loadingBuilder ?? _defaultLoadingBuilder,
    controlsBuilder: controlsBuilder ?? _defaultControlsBuilder,
    progressBarBuilder: progressBarBuilder ?? _defaultProgressBarBuilder,
  );

  @override
  Widget build(BuildContext context) {
    final controller = _controller;

    return controller != null
        ? ChangeNotifierProvider<WebviewtubeController>.value(
            value: controller,
            child: _child,
          )
        : ChangeNotifierProvider<WebviewtubeController>(
            create: (_) => WebviewtubeController(
                options: const WebviewtubeOptions(showControls: false)),
            child: _child,
          );
  }
}

/// The player view.
class _WebviewtubeVideoPlayerView extends StatelessWidget {
  const _WebviewtubeVideoPlayerView({
    required this.videoId,
    required this.loadingBuilder,
    required this.controlsBuilder,
    required this.progressBarBuilder,
  });

  /// The video id of the video to play.
  final String videoId;

  final Widget Function(BuildContext context, bool isReady) loadingBuilder;
  final Widget Function(BuildContext context, PlayerState playerState)
      controlsBuilder;
  final Widget Function(BuildContext context, PlayerState playerState)
      progressBarBuilder;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        WebviewtubePlayer(
          videoId: videoId,
          controller: context.read<WebviewtubeController>(),
        ),
        Selector<WebviewtubeController, bool>(
          selector: (_, controller) => controller.value.isReady,
          builder: (context, isReady, __) => loadingBuilder(context, isReady),
        ),
        Selector<WebviewtubeController, PlayerState>(
          selector: (_, controller) => controller.value.playerState,
          builder: (context, playerState, __) =>
              controlsBuilder(context, playerState),
        ),
        Selector<WebviewtubeController, PlayerState>(
          selector: (_, controller) => controller.value.playerState,
          builder: (context, playerState, __) =>
              progressBarBuilder(context, playerState),
        ),
      ],
    );
  }
}

Widget _defaultLoadingBuilder(BuildContext context, bool isReady) {
  if (isReady) return const SizedBox.shrink();
  return const LoadingIndicator();
}

Widget _defaultControlsBuilder(BuildContext context, PlayerState playerState) {
  if (playerState == PlayerState.ended) {
    return Positioned(
      left: 10,
      bottom: -5,
      child: IconButton(
        onPressed: () => context.read<WebviewtubeController>().replay(),
        icon: const Icon(Icons.replay, color: Colors.white),
      ),
    );
  }

  return Positioned(
    left: 10,
    bottom: -5,
    child: AnimatedOpacity(
      opacity: playerState == PlayerState.playing ? 0 : 1,
      duration: const Duration(milliseconds: 300),
      child: IgnorePointer(
        ignoring: playerState == PlayerState.playing,
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            DurationIndicator(),
            VolumeButton(),
            PlaybackSpeedButton(),
          ],
        ),
      ),
    ),
  );
}

Widget _defaultProgressBarBuilder(
    BuildContext context, PlayerState playerState) {
  return Positioned(
    left: 5,
    right: 5,
    bottom: 35,
    child: AnimatedOpacity(
      opacity: playerState == PlayerState.playing ? 0 : 1,
      duration: const Duration(milliseconds: 300),
      child: IgnorePointer(
        ignoring: playerState == PlayerState.playing,
        child: const ProgressBar(),
      ),
    ),
  );
}
