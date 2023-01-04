import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:provider/provider.dart';

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
  WebviewtubePlayer({
    Key? key,
    required this.videoId,
    WebviewtubeOptions? options,
    WebviewtubeController? controller,
  })  : _controller = controller,
        _options = options ?? const WebviewtubeOptions(),
        super(key: key);

  /// The video id of the video to play.
  final String videoId;

  /// Additional options to control the player.
  final WebviewtubeOptions _options;

  /// The controller to control the player.
  final WebviewtubeController? _controller;

  late final _child =
      _WebviewtubePlayerView(videoId: videoId, options: _options);

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
  const _WebviewtubePlayerView({
    Key? key,
    required this.videoId,
    required this.options,
  }) : super(key: key);

  final String videoId;

  final WebviewtubeOptions options;

  @override
  State<_WebviewtubePlayerView> createState() => _WebviewtubePlayerViewState();
}

class _WebviewtubePlayerViewState extends State<_WebviewtubePlayerView> {
  final Completer<WebViewController> _webviewController =
      Completer<WebViewController>();

  @override
  void deactivate() {
    // Pauses video when the player is not active
    context.read<WebviewtubeController>().pause();
    super.deactivate();
  }

  Set<JavascriptChannel> _buildJavascriptChannel() {
    return {
      JavascriptChannel(
          name: 'Webviewtube',
          onMessageReceived: (JavascriptMessage message) {
            Map<String, dynamic> json = jsonDecode(message.message);
            switch (json['method']) {
              case 'Ready':
                {
                  context.read<WebviewtubeController>().onReady();
                  if (widget.options.mute) {
                    context.read<WebviewtubeController>().mute();
                  }
                  break;
                }
              case 'StateChange':
                {
                  final data = json['args']['state'] as int;
                  context
                      .read<WebviewtubeController>()
                      .onPlayerStateChange(data);
                  break;
                }
              case 'PlaybackQualityChange':
                {
                  final data = json['args']['playbackQuality'] as String;
                  context
                      .read<WebviewtubeController>()
                      .onPlaybackQualityChange(data);
                  break;
                }
              case 'PlaybackRateChange':
                {
                  final data = json['args']['playbackRate'] as num;
                  context
                      .read<WebviewtubeController>()
                      .onPlaybackRateChange(data);
                  break;
                }
              case 'Errors':
                {
                  final data = json['args']['errorCode'] as int;
                  context.read<WebviewtubeController>().onError(data);
                  break;
                }
              case 'VideoData':
                {
                  final data = json['args'] as Map<String, dynamic>;
                  context.read<WebviewtubeController>().onVideoDataChange(data);
                  break;
                }
              case 'CurrentTime':
                {
                  final data = json['args'] as Map<String, dynamic>;
                  context
                      .read<WebviewtubeController>()
                      .onCurrentTimeChange(data);
                  break;
                }
            }
          }),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 0,
      color: Colors.black,
      child: AspectRatio(
        aspectRatio: widget.options.aspectRatio,
        child: WebView(
          onWebViewCreated: _onWebViewCreated,
          onWebResourceError: _onWebResourceError,
          javascriptMode: JavascriptMode.unrestricted,
          allowsInlineMediaPlayback: true,
          initialMediaPlaybackPolicy: AutoMediaPlaybackPolicy.always_allow,
          javascriptChannels: _buildJavascriptChannel(),
          userAgent: widget.options.forceHd ? hdUserAgent : null,
        ),
      ),
    );
  }

  void _onWebViewCreated(WebViewController webViewController) {
    webViewController.loadUrl(
      Uri.dataFromString(
        _generateIframePage(widget.videoId),
        mimeType: 'text/html',
        encoding: Encoding.getByName('utf-8'),
      ).toString(),
    );

    _webviewController.complete(webViewController);
    context.read<WebviewtubeController>().onWebviewCreated(webViewController);
  }

  void _onWebResourceError(WebResourceError error) =>
      context.read<WebviewtubeController>().onWebResourceError(error);

