import 'package:flutter/material.dart';

/// {@template loading_indicator}
/// A widget to indicate the playing is loading the video.
/// {@endtemplate}
class LoadingIndicator extends StatelessWidget {
  /// {@macro loading_indicator}
  const LoadingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 50,
      height: 50,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(Colors.white),
      ),
    );
  }
}
