import 'package:flutter/material.dart';

/// {@template progress_bar_colors}
/// Colors for [ProgressBar].
/// {@endtemplate}
@immutable
class ProgressBarColors {
  /// {@macro progress_bar_colors}
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
      playedColor: playedColor ?? this.playedColor,
      bufferedColor: bufferedColor ?? this.bufferedColor,
      handleColor: handleColor ?? this.handleColor,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is ProgressBarColors &&
      other.backgroundColor == backgroundColor &&
      other.playedColor == playedColor &&
      other.bufferedColor == bufferedColor &&
      other.handleColor == handleColor;

  @override
  int get hashCode => Object.hash(
      runtimeType, backgroundColor, playedColor, bufferedColor, handleColor);

  @override
  String toString() {
    return 'ProgressBarColors('
        'backgroundColor: $backgroundColor, '
        'playedColor: $playedColor, '
        'bufferedColor: $bufferedColor, '
        'handleColor: $handleColor)';
  }
}
