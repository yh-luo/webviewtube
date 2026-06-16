import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../webviewtube.dart';

/// {@template progress_bar}
/// A widget to display the progress bar of the video.
///
/// Colors and dimensions can be configured with [ProgressBarStyle].
/// {@endtemplate}
class ProgressBar extends StatefulWidget {
  /// {@macro progress_bar}
  const ProgressBar({super.key, this.style});

  /// Defines colors and dimensions for the [ProgressBar].
  final ProgressBarStyle? style;

  @override
  State<ProgressBar> createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar> {
  Duration _position = Duration.zero;
  bool _touchDown = false;
  bool _positionChanged = false;

  ProgressBarStyle get _style => widget.style ?? const ProgressBarStyle();

  Duration _getRelativePosition(Offset globalPosition) {
    final box = context.findRenderObject() as RenderBox;
    var touchPoint = box.globalToLocal(globalPosition);
    if (touchPoint.dx <= 0) {
      touchPoint = Offset(0, touchPoint.dy);
    }
    if (touchPoint.dx >= context.size!.width) {
      touchPoint = Offset(context.size!.width, touchPoint.dy);
    }

    final relative = touchPoint.dx / box.size.width;
    final position =
        context.read<WebviewtubeController>().value.videoMetadata.duration *
        relative;

    return position;
  }

  void _onHorizontalDragDown(DragDownDetails details) {
    setState(() {
      _touchDown = true;
      _position = _getRelativePosition(details.globalPosition);
      _positionChanged = true;
    });
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _position = _getRelativePosition(details.globalPosition);
      _positionChanged = true;
    });
  }

  void _onHorizontalDragEnd() {
    setState(() {
      _touchDown = false;
      _positionChanged = false;
    });
    context.read<WebviewtubeController>().seekTo(
      _position,
      allowSeekAhead: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onHorizontalDragDown: _onHorizontalDragDown,
      onHorizontalDragUpdate: _onHorizontalDragUpdate,
      onHorizontalDragEnd: (_) => _onHorizontalDragEnd(),
      onHorizontalDragCancel: _onHorizontalDragEnd,
      child: Consumer<WebviewtubeController>(
        builder: (context, controller, _) {
          var playedRatio = 0.0;
          final durationMs =
              controller.value.videoMetadata.duration.inMilliseconds;
          if (durationMs != 0) {
            double val;
            if (_positionChanged) {
              val = _position.inMilliseconds / durationMs;
            } else {
              val = controller.value.position.inMilliseconds / durationMs;
            }

            playedRatio = double.parse(val.toStringAsFixed(3));
          }

          return CustomPaint(
            size: Size(MediaQuery.of(context).size.width, _style.barHeight),
            painter: _ProgressBarPainter(
              progressWidth: _style.progressWidth,
              handleRadius: _style.handleRadius,
              playedRatio: playedRatio,
              bufferedRatio: controller.value.buffered,
              backgroundColor: _style.backgroundColor,
              playedColor: _style.playedColor,
              bufferedColor: _style.bufferedColor,
              handleColor: _style.handleColor,
              touchDown: _touchDown,
            ),
          );
        },
      ),
    );
  }
}

class _ProgressBarPainter extends CustomPainter {
  _ProgressBarPainter({
    required this.progressWidth,
    required this.handleRadius,
    required this.playedRatio,
    required this.bufferedRatio,
    required this.touchDown,
    required this.backgroundColor,
    required this.playedColor,
    required this.bufferedColor,
    required this.handleColor,
  });

  final double progressWidth;
  final double handleRadius;
  final double playedRatio;
  final double bufferedRatio;
  final bool touchDown;
  final Color backgroundColor;
  final Color playedColor;
  final Color bufferedColor;
  final Color handleColor;

  @override
  bool shouldRepaint(_ProgressBarPainter oldDelegate) {
    return playedRatio != oldDelegate.playedRatio ||
        bufferedRatio != oldDelegate.bufferedRatio ||
        touchDown != oldDelegate.touchDown ||
        backgroundColor != oldDelegate.backgroundColor ||
        playedColor != oldDelegate.playedColor ||
        bufferedColor != oldDelegate.bufferedColor ||
        handleColor != oldDelegate.handleColor ||
        progressWidth != oldDelegate.progressWidth ||
        handleRadius != oldDelegate.handleRadius;
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

    paint.color = backgroundColor;
    canvas.drawLine(startPoint, endPoint, paint);

    paint.color = bufferedColor;
    canvas.drawLine(startPoint, secondProgressPoint, paint);

    paint.color = playedColor;
    canvas.drawLine(startPoint, progressPoint, paint);

    handlePaint.color = Colors.transparent;
    canvas.drawCircle(progressPoint, centerY, handlePaint);

    if (touchDown) {
      handlePaint.color = handleColor.withValues(alpha: 0.4);
      canvas.drawCircle(progressPoint, handleRadius * 3, handlePaint);
    }

    handlePaint.color = handleColor;
    canvas.drawCircle(progressPoint, handleRadius, handlePaint);
  }
}
