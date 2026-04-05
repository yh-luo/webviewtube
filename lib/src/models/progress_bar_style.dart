import 'package:flutter/material.dart';

/// {@template progress_bar_style}
/// Style configuration for [ProgressBar], covering both colors and dimensions.
/// {@endtemplate}
@immutable
class ProgressBarStyle {
  /// {@macro progress_bar_style}
  const ProgressBarStyle({
    this.backgroundColor = Colors.white38,
    this.playedColor = Colors.white,
    this.bufferedColor = Colors.white70,
    this.handleColor = Colors.white,
    this.barHeight = 14.0,
    this.progressWidth = 4.0,
    this.handleRadius = 7.0,
  });

  /// The background track color. Defaults to [Colors.white38].
  final Color backgroundColor;

  /// The color of the played portion. Defaults to [Colors.white].
  final Color playedColor;

  /// The color of the buffered portion. Defaults to [Colors.white70].
  final Color bufferedColor;

  /// The color of the seek handle. Defaults to [Colors.white].
  final Color handleColor;

  /// The total height of the progress bar widget. Defaults to `14.0`.
  final double barHeight;

  /// The stroke width of the progress track. Defaults to `4.0`.
  final double progressWidth;

  /// The radius of the seek handle. Defaults to `7.0`.
  final double handleRadius;

  /// Returns a new [ProgressBarStyle] with updated parameters.
  ProgressBarStyle copyWith({
    Color? backgroundColor,
    Color? playedColor,
    Color? bufferedColor,
    Color? handleColor,
    double? barHeight,
    double? progressWidth,
    double? handleRadius,
  }) {
    return ProgressBarStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      playedColor: playedColor ?? this.playedColor,
      bufferedColor: bufferedColor ?? this.bufferedColor,
      handleColor: handleColor ?? this.handleColor,
      barHeight: barHeight ?? this.barHeight,
      progressWidth: progressWidth ?? this.progressWidth,
      handleRadius: handleRadius ?? this.handleRadius,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is ProgressBarStyle &&
      other.runtimeType == runtimeType &&
      other.backgroundColor == backgroundColor &&
      other.playedColor == playedColor &&
      other.bufferedColor == bufferedColor &&
      other.handleColor == handleColor &&
      other.barHeight == barHeight &&
      other.progressWidth == progressWidth &&
      other.handleRadius == handleRadius;

  @override
  int get hashCode => Object.hash(runtimeType, backgroundColor, playedColor,
      bufferedColor, handleColor, barHeight, progressWidth, handleRadius);

  @override
  String toString() {
    return 'ProgressBarStyle('
        'backgroundColor: $backgroundColor, '
        'playedColor: $playedColor, '
        'bufferedColor: $bufferedColor, '
        'handleColor: $handleColor, '
        'barHeight: $barHeight, '
        'progressWidth: $progressWidth, '
        'handleRadius: $handleRadius)';
  }
}
