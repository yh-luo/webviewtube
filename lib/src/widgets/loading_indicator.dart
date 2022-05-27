import 'package:flutter/material.dart';

/// A widget to indicate the playing is loading the video.
class LoadingIndicator extends StatelessWidget {
  /// Constructor for [LoadingIndicator].
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
