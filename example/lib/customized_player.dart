import 'package:flutter/material.dart';

import 'package:webviewtube/webviewtube.dart';

class CustomizedPlayer extends StatefulWidget {
  const CustomizedPlayer({Key? key}) : super(key: key);

  @override
  State<CustomizedPlayer> createState() => _CustomizedPlayerState();
}

class _CustomizedPlayerState extends State<CustomizedPlayer> {
  final webviewtubeController = WebviewtubeController(
      options: const WebviewtubeOptions(showControls: false));
  final videoIds = ['qV9pqHWxYgI', 'cyFM2emjbQ8', 'PKGguGUwSYE'];
  String _title = '';
  String _author = '';
  bool _isPlaying = false;
  int _currentIdx = 0;

  @override
  void initState() {
    super.initState();
    webviewtubeController.addListener(_valueHandler);
  }

  @override
  void dispose() {
    webviewtubeController.removeListener(_valueHandler);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customized Player'),
      ),
      body: ListView(
        children: <Widget>[
          WebviewtubePlayer(
            videoIds.first,
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
                            _isPlaying = true;
                          });
                        }
                      : null,
                  icon: const Icon(Icons.skip_previous)),
              _isPlaying
                  ? IconButton(
                      onPressed: () {
                        webviewtubeController.pause();
                        setState(() {
                          _isPlaying = false;
                        });
                      },
                      icon: const Icon(Icons.pause))
                  : IconButton(
                      onPressed: () {
                        webviewtubeController.play();
                        setState(() {
                          _isPlaying = true;
                        });
                      },
                      icon: const Icon(Icons.play_arrow)),
              IconButton(
                  onPressed: _currentIdx < videoIds.length - 1
                      ? () {
                          webviewtubeController.load(videoIds[_currentIdx + 1]);
                          setState(() {
                            _currentIdx += 1;
                            _isPlaying = true;
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
