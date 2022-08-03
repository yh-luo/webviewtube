import 'package:flutter/material.dart';

import 'package:webviewtube/webviewtube.dart';

class PlaylistPlayer extends StatefulWidget {
  const PlaylistPlayer({Key? key}) : super(key: key);

  @override
  State<PlaylistPlayer> createState() => _PlaylistPlayerState();
}

class _PlaylistPlayerState extends State<PlaylistPlayer> {
  final options = const WebviewtubeOptions(
    enableCaption: false,
  );
  late final WebviewtubeController webviewtubeController;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    // load the playlist right after
    webviewtubeController = WebviewtubeController(
      onPlayerReady: () => webviewtubeController.loadPlaylist(
          playlistId: 'PLjxrf2q8roU23XGwz3Km7sQZFTdB996iG'),
    );
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
            videoId: '4AoFA19gbLo',
            options: options,
            controller: webviewtubeController,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                  onPressed: () {
                    webviewtubeController.previousVideo();
                  },
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
                  onPressed: () {
                    webviewtubeController.nextVideo();
                  },
                  icon: const Icon(Icons.skip_next))
            ],
          ),
        ],
      ),
    );
  }
}
