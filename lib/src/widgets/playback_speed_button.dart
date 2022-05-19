import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../webviewtube.dart';

class PlaybackSpeedButton extends StatelessWidget {
  const PlaybackSpeedButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<PlaybackRate>(
      icon: Icon(Icons.speed, color: Colors.red),
      onSelected: (playbackRate) =>
          context.read<WebviewtubeController>().setPlaybackRate(playbackRate),
      initialValue: context.watch<WebviewtubeController>().value.playbackRate,
      itemBuilder: (context) => const [
        PopupMenuItem<PlaybackRate>(
          value: PlaybackRate.quarter,
          child: Text('0.25'),
        ),
        PopupMenuItem<PlaybackRate>(
          value: PlaybackRate.half,
          child: Text('0.5'),
        ),
        PopupMenuItem<PlaybackRate>(
          value: PlaybackRate.threeQuarter,
          child: Text('0.75'),
        ),
        PopupMenuItem<PlaybackRate>(
          value: PlaybackRate.normal,
          child: Text('1'),
        ),
        PopupMenuItem<PlaybackRate>(
          value: PlaybackRate.oneAndAQuarter,
          child: Text('1.25'),
        ),
        PopupMenuItem<PlaybackRate>(
          value: PlaybackRate.oneAndAHalf,
          child: Text('1.5'),
        ),
        PopupMenuItem<PlaybackRate>(
          value: PlaybackRate.oneAndAThreeQuarter,
          child: Text('1.75'),
        ),
        PopupMenuItem<PlaybackRate>(
          value: PlaybackRate.twice,
          child: Text('2.0'),
        ),
      ],
    );
  }
}
