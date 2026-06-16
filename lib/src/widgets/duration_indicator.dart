import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../webviewtube.dart';

const kDefaultControlTextStyle = TextStyle(
  color: Colors.white,
  shadows: <Shadow>[
    Shadow(offset: Offset(1, 1), blurRadius: 5, color: Colors.black87),
  ],
);

/// {@template duration_indicator}
/// A widget to display the current position and the remaining duration of the
/// video.
///
/// The [textStyle] parameter can be used to customize the text style of the
/// duration indicator. If not provided, it will use a default text style with
/// white color and a black shadow.
/// {@endtemplate}
class DurationIndicator extends StatelessWidget {
  /// {@macro duration_indicator}
  const DurationIndicator({
    super.key,
    this.textStyle = kDefaultControlTextStyle,
  });

  /// The text style for the duration indicator.
  /// Defaults to [kDefaultControlTextStyle].
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        CurrentTime(textStyle: textStyle),
        Text(' / ', style: textStyle),
        VideoDuration(textStyle: textStyle),
      ],
    );
  }
}

/// A widget to display the current position of the video.
///
/// The [textStyle] parameter can be used to customize the text style of the
/// duration indicator. If not provided, it will use a default text style with
/// white color and a black shadow.
class CurrentTime extends StatelessWidget {
  /// Constructor for [CurrentTime].
  const CurrentTime({
    super.key,
    this.textStyle = kDefaultControlTextStyle,
  });

  /// The text style for the current time. Defaults to [kDefaultControlTextStyle].
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return Selector<WebviewtubeController, String>(
      selector: (_, controller) =>
          _durationFormatter(controller.value.position.inMilliseconds),
      builder: (_, text, __) => Text(text, style: textStyle),
    );
  }
}

/// A widget to display the duration of the video.
///
/// The [textStyle] parameter can be used to customize the text style of the
/// duration indicator. If not provided, it will use a default text style with
/// white color and a black shadow.
class VideoDuration extends StatelessWidget {
  /// Constructor for [VideoDuration].
  const VideoDuration({
    super.key,
    this.textStyle = kDefaultControlTextStyle,
  });

  /// The text style for the video duration. Defaults to [kDefaultControlTextStyle].
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return Selector<WebviewtubeController, String>(
      selector: (_, controller) => _durationFormatter(
        controller.value.videoMetadata.duration.inMilliseconds,
      ),
      builder: (_, text, __) => Text(text, style: textStyle),
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
