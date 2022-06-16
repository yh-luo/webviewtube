import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../webviewtube.dart';

/// {@template webviewtube_video_player}
/// A widgets-decorated [WebviewtubePlayer]. It's less performant but
/// customizable.
/// If controller is not provided, a [WebviewtubeController] hides the default
/// YouTube player controls is created.
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
///   options: const WebviewtubeOptions(
///       // remember to set `showControls` to false to hide the
///       // iframe player controls
///       showControls: false,
///       forceHd: true,
///       enableCaption: false),
/// );
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
      {Key? key, required this.videoId, WebviewtubeController? controller})
      : _controller = controller ??
            WebviewtubeController(
                options: const WebviewtubeOptions(showControls: false)),
        super(key: key);

  /// The video id of the video to play.
  final String videoId;
  final WebviewtubeController _controller;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _controller,
      child: WebviewtubeVideoPlayerView(videoId: videoId),
    );
  }
}

/// The player view.
class WebviewtubeVideoPlayerView extends StatelessWidget {
  /// Constructor for [WebviewtubeVideoPlayerView].
  const WebviewtubeVideoPlayerView({
    Key? key,
    required this.videoId,
  }) : super(key: key);

  /// The video id of the video to play.
  final String videoId;

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
