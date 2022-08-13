import 'package:flutter/material.dart';

import 'package:webviewtube/webviewtube.dart';

class CustomizedPlayer extends StatefulWidget {
  const CustomizedPlayer({Key? key}) : super(key: key);

  @override
  State<CustomizedPlayer> createState() => _CustomizedPlayerState();
}

class _CustomizedPlayerState extends State<CustomizedPlayer> {
  final options = const WebviewtubeOptions(
    enableCaption: false,
  );
  late final WebviewtubeController webviewtubeController;

  final videoIds = ['qV9pqHWxYgI', 'cyFM2emjbQ8', 'PKGguGUwSYE'];
  String _title = '';
  String _author = '';
  bool _isPlaying = false;
  int _currentIdx = 0;

  @override
  void initState() {
    super.initState();
    webviewtubeController = WebviewtubeController(
      onPlayerReady: _onPlayerReady,
    );
    webviewtubeController.addListener(_valueHandler);
  }

  @override
  void dispose() {
    // If a controller is passed to the player, remember to dispose it when
    // it's not in need.
    webviewtubeController.removeListener(_valueHandler);
    webviewtubeController.dispose();
    super.dispose();
  }

  void _valueHandler() {
    final playerState = webviewtubeController.value.playerState;
    final title = webviewtubeController.value.videoMetadata.title;
    final author = webviewtubeController.value.videoMetadata.author;
    if (_isPlaying && playerState != PlayerState.playing) {
      setState(() {
        _isPlaying = false;
      });
    } else if (!_isPlaying && playerState == PlayerState.playing) {
      setState(() {
        _isPlaying = true;
      });
    }

    if (_title != title) {
      setState(() {
        _title = title;
      });
    }
    if (_author != author) {
      setState(() {
        _author = author;
      });
    }
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
            options: options,
            controller: webviewtubeController,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  _title,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  _author,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                  onPressed: _currentIdx > 0
                      ? () {
                          webviewtubeController.load(videoIds[_currentIdx - 1]);
                          setState(() {
                            _currentIdx -= 1;
                          });
                        }
                      : null,
                  icon: const Icon(Icons.skip_previous)),
              _isPlaying
                  ? IconButton(
                      onPressed: () => webviewtubeController.pause(),
                      icon: const Icon(Icons.pause))
                  : IconButton(
                      onPressed: () => webviewtubeController.play(),
                      icon: const Icon(Icons.play_arrow)),
              IconButton(
                  onPressed: _currentIdx < videoIds.length - 1
                      ? () {
                          webviewtubeController.load(videoIds[_currentIdx + 1]);
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
}
