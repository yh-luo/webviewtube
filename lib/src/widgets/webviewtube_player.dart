import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:provider/provider.dart';

import '../webviewtube.dart';
import 'widgets.dart';

class WebviewtubePlayer extends StatelessWidget {
  const WebviewtubePlayer(this.videoId, {super.key});
  final String videoId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => WebviewtubeController(),
        child: WebviewtubePlayerView(videoId));
  }
}

class WebviewtubePlayerView extends StatefulWidget {
  const WebviewtubePlayerView(this.videoId, {super.key});

  final String videoId;

  @override
  State<WebviewtubePlayerView> createState() => _WebviewtubePlayerViewState();
}

class _WebviewtubePlayerViewState extends State<WebviewtubePlayerView> {
  final Completer<WebViewController> _webviewController =
      Completer<WebViewController>();

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
                  log('onReady', name: 'Player');
                  break;
                }
              case 'StateChange':
                {
                  final data = json['args']['state'] as int;
                  context
                      .read<WebviewtubeController>()
                      .onPlayerStateChange(data);
                  log('onPlayerStateChange', name: 'Player');
                  break;
                }
              case 'PlaybackQualityChange':
                {
                  final data = json['args']['playbackQuality'] as String;
                  context
                      .read<WebviewtubeController>()
                      .onPlayerQualityChange(data);
                  log('onPlayerQualityChange', name: 'Player');
                  break;
                }
              case 'Errors':
                {
                  final data = json['args']['errorCode'] as int;
                  context.read<WebviewtubeController>().onError(data);
                  log('onError', name: 'Player');
                  break;
                }
              case 'VideoData':
                {
                  final data = json['args'] as Map<String, dynamic>;
                  context.read<WebviewtubeController>().onVideoDataChange(data);
                  log('onVideoDataChange', name: 'Player');
                  break;
                }
              case 'CurrentTime':
                {
                  final data = json['args'] as Map<String, dynamic>;
                  context
                      .read<WebviewtubeController>()
                      .onCurrentTimeChange(data);
                  log('onCurrentTimeChange', name: 'Player');
                  break;
                }
            }
          }),
    };
  }

  @override
  Widget build(BuildContext context) {
    // TODO: fix the position
    return Stack(
      fit: StackFit.expand,
      children: [
        WebView(
          onWebViewCreated: _onWebViewCreated,
          onPageFinished: (_) =>
              context.read<WebviewtubeController>().onLoaded(),
          javascriptMode: JavascriptMode.unrestricted,
          initialMediaPlaybackPolicy: AutoMediaPlaybackPolicy.always_allow,
          javascriptChannels: _buildJavascriptChannel(),
        ),
        Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ActionButton(),
            ProgressBar(),
            VolumeButton(),
          ],
        )),
      ],
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
}

String _generateIframePage(String videoId) {
  return '''
<!DOCTYPE html>
<html>

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
                height: '390',
                width: '640',
                videoId: '$videoId',
                playerVars: {
                    'controls': 1,
                    'playsinline': 1,
                    'enablejsapi': 1,
                    'fs': 0,
                    'rel': 0,
                    'showinfo': 0,
                    'iv_load_policy': 3,
                    'modestbranding': 1
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
            }, 100);
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
            player.loadPlaylist(playlist, 'playlist', index, startAt);
        }

        function cuePlaylist(playlist, index, startAt) {
            player.cuePlaylist(playlist, 'playlist', index, startAt);
        }

        function mute() {
            player.mute();
        }

        function unMute() {
            player.unMute();
        }

        function setVolume(volume) {
            player.setVolume(volume);
        }

        function seekTo(position, seekAhead) {
            player.seekTo(position, seekAhead);
        }

        function setSize(width, height) {
            player.setSize(width, height);
        }

        function setPlaybackRate(rate) {
            player.setPlaybackRate(rate);
        }

        function setTopMargin(margin) {
            document.getElementById("player").style.marginTop = margin;
        }
    </script>
</body>

</html>
''';
}
