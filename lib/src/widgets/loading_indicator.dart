import 'package:flutter/material.dart';

/// {@template loading_indicator}
/// A widget to indicate the player is loading the video.
///
/// The [color] parameter can be used to customize the color of the loading
/// indicator.
/// {@endtemplate}
class LoadingIndicator extends StatelessWidget {
  /// {@macro loading_indicator}
  const LoadingIndicator({super.key, this.color = Colors.white});

  /// The color of the loading indicator. Defaults to [Colors.white].
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 50,
      child: CircularProgressIndicator(color: color),
    );
  }
}
