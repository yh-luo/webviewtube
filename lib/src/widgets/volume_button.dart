import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../webviewtube.dart';

/// {@template volume_button}
/// A widget to display buttons to mute/unmute the video.
/// {@endtemplate}
class VolumeButton extends StatelessWidget {
  /// {@macro volume_button}
  const VolumeButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        final controller = context.read<WebviewtubeController>();
        if (controller.value.isMuted) {
          controller.unMute();
        } else {
          controller.mute();
        }
      },
      icon: Selector<WebviewtubeController, bool>(
        selector: (_, controller) => controller.value.isMuted,
        builder: (context, isMuted, __) {
          switch (isMuted) {
            case true:
              return const Icon(
                Icons.volume_up,
                color: Colors.white,
                shadows: <Shadow>[
                  Shadow(
                      offset: Offset(1, 1),
                      blurRadius: 5,
                      color: Colors.black87)
                ],
              );
            default:
              return const Icon(
                Icons.volume_off,
                color: Colors.white,
                shadows: <Shadow>[
                  Shadow(
                      offset: Offset(1, 1),
                      blurRadius: 5,
                      color: Colors.black87)
                ],
              );
          }
        },
      ),
    );
  }
}
