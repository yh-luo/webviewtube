import 'package:flutter/foundation.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'models/models.dart';

class WebviewtubeController extends ValueNotifier<WebviewTubeValue> {
  WebviewtubeController({WebviewtubeOptions? options})
      : options = options ?? const WebviewtubeOptions(),
        super(const WebviewTubeValue());

  WebViewController? _webViewController;

  /// Additional options to control the player
  WebviewtubeOptions options;

  /// Provides `WebViewController` to the controller.
  void onWebviewCreated(WebViewController webViewController) {
    _webViewController = webViewController;
  }

  /// Invoked handler when the player is ready.
  void onReady() {
    value = value.copyWith(isReady: true);
    if (options.mute) {
      mute();
    }
  }

  /// Invoked handler when the player returns an error.
  void onError(int data) =>
      value = value.copyWith(playerError: PlayerError.fromData(data));

  /// Invoked handler when WebView returns an error.
  void onWebResourceError(WebResourceError error) {
    value = value.copyWith(playerError: PlayerError.unknown);
    debugPrint('WebResourceError(errorCode: ${error.errorCode}, '
        'description: ${error.description}, '
        'domain: ${error.domain}, '
        'errorType: ${error.errorType},'
        'failingUrl: ${error.failingUrl})');
  }

  /// Invoked handler when the player state changes.
  void onPlayerStateChange(int data) {
    final playerState = PlayerState.fromData(data);
    value = value.copyWith(
      playerState: playerState,
      isReady: !(playerState == PlayerState.buffering),
    );
  }

  /// Invoked handler when the playback quality changes
  void onPlaybackQualityChange(String data) =>
      value = value.copyWith(playbackQuality: PlaybackQuality.fromData(data));

  /// Invoked handler when the video data changes
  void onVideoDataChange(Map<String, dynamic> data) =>
      value = value.copyWith(videoMetadata: VideoMetadata.fromData(data));

  /// Invoked handler for updates on buffered ratio and elapsed time.
  void onCurrentTimeChange(Map<String, dynamic> data) {
    final position = data['position'] as num;
    final buffered = data['buffered'] as num;
    value = value.copyWith(
        position: Duration(milliseconds: (position * 1000).floor()),
        buffered: buffered.toDouble());
  }

  /// Interacts with IFrame API via javascript channels
  void _callMethod(String method) {
    if (value.isReady) {
      _webViewController?.runJavascript(method);
    } else {
      debugPrint('The controller is not ready for method calls.');
    }
  }

  /// Plays the video.
  void play() => _callMethod('play()');

  /// Pauses the video.
  void pause() => _callMethod('pause()');

  /// Mutes the player.
  void mute() {
    _callMethod('mute()');
    value = value.copyWith(isMuted: true);
  }

  /// Unmutes the player.
  void unMute() {
    _callMethod('unMute()');
    value = value.copyWith(isMuted: false);
  }

  /// Sets the playback rate
  void setPlaybackRate(PlaybackRate playbackRate) {
    _callMethod('setPlaybackRate(${playbackRate.rate})');
    value = value.copyWith(playbackRate: playbackRate);
  }

  /// Sets the volume of player.
  ///
  /// This won't work for mobile devices. For mobile devices, the volume depends
  /// on the device's own setting and not the player.
  /// Max = 100 , Min = 0
  void setVolume(int volume) {
    if (volume < 0 || volume > 100) {
      throw Exception('Volume should be between 0 and 100');
    }

    _callMethod('setVolume($volume)');
  }

  /// Seeks to a specified time in the video.
  ///
  /// Video will play after seeking. The optional [allowSeekAhead] parameter
  /// determines whether the player will make a new request to the server if the
  /// position is outside of the currently buffered video data.
  /// [allowSeekAhead] defaults to false.
  void seekTo(Duration position, {bool allowSeekAhead = false}) {
    _callMethod('seekTo(${position.inSeconds}, $allowSeekAhead)');
    value = value.copyWith(position: position);
    play();
  }

  /// Replays the video.
  void replay() => seekTo(Duration.zero);

  /// Reloads the player.
  void reload() => _webViewController?.reload();
}
