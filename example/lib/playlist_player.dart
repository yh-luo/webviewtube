import 'package:flutter/material.dart';
import 'package:webviewtube/webviewtube.dart';

/// Demonstrates playlist playback: queue a list of video ids (or a
/// YouTube playlist id) and step through them with `nextVideo` /
/// `previousVideo` / `playVideoAt`.
class PlaylistPlayer extends StatefulWidget {
  const PlaylistPlayer({super.key});

  @override
  State<PlaylistPlayer> createState() => _PlaylistPlayerState();
}

class _PlaylistPlayerState extends State<PlaylistPlayer> {
  late final WebviewtubeController controller;
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
    // Alternative: load by a YouTube playlist id instead of an explicit
    // list of video ids — uncomment to try.
    // controller = WebviewtubeController(
    //   options: const WebviewtubeOptions(enableCaption: false),
    //   onPlayerReady: () => controller.loadPlaylist(
    //       playlistId: 'PLjxrf2q8roU23XGwz3Km7sQZFTdB996iG'),
    // );
    controller = WebviewtubeController(
      options: const WebviewtubeOptions(enableCaption: false),
      onPlayerReady: () async => controller.loadPlaylist(videoIds: videoIds),
    );
    controller.addListener(_valueHandler);
  }

  @override
  void dispose() {
    controller.removeListener(_valueHandler);
    controller.dispose();
    super.dispose();
  }

  void _valueHandler() {
    final playerState = controller.value.playerState;
    final metadata = controller.value.videoMetadata;
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

    if (index >= 0 && _currentIdx != index) {
      setState(() {
        _currentIdx = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Playlist Player')),
      body: ListView(
        children: <Widget>[
          WebviewtubePlayer(videoId: '', controller: controller),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Currently playing video index: ',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              DropdownButton<int>(
                value: _currentIdx,
                items: List<DropdownMenuItem<int>>.generate(videoIds.length, (
                  i,
                ) {
                  return DropdownMenuItem<int>(
                    value: i,
                    child: Text(
                      i.toString(),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  );
                }),
                onChanged: (index) async {
                  if (index == null) return;
                  await controller.playVideoAt(index);
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                iconSize: 48,
                onPressed: _currentIdx > 0
                    ? () async => controller.previousVideo()
                    : null,
                icon: const Icon(Icons.skip_previous),
              ),
              _isPlaying
                  ? IconButton(
                      iconSize: 48,
                      onPressed: () async => controller.pause(),
                      icon: const Icon(Icons.pause),
                    )
                  : IconButton(
                      iconSize: 48,
                      onPressed: () async => controller.play(),
                      icon: const Icon(Icons.play_arrow),
                    ),
              IconButton(
                iconSize: 48,
                onPressed: _currentIdx < videoIds.length - 1
                    ? () async => controller.nextVideo()
                    : null,
                icon: const Icon(Icons.skip_next),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
