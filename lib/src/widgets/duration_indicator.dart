import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../webviewtube.dart';

const textStyle = TextStyle(
  color: Colors.white,
  shadows: <Shadow>[
    Shadow(offset: Offset(1, 1), blurRadius: 5, color: Colors.black87),
  ],
);

class DurationIndicator extends StatelessWidget {
  const DurationIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: const <Widget>[
        CurrentTime(),
        Text(
          ' / ',
          style: textStyle,
        ),
        VideoDuration(),
      ],
    );
  }
}

class CurrentTime extends StatelessWidget {
  const CurrentTime({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<WebviewtubeController, String>(
      selector: (_, controller) =>
          durationFormatter(controller.value.position.inMilliseconds),
      builder: (_, text, __) {
        return Text(
          text,
          style: textStyle,
        );
      },
    );
  }
}

class VideoDuration extends StatelessWidget {
  const VideoDuration({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<WebviewtubeController, String>(
      selector: (_, controller) => durationFormatter(
          controller.value.videoMetadata.duration.inMilliseconds),
      builder: (_, text, __) {
        return Text(text, style: textStyle);
      },
    );
  }
}

/// Formats duration in milliseconds to xx:xx:xx format.
String durationFormatter(int milliSeconds) {
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
