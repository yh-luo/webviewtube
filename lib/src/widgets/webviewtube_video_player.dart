import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../webviewtube.dart';
import 'duration_indicator.dart';
import 'widgets.dart';

/// Signature for a builder that builds the loading overlay.
///
/// [isReady] is `true` once the player has finished initializing.
typedef WebviewtubeLoadingBuilder = Widget Function(
  BuildContext context,
  bool isReady,
);

/// Signature for a builder that builds the controls overlay.
///
/// [playerState] reflects the current playback state.
typedef WebviewtubeControlsBuilder = Widget Function(
  BuildContext context,
  PlayerState playerState,
);

/// Signature for a builder that builds the progress bar overlay.
///
/// [playerState] reflects the current playback state.
typedef WebviewtubeProgressBarBuilder = Widget Function(
  BuildContext context,
  PlayerState playerState,
);

/// {@template webviewtube_video_player}
/// A widgets-decorated [WebviewtubePlayer].
///
/// It's less performant but has more customized widgets. The player can be
/// configured by [options] and controlled by [controller]. If a controller is
/// not provided, a [WebviewtubeController] with default options will be created
/// using `ChangeNotifierProvider` constructor. It will be automatically
/// disposed when the [WebviewtubeVideoPlayer] widget is removed from the
/// widget tree. Otherwise the user is responsible for disposing the given
/// controller.
///
/// Example:
/// ```dart
/// Scaffold(
///   body: WebviewtubeVideoPlayer(videoId: '4AoFA19gbLo'),
/// );
/// ```
///
/// With controller:
/// ```dart
/// final webviewtubeController = WebviewtubeController(
///   options: const WebviewtubeOptions(showControls: false));
///
/// // Remember to dispose the controller to avoid memory leak
/// @override
/// void dispose() {
///   webviewtubeController.dispose();
///   super.dispose();
/// }
///
/// Scaffold(
///   body: WebviewtubeVideoPlayer(
///     videoId: '4AoFA19gbLo',
///     controller: webviewtubeController),
/// );
/// ```
/// {@endtemplate}
class WebviewtubeVideoPlayer extends StatelessWidget {
  /// {@macro webviewtube_video_player}
  WebviewtubeVideoPlayer({
    super.key,
    required this.videoId,
    WebviewtubeController? controller,
    this.loadingIndicatorColor,
    this.controlsColor,
    this.progressBarStyle,
    this.loadingBuilder,
    this.controlsBuilder,
    this.progressBarBuilder,
  }) : _controller = controller;

  /// The video id of the video to play.
  final String videoId;

  /// The controller to control the player.
  final WebviewtubeController? _controller;

  /// Color for the default loading indicator. Ignored if [loadingBuilder] is
  /// provided.
  final Color? loadingIndicatorColor;

  /// Color for the default controls (icons and text). Ignored if
  /// [controlsBuilder] is provided.
  final Color? controlsColor;

  /// Style for the default progress bar. Ignored if [progressBarBuilder] is
  /// provided.
  final ProgressBarStyle? progressBarStyle;

  /// Builder for the loading overlay. Receives [isReady] to indicate whether
  /// the player is ready. Defaults to [LoadingIndicator]. When provided,
  /// [loadingIndicatorColor] is ignored.
  final WebviewtubeLoadingBuilder? loadingBuilder;

  /// Builder for the controls overlay. Receives [playerState] to reflect the
  /// current playback state. Defaults to replay, duration, volume, and speed
  /// controls. When provided, [controlsColor] is ignored.
  final WebviewtubeControlsBuilder? controlsBuilder;

  /// Builder for the progress bar overlay. Receives [playerState] to reflect
  /// the current playback state. Defaults to [ProgressBar]. When provided,
  /// [progressBarStyle] is ignored.
  final WebviewtubeProgressBarBuilder? progressBarBuilder;

