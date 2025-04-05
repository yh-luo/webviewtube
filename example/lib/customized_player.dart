import 'package:flutter/material.dart';
import 'package:webviewtube/webviewtube.dart';

class CustomizedPlayer extends StatefulWidget {
  const CustomizedPlayer({Key? key}) : super(key: key);

  @override
  State<CustomizedPlayer> createState() => _CustomizedPlayerState();
}

class _CustomizedPlayerState extends State<CustomizedPlayer> {
  late final WebviewtubeController controller;
  final videoIds = ['qV9pqHWxYgI', 'cyFM2emjbQ8', 'PKGguGUwSYE'];
  bool _isReady = false;
  String _title = '';
  String _author = '';
  bool _isPlaying = false;
  int _currentIdx = 0;
  Duration _duration = const Duration(seconds: 0);
  Duration _position = const Duration(seconds: 0);

  @override
  void initState() {
    super.initState();
    controller = WebviewtubeController(
      options: const WebviewtubeOptions(
        enableCaption: false,
      ),
      onPlayerReady: _onPlayerReady,
    );
    controller.addListener(_valueHandler);
  }

  @override
  void dispose() {
    // If a controller is passed to the player, remember to dispose it when
    // it's not in need.
    controller.removeListener(_valueHandler);
    controller.dispose();
    super.dispose();
  }

  void _valueHandler() {
    final isReady = controller.value.isReady;
    final playerState = controller.value.playerState;
    final title = controller.value.videoMetadata.title;
    final author = controller.value.videoMetadata.author;
    final duration = controller.value.videoMetadata.duration;
    final position = controller.value.position;

    if (_isReady != isReady) {
      _isReady = isReady;
    }
    if (_isPlaying && playerState != PlayerState.playing) {
      _isPlaying = false;
    } else if (!_isPlaying && playerState == PlayerState.playing) {
      _isPlaying = true;
    }

    if (_title != title) {
      _title = title;
    }
    if (_author != author) {
      _author = author;
    }
    if (_duration != duration) {
      _duration = duration;
    }
    if (_position != position) {
      _position = position;
    }

    setState(() {});
  }

  void _onPlayerReady() {
    debugPrint('The customized player is ready');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customized Player'),
      ),
      body: ListView(
        children: <Widget>[
          WebviewtubePlayer(
            videoId: videoIds.first,
            controller: controller,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _duration.inSeconds > 0
                      ? '${_formatDuration(_position)} / ${_formatDuration(_duration)}'
                      : '',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      _title,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Text(
                      "${_author.isNotEmpty ? 'by ' : ''}$_author",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                  onPressed: _currentIdx > 0
                      ? () async {
                          await controller.load(videoIds[_currentIdx - 1]);
                          setState(() {
                            _currentIdx -= 1;
                          });
                        }
                      : null,
                  icon: const Icon(Icons.skip_previous)),
              _isPlaying
                  ? IconButton(
                      onPressed: () async => controller.pause(),
                      icon: const Icon(Icons.pause))
                  : IconButton(
                      onPressed: () async => controller.play(),
                      icon: const Icon(Icons.play_arrow)),
              IconButton(
                  onPressed: _currentIdx < videoIds.length - 1
                      ? () async {
                          await controller.load(videoIds[_currentIdx + 1]);
                          setState(() {
                            _currentIdx += 1;
                          });
                        }
                      : null,
                  icon: const Icon(Icons.skip_next))
            ],
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String? hours;
    if (duration.inHours > 0) {
      hours = duration.inHours.toString().padLeft(2, '0');
    }
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');

    if (hours != null) {
      return '$hours:$minutes:$seconds';
    }

    return '$minutes:$seconds';
  }
}
