import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../webviewtube.dart';

class DurationIndicator extends StatelessWidget {
  const DurationIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: const [
        CurrentTime(),
        Text(' / '),
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
        return Text(text);
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
        return Text(text);
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
