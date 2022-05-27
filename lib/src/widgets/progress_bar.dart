import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../webviewtube.dart';

/// Colors for [ProgressBar].
@immutable
class ProgressBarColors {
  /// Constructor for [ProgressBarColors].
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

  /// Returns a new [ProgressBarColors] with updated parameters.
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

/// A widget to display the progress bar of the video.
class ProgressBar extends StatefulWidget {
  /// Constructor for [ProgressBar].
  const ProgressBar({Key? key, this.colors}) : super(key: key);

  /// Defines colors for the [ProgressBar]. If null,
  /// `Theme.of(context).colorScheme.secondary` is used.
  final ProgressBarColors? colors;

  @override
  State<ProgressBar> createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar> {
  late ProgressBarColors colors;
  Duration _position = Duration.zero;
  bool _touchDown = false;
  bool _positionChanged = false;

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
    context
        .read<WebviewtubeController>()
        .seekTo(_position, allowSeekAhead: true);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onHorizontalDragDown: _onHorizontalDragDown,
      onHorizontalDragUpdate: _onHorizontalDragUpdate,
      onHorizontalDragEnd: (_) => _onHorizontalDragEnd(),
      onHorizontalDragCancel: _onHorizontalDragEnd,
      child: Consumer<WebviewtubeController>(builder: (context, controller, _) {
        var playedRatio = 0.0;
        final durationMs =
            controller.value.videoMetadata.duration.inMilliseconds;
        if (!durationMs.isNaN && durationMs != 0) {
          double val;
          if (_positionChanged) {
            val = _position.inMilliseconds / durationMs;
            _positionChanged = false;
          } else {
            val = controller.value.position.inMilliseconds / durationMs;
          }

          playedRatio = double.parse(val.toStringAsFixed(3));
        }

        return CustomPaint(
          size: Size(MediaQuery.of(context).size.width, 12),
          painter: _ProgressBarPainter(
            progressWidth: 3.0,
            handleRadius: 6.0,
            playedRatio: playedRatio,
            bufferedRatio: controller.value.buffered,
            colors: colors,
            touchDown: _touchDown,
          ),
        );
      }),
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
    required this.colors,
  });

  final double progressWidth;
  final double handleRadius;
  final double playedRatio;
  final double bufferedRatio;
  final bool touchDown;
  final ProgressBarColors colors;

  @override
  bool shouldRepaint(_ProgressBarPainter oldDelegate) {
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