  String _generateIframePage(String videoId) {
    final options = widget.options;

    return '''
<!DOCTYPE html>
<html>
    <head>
        <style>
            html,
            body {
                margin: 0;
                padding: 0;
                background-color: #000000;
                overflow: hidden;
                position: fixed;
                height: 100%;
                width: 100%;
            }
        </style>
        <meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no'>
    </head>
<body>
    <div id="player"></div>

    <script>
        var tag = document.createElement('script');
        tag.src = "https://www.youtube.com/iframe_api";
        var firstScriptTag = document.getElementsByTagName('script')[0];
        firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);

        var player;
        var timerId;
        function onYouTubeIframeAPIReady() {
            player = new YT.Player('player', {
                height: '100%',
                width: '100%',
                videoId: '$videoId',
                playerVars: {
                    'autoplay': ${_boolean(options.autoPlay)},
                    'cc_load_policy': ${_boolean(options.enableCaption)},
                    'cc_lang_pref': '${options.captionLanguage}',
                    'controls': ${_boolean(options.showControls)},
                    'enablejsapi': 1,
                    'fs': 0,
                    'hl': '${options.interfaceLanguage}',
                    'iv_load_policy': 3,
                    'loop': ${_boolean(options.loop)},
                    'modestbranding': 1,
                    'playsinline': 1,
                    'rel': 0,
                    'start': ${options.startAt},
                    'end': ${options.endAt}
                },
                events: {
                    onReady: function (event) { sendMessageToDart('Ready'); },
                    onStateChange: function (event) { sendPlayerStateChange(event.data); },
                    onPlaybackQualityChange: function (event) { sendMessageToDart('PlaybackQualityChange', { 'playbackQuality': event.data }); },
                    onPlaybackRateChange: function (event) { sendMessageToDart('PlaybackRateChange', { 'playbackRate': event.data }); },
                    onError: function (error) { sendMessageToDart('Errors', { 'errorCode': error.data }); }
                }
            });
        }

        function sendMessageToDart(methodName, argsObject = {}) {
            var message = {
                'method': methodName,
                'args': argsObject
            };
            Webviewtube.postMessage(JSON.stringify(message));
        }

        function sendPlayerStateChange(playerState) {
            clearTimeout(timerId);
            sendMessageToDart('StateChange', { 'state': playerState });
            if (playerState == 1) {
                startSendCurrentTimeInterval();
                sendVideoData(player);
            }
        }

        function sendVideoData(player) {
            var videoData = {
                'duration': player.getDuration(),
                'title': player.getVideoData().title,
                'author': player.getVideoData().author,
                'videoId': player.getVideoData().video_id
            };
            sendMessageToDart('VideoData', videoData);
        }

        function startSendCurrentTimeInterval() {
            timerId = setInterval(function () {
                sendMessageToDart('CurrentTime',
                    {
                        'position': player.getCurrentTime(),
                        'buffered': player.getVideoLoadedFraction()
                    });
            }, ${options.currentTimeUpdateInterval});
        }


        function play() {
            player.playVideo();
        }

        function pause() {
            player.pauseVideo();
        }

        function loadById(loadSettings) {
            player.loadVideoById(loadSettings);
        }

        function cueById(cueSettings) {
            player.cueVideoById(cueSettings);
        }

        function loadPlaylist(playlist, index, startAt) {
            player.loadPlaylist(playlist, index, startAt);
        }

        function cuePlaylist(playlist, index, startAt) {
            player.cuePlaylist(playlist, index, startAt);
        }

        function nextVideo() {
          player.nextVideo();
        }

        function previousVideo() {
          player.previousVideo();
        }

        function playVideoAt(index) {
          player.playVideoAt(index);
        }

        function mute() {
            player.mute();
        }

        function unMute() {
            player.unMute();
        }

        function seekTo(seconds, allowSeekAhead) {
            player.seekTo(seconds, allowSeekAhead);
        }

        function setSize(width, height) {
            player.setSize(width, height);
        }

        function setPlaybackRate(rate) {
            player.setPlaybackRate(rate);
        }
    </script>
</body>

</html>
''';
  }
}

int _boolean(bool value) => value ? 1 : 0;

/// The user agent to force the video plays in HD.
String hdUserAgent =
    'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/101.0.4951.64 Safari/537.36';
