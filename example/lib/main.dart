import 'package:flutter/material.dart';

import 'package:webviewtube/webviewtube.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Webviewtube',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const WebviewtubeDemo(),
    );
  }
}

class WebviewtubeDemo extends StatelessWidget {
  const WebviewtubeDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Webviewtube Demo'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 10),
        children: [
          const DefaultPlayer(),
          const SizedBox(height: 70),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => const WebviewtubeDecoratedPlayer()));
            },
            child: const Text(
              'Webviewtube Decorated Player',
              style: TextStyle(fontSize: 16),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => const CustomizedPlayer()));
            },
            child: const Text(
              'Customized Player',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

class DefaultPlayer extends StatelessWidget {
  const DefaultPlayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Default Player',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        WebviewtubePlayer('4AoFA19gbLo'),
      ],
    );
  }
}

class WebviewtubeDecoratedPlayer extends StatelessWidget {
  const WebviewtubeDecoratedPlayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Webviewtube Decorated Player'),
      ),
      body: WebviewtubeVideoPlayer('rIaaH87z1-g'),
    );
  }
}

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
    webviewtubeController.addListener(() {
      final title = webviewtubeController.value.videoMetadata.title;
      final author = webviewtubeController.value.videoMetadata.author;
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customized Player'),
      ),
      body: ListView(
        children: [
          WebviewtubePlayer(
            videoIds.first,
            controller: webviewtubeController,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
            children: [
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
