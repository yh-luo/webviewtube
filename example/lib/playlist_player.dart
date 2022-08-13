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
  int _currentIdx = 0;
  final List<String> videoIds = <String>[
    'l6hw4o6_Wcs',
    'jckqXR5CrPI',
    'RA-vLF_vnng',
  ];

  @override
  void initState() {
    super.initState();
    // load by playlist id
    // webviewtubeController = WebviewtubeController(
    //   onPlayerReady: () => webviewtubeController.loadPlaylist(
    //       playlistId: 'PLjxrf2q8roU23XGwz3Km7sQZFTdB996iG'),
    // );
    webviewtubeController = WebviewtubeController(
      onPlayerReady: () =>
          webviewtubeController.loadPlaylist(videoIds: videoIds),
    );
    webviewtubeController.addListener(_valueHandler);
  }

  @override
  void dispose() {
    webviewtubeController.removeListener(_valueHandler);
    webviewtubeController.dispose();
    super.dispose();
  }

  void _valueHandler() {
    final playerState = webviewtubeController.value.playerState;
    final metadata = webviewtubeController.value.videoMetadata;
    final index = videoIds.indexWhere((e) => e == metadata.videoId);
    if (_isPlaying && playerState != PlayerState.playing) {
      setState(() {
        _isPlaying = false;
      });
    } else if (!_isPlaying && playerState == PlayerState.playing) {
      setState(() {
        _isPlaying = true;
      });
    }

    if (index > 0) {
      setState(() {
        _currentIdx = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Playlist Player'),
      ),
      body: ListView(
        children: <Widget>[
          WebviewtubePlayer(
            videoId: '',
            options: options,
            controller: webviewtubeController,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Currently playing video index: ',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              DropdownButton<int>(
                  value: _currentIdx,
                  items: List<DropdownMenuItem<int>>.generate(videoIds.length,
                      (i) {
                    return DropdownMenuItem<int>(
                      value: i,
                      child: Text(
                        i.toString(),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    );
                  }),
                  onChanged: (index) {
                    if (index == null) return;
                    webviewtubeController.playVideoAt(index);
                  }),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                  onPressed: _currentIdx > 0
                      ? () => webviewtubeController.previousVideo()
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
                      ? () => webviewtubeController.nextVideo()
                      : null,
                  icon: const Icon(Icons.skip_next))
            ],
          ),
        ],
      ),
    );
  }
}
