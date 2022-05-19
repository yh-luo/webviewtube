import 'package:flutter/foundation.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'models/models.dart';

class WebviewtubeController extends ValueNotifier<WebviewTubeValue> {
  WebviewtubeController({WebviewtubeOptions? options})
      : options = options ?? WebviewtubeOptions(),
        super(const WebviewTubeValue());

  WebViewController? _webViewController;
  WebviewtubeOptions options;
  bool _isLoaded = false;

  bool get isLoaded => _isLoaded;

  void onWebviewCreated(WebViewController webViewController) {
    _webViewController = webViewController;
  }

  void onLoaded() => _isLoaded = true;

  void onReady() => value = value.copyWith(isReady: true);

  void onError(int data) =>
      value = value.copyWith(playerError: PlayerError.fromData(data));

  void onPlayerStateChange(int data) =>
      value = value.copyWith(playerState: PlayerState.fromData(data));

  void onPlayerQualityChange(String data) =>
      value = value.copyWith(playbackQuality: PlaybackQuality.fromData(data));

  void onVideoDataChange(Map<String, dynamic> data) =>
      value = value.copyWith(videoMetadata: VideoMetadata.fromData(data));

  void onCurrentTimeChange(Map<String, dynamic> data) {
    final position = data['position'] as num;
    final buffered = data['buffered'] as num;
    value = value.copyWith(
        position: Duration(milliseconds: (position * 1000).floor()),
        buffered: buffered.toDouble());
  }

  void _callMethod(String method) {
    if (_isLoaded && value.isReady) {
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

  /// Set playback rate
  void setPlaybackRate(PlaybackRate playbackRate) {
    _callMethod('setPlaybackRate(${playbackRate.rate})');
    value = value.copyWith(playbackRate: playbackRate);
  }

  /// Sets the volume of player.
  ///
  /// This won't work for mobile devices. For mobile devices, the volume depends
  /// on the device's own setting and not the player.
  /// Max = 100 , Min = 0
  void setVolume(int volume) => volume >= 0 && volume <= 100
      ? _callMethod('setVolume($volume)')
      : throw Exception("Volume should be between 0 and 100");

  /// Reloads the player.
  ///
  /// The video id will reset to [initialVideoId] after reload.
  void reload() => _webViewController?.reload();
}
