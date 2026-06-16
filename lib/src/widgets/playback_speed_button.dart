import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../webviewtube.dart';
import 'duration_indicator.dart';

/// {@template play_back_speed_button}
/// A widget to display a menu to change the current playback speed.
/// {@endtemplate}
class PlaybackSpeedButton extends StatelessWidget {
  /// {@macro play_back_speed_button}
  const PlaybackSpeedButton({super.key, this.color = Colors.white});

  /// The color of the speed icon. Defaults to [Colors.white].
  final Color color;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<PlaybackRate>(
      icon: Icon(
        Icons.speed,
        color: color,
        shadows: kDefaultControlTextStyle.shadows,
      ),
      onSelected: (playbackRate) async =>
          context.read<WebviewtubeController>().setPlaybackRate(playbackRate),
      initialValue: context.select<WebviewtubeController, PlaybackRate>(
        (c) => c.value.playbackRate,
      ),
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
