import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../webviewtube.dart';
import 'duration_indicator.dart';

/// {@template volume_button}
/// A widget to display buttons to mute/unmute the video.
/// {@endtemplate}
class VolumeButton extends StatelessWidget {
  /// {@macro volume_button}
  const VolumeButton({super.key, this.color = Colors.white});

  /// The color of the volume icon. Defaults to [Colors.white].
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        final controller = context.read<WebviewtubeController>();
        if (controller.value.isMuted) {
          await controller.unMute();
        } else {
          await controller.mute();
        }
      },
      icon: Selector<WebviewtubeController, bool>(
        selector: (_, controller) => controller.value.isMuted,
        builder: (context, isMuted, __) {
          return Icon(
            isMuted ? Icons.volume_up : Icons.volume_off,
            color: color,
            shadows: kDefaultControlTextStyle.shadows,
          );
        },
      ),
    );
  }
}
