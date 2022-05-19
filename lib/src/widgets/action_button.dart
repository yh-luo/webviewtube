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
    return InkWell(
      onTap: () {
        if (context.read<WebviewtubeController>().value.playerState ==
            PlayerState.playing) {
          context.read<WebviewtubeController>().pause();
        } else if (context.read<WebviewtubeController>().value.playerState ==
            PlayerState.paused) {
          context.read<WebviewtubeController>().play();
        }
      },
      child: Selector<WebviewtubeController, PlayerState>(
        selector: (_, controller) => controller.value.playerState,
        builder: (_, playerState, __) {
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

          return AnimatedIcon(
            icon: AnimatedIcons.play_pause,
            progress: _animationController.view,
            color: Colors.red,
            size: 60.0,
          );
        },
      ),
    );
  }
}

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(Colors.white),
    );
  }
}
