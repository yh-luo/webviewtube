// ignore_for_file: depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../webviewtube.dart';

/// {@template webviewtube_player}
/// Plays YouTube videos using the official [YouTube IFrame Player API](https://developers.google.com/youtube/iframe_api_reference).
///
/// The player can be configured by [options] and controlled by [controller].
/// If a controller is not provided, a [WebviewtubeController] with default
/// options will be created using `ChangeNotifierProvider` constructor. It will
/// be automatically disposed when the [WebviewtubePlayer] widget is removed
/// from the widget tree. Otherwise the user is responsible for disposing the
/// given controller.
///
/// Example:
/// ```dart
/// Scaffold(
///  body: WebviewtubePlayer(videoId: '4AoFA19gbLo'),
/// );
/// ```
///
/// With controller:
/// ```dart
/// final webviewtubeController = WebviewtubeController();
///
/// // Remember to dispose the controller to avoid memory leak
/// @override
/// void dispose() {
///   webviewtubeController.dispose();
///   super.dispose();
/// }
///
/// Scaffold(
///   body: WebviewtubePlayer(
///     videoId: '4AoFA19gbLo',
///     controller: webviewtubeController),
/// );
/// ```
/// {@endtemplate}
class WebviewtubePlayer extends StatelessWidget {
  /// {@macro webviewtube_player}
  WebviewtubePlayer(
      {Key? key, required this.videoId, WebviewtubeController? controller})
      : _controller = controller,
        super(key: key);

  /// The video id of the video to play.
  final String videoId;

  /// The controller to control the player.
  final WebviewtubeController? _controller;

  late final _child = _WebviewtubePlayerView(videoId: videoId);

  @override
  Widget build(BuildContext context) {
    final controller = _controller;

    return controller != null
        ? ChangeNotifierProvider<WebviewtubeController>.value(
            value: controller,
            child: _child,
          )
        : ChangeNotifierProvider<WebviewtubeController>(
            create: (_) => WebviewtubeController(),
            child: _child,
          );
  }
}

class _WebviewtubePlayerView extends StatefulWidget {
  const _WebviewtubePlayerView({Key? key, required this.videoId})
      : super(key: key);

  final String videoId;

  @override
  State<_WebviewtubePlayerView> createState() => _WebviewtubePlayerViewState();
}

class _WebviewtubePlayerViewState extends State<_WebviewtubePlayerView> {
  @override
  void initState() {
    super.initState();
    context.read<WebviewtubeController>().init(widget.videoId);
  }

  @override
  void deactivate() {
    // Pauses video when the player is not active
    context.read<WebviewtubeController>().pause();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 0,
      color: Colors.black,
      child: AspectRatio(
        aspectRatio: context.read<WebviewtubeController>().options.aspectRatio,
        child: WebViewWidget(
            controller:
                context.read<WebviewtubeController>().webViewController),
      ),
    );
  }
}
