import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../webviewtube.dart';

/// A widget to display buttons to play, pause and replay the video.
class ActionButton extends StatefulWidget {
  /// Constructor for [ActionButton].
  const ActionButton({Key? key}) : super(key: key);

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
        final playerState =
            context.read<WebviewtubeController>().value.playerState;
        if (playerState == PlayerState.playing) {
          context.read<WebviewtubeController>().pause();
        } else if (playerState == PlayerState.paused) {
          context.read<WebviewtubeController>().play();
        } else if (playerState == PlayerState.ended) {
          context.read<WebviewtubeController>().replay();
        }
      },
      child: Selector<WebviewtubeController, PlayerState>(
        selector: (_, controller) => controller.value.playerState,
        builder: (context, playerState, __) {
          switch (playerState) {
            case PlayerState.playing:
              _animationController.forward();
              break;
            case PlayerState.paused:
              _animationController.reverse();
              break;
            case PlayerState.ended:
              return const Icon(Icons.replay, color: Colors.red, size: 60.0);
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
