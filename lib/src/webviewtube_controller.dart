import 'package:flutter/foundation.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'models/models.dart';

/// Optional callback invoked when the player is ready.
typedef PlayerReadyCallback = void Function();

/// Optional callback invoked when the player returns an error.
typedef PlayerErrorCallback = void Function(PlayerError error);

/// {@template webviewtube_controller}
/// Controls the player and provides information about the player state.
///
/// To fully customize a new player widget, it's easier to make a new one based
/// on [WebviewtubePlayer], which handles the webview controller under the hood. If
/// that's not enough and you plan to make a new player with
/// [WebviewtubeController], make sure to provide a [WebViewController] using
/// [onWebviewCreated] before any method call, e.g., play, load, etc, or an
/// error will be thrown.
/// {@endtemplate}
class WebviewtubeController extends ValueNotifier<WebviewTubeValue> {
  /// {@macro webviewtube_controller}
  WebviewtubeController({
    this.onPlayerReady,
    this.onPlayerError,
    this.onPlayerWebResourceError,
  }) : super(const WebviewTubeValue());

  late final WebViewController _webViewController;

  bool _isPlaylist = false;

  /// Invoked when the player is ready.
  final PlayerReadyCallback? onPlayerReady;

  /// Invoked when the player returns an error.
  final PlayerErrorCallback? onPlayerError;

  /// Invoked when a web resource has failed to load.
  final WebResourceErrorCallback? onPlayerWebResourceError;

  /// Current loaded [WebViewController].
  WebViewController get webViewController => _webViewController;

  /// Whether the controller is playing a playlist.
  bool get isPlaylist => _isPlaylist;

  /// Provides `WebViewController` to the controller.
  void onWebviewCreated(WebViewController webViewController) {
    _webViewController = webViewController;
  }

  /// Invoked handler when the player is ready.
  void onReady() {
    value = value.copyWith(isReady: true);
    if (onPlayerReady != null) {
      onPlayerReady!();
    }
  }

  /// Invoked handler when the player returns an error.
  void onError(int data) {
    final playerError = PlayerError.fromData(data);
    value = value.copyWith(playerError: playerError);
    if (onPlayerError != null) {
      onPlayerError!(playerError);
    }
  }

  /// Invoked handler when WebView returns an error.
  void onWebResourceError(WebResourceError error) {
    value = value.copyWith(playerError: PlayerError.unknown);
    if (onPlayerWebResourceError != null) {
      onPlayerWebResourceError!(error);
    }
  }

  /// Invoked handler when the player state changes.
  void onPlayerStateChange(int data) {
    final playerState = PlayerState.fromData(data);
    value = value.copyWith(playerState: playerState);
  }

  /// Invoked handler when the playback quality changes.
  void onPlaybackQualityChange(String data) =>
      value = value.copyWith(playbackQuality: PlaybackQuality.fromData(data));

  /// Invoked handler when the playback rate changes.
  void onPlaybackRateChange(num data) =>
      value = value.copyWith(playbackRate: PlaybackRate.fromData(data));

  /// Invoked handler when the video data changes.
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

  /// Interacts with IFrame API via javascript channels.
  void _callMethod(String method) {
    if (value.isReady) {
      _webViewController.runJavascript(method);
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

  /// Sets the playback rate.
  void setPlaybackRate(PlaybackRate playbackRate) =>
      _callMethod('setPlaybackRate(${playbackRate.rate})');

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
  void reload() => _webViewController.reload();

  /// Loads and plays the specified video.
  void load(String videoId, {int startAt = 0, int? endAt}) {
    if (endAt != null) {
      assert(startAt < endAt);
    }

    var params = 'videoId: "$videoId"';
    if (startAt > 0) {
      params += ', startSeconds: $startAt';
    }
    if (endAt != null) {
      params += ', endSeconds: $endAt';
    }

    _callMethod('loadById({$params})');
    _isPlaylist = false;
  }

  /// Loads the specified video's thumbnail and prepares the player.
  void cue(String videoId, {int startAt = 0, int? endAt}) {
    if (endAt != null) {
      assert(startAt < endAt);
    }

    var params = 'videoId: "$videoId"';
    if (startAt > 0) {
      params += ', startSeconds: $startAt';
    }
    if (endAt != null) {
      params += ', endSeconds: $endAt';
    }

    _callMethod('cueById({$params})');
    _isPlaylist = false;
  }

  /// Loads the specified playlist and plays it.
  void loadPlaylist({
    String? playlistId,
    List<String>? videoIds,
    int index = 0,
    int startAt = 0,
  }) {
    assert(playlistId != null || (videoIds != null && videoIds.isNotEmpty));
    var playlist = playlistId ?? '[${videoIds!.map((e) => '"$e"').join(', ')}]';

    _callMethod('loadPlaylist($playlist, $index, $startAt)');
    _isPlaylist = true;
  }

  /// Queues the specified playlist.
  /// When the playlist is cued and ready to play, `playerState` will be
  /// [PlayerState.cued].
  void cuePlaylist({
    String? playlistId,
    List<String>? videoIds,
    int index = 0,
    int startAt = 0,
  }) {
    assert(playlistId != null || (videoIds != null && videoIds.isNotEmpty));
    var playlist = playlistId ?? '[${videoIds!.map((e) => '"$e"').join(', ')}]';

    _callMethod('cuePlaylist($playlist, $index, $startAt)');
    _isPlaylist = true;
  }

  /// Loads and plays the next video in the playlist.
  /// Does nothing when the controller is not playing a playlist.
  void nextVideo() {
    if (!_isPlaylist) return;

    _callMethod('nextVideo()');
  }

  /// Loads and plays the previous video in the playlist.
  /// Does nothing when the controller is not playing a playlist.
  void previousVideo() {
    if (!_isPlaylist) return;

    _callMethod('previousVideo()');
  }

  /// Loads and plays the specified video in the playlist.
  /// Does nothing when the controller is not playing a playlist.
  void playVideoAt(int index) {
    if (!_isPlaylist) return;

    _callMethod('playVideoAt($index)');
  }
}
