import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../webviewtube.dart';

class VolumeButton extends StatelessWidget {
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
              return Icon(Icons.volume_up, color: Colors.red);
            case false:
              return Icon(Icons.volume_off, color: Colors.red);
          }

          throw Exception();
        },
      ),
    );
  }
}
