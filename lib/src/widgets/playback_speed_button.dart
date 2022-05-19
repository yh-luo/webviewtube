import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../webviewtube.dart';

class PlaybackSpeedButton extends StatelessWidget {
  const PlaybackSpeedButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final playbackRate =
        context.watch<WebviewtubeController>().value.playbackRate;

    return PopupMenuButton<PlaybackRate>(
      icon: Icon(Icons.speed, color: Colors.red),
      onSelected: (playbackRate) =>
          context.read<WebviewtubeController>().setPlaybackRate(playbackRate),
      initialValue: playbackRate,
      itemBuilder: (context) => [
        PopupMenuItem<PlaybackRate>(
          child: Text('0.25'),
          value: PlaybackRate.quarter,
        ),
        PopupMenuItem<PlaybackRate>(
          child: Text('0.5'),
          value: PlaybackRate.half,
        ),
        PopupMenuItem<PlaybackRate>(
          child: Text('0.75'),
          value: PlaybackRate.threeQuarter,
        ),
        PopupMenuItem<PlaybackRate>(
          child: Text('1'),
          value: PlaybackRate.normal,
        ),
        PopupMenuItem<PlaybackRate>(
          child: Text('1.25'),
          value: PlaybackRate.oneAndAQuarter,
        ),
        PopupMenuItem<PlaybackRate>(
          child: Text('1.5'),
          value: PlaybackRate.oneAndAHalf,
        ),
        PopupMenuItem<PlaybackRate>(
          child: Text('1.75'),
          value: PlaybackRate.oneAndAThreeQuarter,
        ),
        PopupMenuItem<PlaybackRate>(
          child: Text('2.0'),
          value: PlaybackRate.twice,
        ),
      ],
    );
  }
}
