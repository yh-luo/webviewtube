import 'package:flutter/material.dart';

import 'package:webviewtube/webviewtube.dart';

class WebviewtubeDecoratedPlayer extends StatelessWidget {
  const WebviewtubeDecoratedPlayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Webviewtube Decorated Player'),
      ),
      body: WebviewtubeVideoPlayer(videoId: 'rIaaH87z1-g'),
    );
  }
}
