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
///   body: WebviewtubeVideoPlayer('4AoFA19gbLo'),
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
///     '4AoFA19gbLo',
///     controller: webviewtubeController),
/// );
/// ```
/// {@endtemplate}
class WebviewtubeVideoPlayer extends StatelessWidget {
  /// Constructor for [WebviewtubeVideoPlayer].
  WebviewtubeVideoPlayer(this.videoId,
      {super.key, WebviewtubeController? controller})
      : _controller = controller ??
            WebviewtubeController(
                options: const WebviewtubeOptions(showControls: false));

  /// The video id of the video to play.
  final String videoId;
  final WebviewtubeController _controller;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _controller,
      child: WebviewtubeVideoPlayerView(videoId),
    );
  }
}

/// The player view.
class WebviewtubeVideoPlayerView extends StatelessWidget {
  /// Constructor for [WebviewtubeVideoPlayerView].
  const WebviewtubeVideoPlayerView(this.videoId, {super.key});

  /// The video id of the video to play.
  final String videoId;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        WebviewtubePlayer(
          videoId,
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
        Consumer<WebviewtubeController>(
          builder: (context, controller, child) {
            return Positioned(
              left: 10,
              bottom: 0,
              child: AnimatedOpacity(
                opacity:
                    controller.value.playerState == PlayerState.playing ? 0 : 1,
                duration: const Duration(milliseconds: 300),
                child: child,
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
        Consumer<WebviewtubeController>(
          builder: (context, controller, child) {
            return Positioned(
              left: 5,
              bottom: 1,
              child: AnimatedOpacity(
                opacity:
                    controller.value.playerState == PlayerState.playing ? 0 : 1,
                duration: const Duration(milliseconds: 300),
                child: child,
              ),
            );
          },
          child: const ProgressBar(),
        ),
      ],
    );
  }
}
