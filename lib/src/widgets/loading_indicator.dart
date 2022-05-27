import 'package:flutter/material.dart';

/// A widget to indicate the playing is loading the video.
class LoadingIndicator extends StatelessWidget {
  /// Constructor for [LoadingIndicator].
  const LoadingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(Colors.red),
    );
  }
}
