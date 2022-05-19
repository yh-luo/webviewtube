import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../webviewtube.dart';

class ActionButton extends StatefulWidget {
  const ActionButton({
    super.key,
  });

  @override
  State<ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton>
    with TickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      value: 0,
      duration: const Duration(milliseconds: 150),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Selector<WebviewtubeController, PlayerState>(
      selector: (_, controller) => controller.value.playerState,
      builder: (context, playerState, __) {
        switch (playerState) {
          case PlayerState.playing:
            _animationController.forward();
            break;
          case PlayerState.paused:
            _animationController.reverse();
            break;
          default:
            break;
        }

        return InkWell(
          onTap: () {
            if (playerState == PlayerState.playing) {
              context.read<WebviewtubeController>().pause();
            } else if (playerState == PlayerState.paused) {
              context.read<WebviewtubeController>().play();
            }
          },
          child: AnimatedIcon(
            icon: AnimatedIcons.play_pause,
            progress: _animationController.view,
            color: Colors.red,
            size: 60.0,
          ),
        );
      },
    );
  }
}
