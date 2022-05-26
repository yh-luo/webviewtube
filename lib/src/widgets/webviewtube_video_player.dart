import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../webviewtube.dart';

class WebviewtubeVideoPlayer extends StatelessWidget {
  WebviewtubeVideoPlayer(this.videoId,
      {super.key, WebviewtubeController? controller})
      : _controller = controller ??
            WebviewtubeController(
              options: const WebviewtubeOptions(
                showControls: false,
              ),
            );

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

class WebviewtubeVideoPlayerView extends StatelessWidget {
  const WebviewtubeVideoPlayerView(this.videoId, {super.key});

  final String videoId;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        WebviewtubePlayer(
          videoId,
          controller: context.read<WebviewtubeController>(),
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
