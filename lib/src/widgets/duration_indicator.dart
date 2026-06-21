import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../webviewtube.dart';

const _textStyle = TextStyle(
  color: Colors.white,
  shadows: <Shadow>[
    Shadow(offset: Offset(1, 1), blurRadius: 5, color: Colors.black87),
  ],
);

/// {@template duration_indicator}
/// A widget to display the current position and the remaining duration of the
/// video.
/// {@endtemplate}
class DurationIndicator extends StatelessWidget {
  /// {@macro duration_indicator}
  const DurationIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: const <Widget>[
        CurrentTime(),
        Text(
          ' / ',
          style: _textStyle,
        ),
        VideoDuration(),
      ],
    );
  }
}

/// A widget to display the current position of the video.
class CurrentTime extends StatelessWidget {
  /// Constructor for [CurrentTime].
  const CurrentTime({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<WebviewtubeController, String>(
      selector: (_, controller) =>
          _durationFormatter(controller.value.position.inMilliseconds),
      builder: (_, text, __) {
        return Text(
          text,
          style: _textStyle,
        );
      },
    );
  }
}

/// A widget to display the duration of the video.
class VideoDuration extends StatelessWidget {
  /// Constructor for [VideoDuration].
  const VideoDuration({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<WebviewtubeController, String>(
      selector: (_, controller) => _durationFormatter(
          controller.value.videoMetadata.duration.inMilliseconds),
      builder: (_, text, __) {
        return Text(text, style: _textStyle);
      },
    );
  }
}

/// Formats duration in milliseconds to xx:xx:xx format.
String _durationFormatter(int milliSeconds) {
  final duration = Duration(milliseconds: milliSeconds);
  final hours = duration.inHours.toInt();
  final hoursString = hours.toString().padLeft(2, '0');
  final minutes = duration.inMinutes - hours * 60;
  final minutesString = minutes.toString().padLeft(2, '0');
  final seconds = duration.inSeconds - (hours * 3600 + minutes * 60);
  final secondsString = seconds.toString().padLeft(2, '0');
  final formattedTime =
      '${hoursString == '00' ? '' : '$hoursString:'}$minutesString:$secondsString';

  return formattedTime;
}