  late final _child = _WebviewtubeVideoPlayerView(
    videoId: videoId,
    loadingBuilder: loadingBuilder ??
        (context, isReady) =>
            _defaultLoadingBuilder(context, isReady, loadingIndicatorColor),
    controlsBuilder: controlsBuilder ??
        (context, playerState) =>
            _defaultControlsBuilder(context, playerState, controlsColor),
    progressBarBuilder: progressBarBuilder ??
        (context, playerState) =>
            _defaultProgressBarBuilder(context, playerState, progressBarStyle),
  );

  @override
  Widget build(BuildContext context) {
    final controller = _controller;

    return controller != null
        ? ChangeNotifierProvider<WebviewtubeController>.value(
            value: controller,
            child: _child,
          )
        : ChangeNotifierProvider<WebviewtubeController>(
            create: (_) => WebviewtubeController(
                options: const WebviewtubeOptions(showControls: false)),
            child: _child,
          );
  }
}

/// The player view.
class _WebviewtubeVideoPlayerView extends StatelessWidget {
  const _WebviewtubeVideoPlayerView({
    required this.videoId,
    required this.loadingBuilder,
    required this.controlsBuilder,
    required this.progressBarBuilder,
  });

  /// The video id of the video to play.
  final String videoId;

  final WebviewtubeLoadingBuilder loadingBuilder;
  final WebviewtubeControlsBuilder controlsBuilder;
  final WebviewtubeProgressBarBuilder progressBarBuilder;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        WebviewtubePlayer(
          videoId: videoId,
          controller: context.read<WebviewtubeController>(),
        ),
        Selector<WebviewtubeController, bool>(
          selector: (_, controller) => controller.value.isReady,
          builder: (context, isReady, __) => loadingBuilder(context, isReady),
        ),
        Selector<WebviewtubeController, PlayerState>(
          selector: (_, controller) => controller.value.playerState,
          builder: (context, playerState, __) =>
              controlsBuilder(context, playerState),
        ),
        Selector<WebviewtubeController, PlayerState>(
          selector: (_, controller) => controller.value.playerState,
          builder: (context, playerState, __) =>
              progressBarBuilder(context, playerState),
        ),
      ],
    );
  }
}

Widget _defaultLoadingBuilder(
  BuildContext context,
  bool isReady, [
  Color? color,
]) {
  if (isReady) return const SizedBox.shrink();
  return LoadingIndicator(color: color ?? Colors.white);
}

/// Fades out and disables pointer events while [hide] is true.
class _HideWhenPlaying extends StatelessWidget {
  const _HideWhenPlaying({required this.hide, required this.child});

  final bool hide;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: hide ? 0 : 1,
      duration: const Duration(milliseconds: 300),
      child: IgnorePointer(ignoring: hide, child: child),
    );
  }
}

Widget _defaultControlsBuilder(
  BuildContext context,
  PlayerState playerState, [
  Color? color,
]) {
  final textStyle = kDefaultControlTextStyle.copyWith(color: color);
  final iconColor = textStyle.color ?? Colors.white;

  if (playerState == PlayerState.ended) {
    return Positioned(
      left: 10,
      bottom: -5,
      child: IconButton(
        onPressed: () => context.read<WebviewtubeController>().replay(),
        icon: Icon(Icons.replay, color: iconColor),
      ),
    );
  }

  return Positioned(
    left: 10,
    bottom: -5,
    child: _HideWhenPlaying(
      hide: playerState == PlayerState.playing,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          DurationIndicator(textStyle: textStyle),
          VolumeButton(color: iconColor),
          PlaybackSpeedButton(color: iconColor),
        ],
      ),
    ),
  );
}

Widget _defaultProgressBarBuilder(
  BuildContext context,
  PlayerState playerState, [
  ProgressBarStyle? style,
]) {
  return Positioned(
    left: 5,
    right: 5,
    bottom: 35,
    child: _HideWhenPlaying(
      hide: playerState == PlayerState.playing,
      child: ProgressBar(style: style),
    ),
  );
}
