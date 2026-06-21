import 'package:flutter/material.dart';
import 'package:webviewtube/webviewtube.dart';

class CustomizedPlayer extends StatefulWidget {
  const CustomizedPlayer({super.key});

  @override
  State<CustomizedPlayer> createState() => _CustomizedPlayerState();
}

class _CustomizedPlayerState extends State<CustomizedPlayer> {
  static const _videoId = 'qV9pqHWxYgI';

  late final WebviewtubeController controller;

  @override
  void initState() {
    super.initState();
    controller = WebviewtubeController(
      options: const WebviewtubeOptions(enableCaption: false),
    );
    controller.addListener(_onControllerUpdate);
  }

  @override
  void dispose() {
    controller.removeListener(_onControllerUpdate);
    controller.dispose();
    super.dispose();
  }

  void _onControllerUpdate() => setState(() {});

  Future<void> _seekBy(Duration delta) async {
    final value = controller.value;
    var target = value.position + delta;
    if (target < Duration.zero) target = Duration.zero;
    final duration = value.videoMetadata.duration;
    if (duration > Duration.zero && target > duration) target = duration;
    await controller.seekTo(target, allowSeekAhead: true);
  }

  @override
  Widget build(BuildContext context) {
    final value = controller.value;
    final metadata = value.videoMetadata;
    final isPlaying = value.playerState == PlayerState.playing;
    final isBuffering = value.playerState == PlayerState.buffering;

    return Scaffold(
      appBar: AppBar(title: const Text('Controller-driven UI')),
      body: ListView(
        children: <Widget>[
          WebviewtubePlayer(videoId: _videoId, controller: controller),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  metadata.title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  metadata.author.isNotEmpty ? 'by ${metadata.author}' : '',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  metadata.duration > Duration.zero
                      ? '${_format(value.position)} / ${_format(metadata.duration)}'
                      : '',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                iconSize: 48,
                onPressed: () => _seekBy(const Duration(seconds: -5)),
                icon: const Icon(Icons.replay_5),
              ),
              IconButton(
                iconSize: 48,
                onPressed: isPlaying ? controller.pause : controller.play,
                icon: isBuffering
                    ? const SizedBox(
                        width: 48,
                        height: 48,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : Icon(isPlaying ? Icons.pause : Icons.play_arrow),
              ),
              IconButton(
                iconSize: 48,
                onPressed: () => _seekBy(const Duration(seconds: 5)),
                icon: const Icon(Icons.forward_5),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static String _format(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return h > 0 ? '${h.toString().padLeft(2, '0')}:$m:$s' : '$m:$s';
  }
}
