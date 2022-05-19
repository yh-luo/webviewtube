import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webviewtube/webviewtube.dart';

/// Defines different colors for [ProgressBar].
class ProgressBarColors {
  /// Creates [ProgressBarColors].
  const ProgressBarColors({
    required this.backgroundColor,
    required this.playedColor,
    required this.bufferedColor,
    required this.handleColor,
  });

  /// Defines background color of the [ProgressBar].
  final Color backgroundColor;

  /// Defines color for played portion of the [ProgressBar].
  final Color playedColor;

  /// Defines color for buffered portion of the [ProgressBar].
  final Color bufferedColor;

  /// Defines color for handle of the [ProgressBar].
  final Color handleColor;

  ProgressBarColors copyWith({
    Color? backgroundColor,
    Color? playedColor,
    Color? bufferedColor,
    Color? handleColor,
  }) {
    return ProgressBarColors(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      handleColor: handleColor ?? this.handleColor,
      bufferedColor: bufferedColor ?? this.bufferedColor,
      playedColor: playedColor ?? this.playedColor,
    );
  }
}

class ProgressBar extends StatefulWidget {
  const ProgressBar({Key? key, this.colors}) : super(key: key);

  final ProgressBarColors? colors;

  @override
  State<ProgressBar> createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar> {
  late final ProgressBarColors colors;
  bool touchDown = false;

  @override
  void didChangeDependencies() {
    colors = widget.colors ??
        ProgressBarColors(
            backgroundColor:
                Theme.of(context).colorScheme.secondary.withOpacity(0.38),
            playedColor: Theme.of(context).colorScheme.secondary,
            bufferedColor: Colors.white70,
            handleColor: Theme.of(context).colorScheme.secondary);
    super.didChangeDependencies();
  }

  // TODO: add drag-and-seek capibility with GestureDetector
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      width: MediaQuery.of(context).size.width,
      child: Consumer<WebviewtubeController>(builder: (context, controller, _) {
        var playedRatio = 0.0;
        final durationMs =
            controller.value.videoMetadata.duration.inMilliseconds;
        if (!durationMs.isNaN && durationMs != 0) {
          final val = controller.value.position.inMilliseconds / durationMs;
          playedRatio = double.parse(val.toStringAsFixed(3));
        }

        return CustomPaint(
          painter: ProgressBarPainter(
            progressWidth: 2.0,
            handleRadius: 5.0,
            playedRatio: playedRatio,
            bufferedRatio: controller.value.buffered,
            colors: colors,
            touchDown: touchDown,
          ),
        );
      }),
    );
  }
}

class ProgressBarPainter extends CustomPainter {
  ProgressBarPainter({
    required this.progressWidth,
    required this.handleRadius,
    required this.playedRatio,
    required this.bufferedRatio,
    required this.touchDown,
    required this.colors,
  });

  final double progressWidth;
  final double handleRadius;
  final double playedRatio;
  final double bufferedRatio;
  final bool touchDown;
  final ProgressBarColors colors;

  @override
  bool shouldRepaint(ProgressBarPainter oldDelegate) {
    return playedRatio != oldDelegate.playedRatio ||
        bufferedRatio != oldDelegate.bufferedRatio ||
        touchDown != oldDelegate.touchDown;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..isAntiAlias = true
      ..strokeCap = StrokeCap.square
      ..strokeWidth = progressWidth;
    final handlePaint = Paint()..isAntiAlias = true;

    final centerY = size.height / 2.0;
    final barLength = size.width - handleRadius * 2.0;

    final startPoint = Offset(handleRadius, centerY);
    final endPoint = Offset(size.width - handleRadius, centerY);
    final progressPoint = Offset(
      barLength * playedRatio + handleRadius,
      centerY,
    );
    final secondProgressPoint = Offset(
      barLength * bufferedRatio + handleRadius,
      centerY,
    );

    paint.color = colors.backgroundColor;
    canvas.drawLine(startPoint, endPoint, paint);

    paint.color = colors.bufferedColor;
    canvas.drawLine(startPoint, secondProgressPoint, paint);

    paint.color = colors.playedColor;
    canvas.drawLine(startPoint, progressPoint, paint);

    handlePaint.color = Colors.transparent;
    canvas.drawCircle(progressPoint, centerY, handlePaint);

    if (touchDown) {
      handlePaint.color = colors.handleColor.withOpacity(0.4);
      canvas.drawCircle(progressPoint, handleRadius * 3, handlePaint);
    }

    handlePaint.color = colors.handleColor;
    canvas.drawCircle(progressPoint, handleRadius, handlePaint);
  }
}
