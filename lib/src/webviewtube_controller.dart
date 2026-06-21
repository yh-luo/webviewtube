import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import 'models/models.dart';

/// Optional callback invoked when the player is ready.
typedef PlayerReadyCallback = void Function();

/// Optional callback invoked when the player wants to navigate to a new page.
typedef PlayerNavigationRequestCallback = FutureOr<bool> Function(Uri uri);

/// Optional callback invoked when the player returns an error.
typedef PlayerErrorCallback = void Function(PlayerError error);

/// {@template webviewtube_controller}
/// A controller for managing and interacting with a YouTube player embedded in a WebView.
///
/// For a simpler integration, consider using [WebviewtubePlayer], which wraps the
/// controller and handles the WebView setup.
///
/// For more control over the player, create an instance of [WebviewtubeController]
/// and use the provided methods to interact with the player:
/// 1. Create an instance of [WebviewtubeController].
/// 2. Call [init] with the video ID to initialize the controller.
/// 3. Use the provided methods to interact with your player widget.
/// 4. Call [dispose] when it is no longer needed.
///
/// To fully customize a new player widget, it's easier to build a new widget
/// on top of [WebviewtubePlayer], which handles the webview controller under
/// the hood. If that's not enough and you plan to build a fully customized
/// player with [WebviewtubeController], remember to call [init] method to
/// initialize the controller before any method call (e.g., play, load, etc) and
/// dispose the controller when it's not in need.
/// {@endtemplate}
class WebviewtubeController extends ValueNotifier<WebviewTubeValue> {
  /// {@macro webviewtube_controller}
  WebviewtubeController({
    this.options = const WebviewtubeOptions(),
    this.onPlayerReady,
    this.onPlayerError,
    this.onPlayerWebResourceError,
    this.onPlayerNavigationRequest,
  }) : super(const WebviewTubeValue());

  WebViewController? _webViewController;

  Completer<void> _initCompleter = Completer<void>();

  bool _isPlaylist = false;

  bool _disposed = false;

  /// Additional options to control the player.
  final WebviewtubeOptions options;

  /// Invoked when the player is ready.
  final PlayerReadyCallback? onPlayerReady;

  /// Invoked when the player returns an error.
  final PlayerErrorCallback? onPlayerError;

  /// Invoked when a web resource has failed to load.
  final WebResourceErrorCallback? onPlayerWebResourceError;

  /// Invoked when the player wants to navigate to a new page.
  /// Return true to allow the navigation, false to prevent navigation.
  ///
  /// Defaults to null, which prevents any navigation.
  ///
  /// For example, to allow the user to watch the video in the YouTube app or
  /// website when tapping on the YouTube logo, define the callback as follows
  /// and pass the controller to the player widget:
  /// ```dart
  /// import 'package:url_launcher/url_launcher.dart';
  ///
  /// ...
  ///
  /// final controller = WebviewtubeController(
  ///   onPlayerNavigationRequest: (uri) async {
  ///     if (uri.host == 'www.youtube.com') {
  ///       await launchUrl(uri, mode: LaunchMode.externalApplication);
  ///       return false;
  ///     }
  ///     return false;
  ///   },
  /// );
  /// ```
  final PlayerNavigationRequestCallback? onPlayerNavigationRequest;

  /// Current loaded [WebViewController].
  ///
  /// Throws [StateError] if accessed before [init] (or
  /// [setMockWebViewController]) has set it.
  WebViewController get webViewController {
    final controller = _webViewController;
    if (controller == null) {
      throw StateError(
        'WebViewController has not been initialized. Call init() first.',
      );
    }
    return controller;
  }

  /// Whether the controller is playing a playlist.
  bool get isPlaylist => _isPlaylist;

  /// This method is used for testing purposes only.
  @visibleForTesting
  void setMockWebViewController(WebViewController webViewController) {
    _webViewController = webViewController;
    if (!_initCompleter.isCompleted) {
      _initCompleter.complete();
    }
  }

  /// Initializes the controller with the specified video id.
  ///
  /// If a previous [init] call failed, calling [init] again resets the
  /// underlying completer so a retry can succeed. If a previous [init]
  /// succeeded, the existing WebView is torn down before a new one is wired
  /// up so the native resources aren't leaked.
  ///
  /// Throws [StateError] if called after [dispose].
  Future<void> init(String videoId) async {
    if (_disposed) {
      throw StateError('Cannot init a disposed WebviewtubeController.');
    }
    if (_webViewController != null) {
      _teardownWebView();
      _webViewController = null;
    }
    if (_initCompleter.isCompleted) {
      _initCompleter = Completer<void>();
    }
    try {
      late final PlatformWebViewControllerCreationParams params;

      if (WebViewPlatform.instance is WebKitWebViewPlatform) {
        params = WebKitWebViewControllerCreationParams(
          allowsInlineMediaPlayback: true,
          mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
        );
      } else {
        params = const PlatformWebViewControllerCreationParams();
      }
      final controller = WebViewController.fromPlatformCreationParams(params)
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..addJavaScriptChannel(
          'Webviewtube',
          onMessageReceived: _onMessageReceived,
        )
        ..setNavigationDelegate(
          NavigationDelegate(
            onNavigationRequest: (request) async {
              // first navigation is allowed on iOS to load the video correctly
              if (defaultTargetPlatform == TargetPlatform.iOS &&
                  !value.isReady) {
                return NavigationDecision.navigate;
              }

              final url = Uri.tryParse(request.url);
              if (url == null) return NavigationDecision.prevent;
              final verdict =
                  await onPlayerNavigationRequest?.call(url) ?? false;

              return verdict
                  ? NavigationDecision.navigate
                  : NavigationDecision.prevent;
            },
            onWebResourceError: onWebResourceError,
          ),
        );
      _webViewController = controller;

      if (controller.platform is AndroidWebViewController) {
        (controller.platform as AndroidWebViewController)
            .setMediaPlaybackRequiresUserGesture(false);
      } else if (controller.platform is WebKitWebViewController) {
        (controller.platform as WebKitWebViewController)
            .setAllowsBackForwardNavigationGestures(false);
      }

      if (options.forceHd) {
        controller.setUserAgent(hdUserAgent);
      }

      final htmlContent = await _loadHtmlTemplate(videoId, options);
      if (_disposed) return;
      await controller.loadHtmlString(htmlContent, baseUrl: options.origin);
    } catch (_) {
      // If dispose() already ran, it has owned the teardown and completer;
      // re-doing either would log spurious errors against the stripped
      // controller. The init() caller still gets the original error via
      // the rethrow.
      if (_disposed) rethrow;
      // Run the same platform-side teardown dispose() uses, so the
      // half-configured controller's JS channel + navigation delegate
      // don't keep the native WebView (and `this`, via the channel
      // closure) alive after the rethrow.
      _teardownWebView();
      _webViewController = null;
      // Unblock pending `_callMethod` awaits so they observe the still-null
      // `_webViewController` and short-circuit instead of hanging. The
      // original error is propagated to the `init()` caller via the rethrow
      // below; we deliberately don't store it on the completer to avoid
      // poisoning every later playback call with a stale init error.
      if (!_initCompleter.isCompleted) {
        _initCompleter.complete();
      }
      rethrow;
    }

    if (!_initCompleter.isCompleted) {
      _initCompleter.complete();
    }
  }

  Future<String> _loadHtmlTemplate(
    String videoId,
    WebviewtubeOptions options,
  ) async {
    try {
      // Load from package assets
      String htmlTemplate = await rootBundle.loadString(
        'packages/webviewtube/assets/player.html',
      );

      // Replace placeholders with actual values
      return htmlTemplate
          .replaceAll('{{VIDEO_ID}}', videoId)
          .replaceAll(
            '{{ENABLE_CAPTION}}',
            _boolean(options.enableCaption).toString(),
          )
          .replaceAll('{{CAPTION_LANGUAGE}}', options.captionLanguage)
          .replaceAll(
            '{{SHOW_CONTROLS}}',
            _boolean(options.showControls).toString(),
          )
          .replaceAll(
            '{{ENABLE_FULLSCREEN}}',
            _boolean(options.enableFullscreen).toString(),
          )
          .replaceAll('{{INTERFACE_LANGUAGE}}', options.interfaceLanguage)
          .replaceAll('{{LOOP}}', _boolean(options.loop).toString())
          .replaceAll(
            '{{PLAYLIST_PARAM}}',
            options.loop ? "'playlist': '$videoId'," : '',
          )
          .replaceAll(
            '{{ORIGIN_PARAM}}',
            options.origin != null ? "'origin': '${options.origin}'," : '',
          )
          .replaceAll('{{START_AT}}', options.startAt.toString())
          .replaceAll('{{END_AT}}', options.endAt.toString())
          .replaceAll(
            '{{UPDATE_INTERVAL}}',
            options.currentTimeUpdateInterval.toString(),
          );
    } catch (e) {
      debugPrint('Error loading HTML template: $e');
      rethrow;
    }
  }

  void _onMessageReceived(JavaScriptMessage message) {
    if (_disposed) return;

    Map<String, dynamic> json = jsonDecode(message.message);
    switch (json['method']) {
      case 'Ready':
        {
          onReady();
          if (options.mute) {
            mute();
          }
          break;
        }
      case 'StateChange':
        {
          final data = int.tryParse(json['args']['state'].toString());
          if (data != null) {
            onPlayerStateChange(data);
          }
          break;
        }
      case 'PlaybackQualityChange':
        {
          final data = json['args']['playbackQuality'].toString();
          onPlaybackQualityChange(data);
          break;
        }
      case 'PlaybackRateChange':
        {
          final data = num.tryParse(json['args']['playbackRate'].toString());
          if (data != null) {
            onPlaybackRateChange(data);
          }
          break;
        }
      case 'Errors':
        {
          final data = int.tryParse(json['args']['errorCode'].toString());
          // unknown error
          onError(data ?? 999);
          break;
        }
      case 'VideoData':
        {
          final data = json['args'] as Map<String, dynamic>;
          onVideoDataChange(data);
          break;
        }
      case 'CurrentTime':
        {
          final data = json['args'] as Map<String, dynamic>;
          onCurrentTimeChange(data);
          break;
        }
    }
  }

  /// Disposes of the controller and cleans up resources.
  ///
  /// This method should be called when the controller is no longer needed.
  @override
  void dispose() {
    if (_disposed) return;
    _disposed = true;
    // Resolve pending `_callMethod` awaits so they observe `_disposed` and
    // return early instead of hanging forever.
    if (!_initCompleter.isCompleted) {
      _initCompleter.complete();
    }
    _teardownWebView();
    super.dispose();
  }

  /// Platform-side WebView cleanup recommended in
  /// https://github.com/flutter/flutter/issues/119616#issuecomment-1419991144.
  /// No-ops when [_webViewController] is null; swallows (and logs) errors so
  /// the surrounding caller — `dispose()` or `init()`'s catch — can still
  /// finish its own work.
  void _teardownWebView() {
    final controller = _webViewController;
    if (controller == null) return;
    try {
      controller
        ..removeJavaScriptChannel('Webviewtube')
        ..setNavigationDelegate(NavigationDelegate())
        ..loadRequest(Uri.parse('about:blank'));
    } catch (error) {
      debugPrint('WebviewtubeController WebView teardown failed: $error');
    }
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
    if (_disposed) return;

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
    if (data['position'] == null || data['buffered'] == null) return;
    final position = data['position'] as num;
    final buffered = data['buffered'] as num;
    value = value.copyWith(
      position: Duration(milliseconds: (position * 1000).floor()),
      buffered: buffered.toDouble(),
    );
  }

  /// Interacts with IFrame API via javascript channels.
  Future<void> _callMethod(String method) async {
    await _initCompleter.future;
    if (_disposed) return;
    final controller = _webViewController;
    if (controller == null) return;
    if (value.isReady) {
      controller.runJavaScript(method);
    } else {
      debugPrint('The controller is not ready for method calls.');
    }
  }

  /// Assigns to [value] only when the controller is alive and the player
  /// reported ready. Skipping when not-ready keeps local state from drifting
  /// after a failed [init] (where `_callMethod` silently short-circuits) or
  /// when a caller invokes a mutating method before the player handshake.
  void _safeSetValue(
    WebviewTubeValue Function(WebviewTubeValue current) update,
  ) {
    if (_disposed || !value.isReady) return;
    value = update(value);
  }

  /// Mirrors [_safeSetValue]'s gate for [_isPlaylist]. The flag must not drift
  /// when [_callMethod] silently dropped the JS call (disposed or not-ready),
  /// otherwise `nextVideo`/`previousVideo`/`playVideoAt` will issue JS against
  /// a player that has no matching playlist (or video) loaded.
  void _safeSetIsPlaylist(bool isPlaylist) {
    if (_disposed || !value.isReady) return;
    _isPlaylist = isPlaylist;
  }

  /// Plays the video.
  Future<void> play() => _callMethod('play()');

  /// Pauses the video.
  Future<void> pause() => _callMethod('pause()');

  /// Mutes the player.
  Future<void> mute() async {
    await _callMethod('mute()');
    _safeSetValue((v) => v.copyWith(isMuted: true));
  }

  /// Unmutes the player.
  Future<void> unMute() async {
    await _callMethod('unMute()');
    _safeSetValue((v) => v.copyWith(isMuted: false));
  }

  /// Sets the playback rate.
  Future<void> setPlaybackRate(PlaybackRate playbackRate) =>
      _callMethod('setPlaybackRate(${playbackRate.rate})');

  /// Seeks to a specified time in the video.
  ///
  /// Video will play after seeking. The optional [allowSeekAhead] parameter
  /// determines whether the player will make a new request to the server if the
  /// position is outside of the currently buffered video data.
  /// [allowSeekAhead] defaults to false.
  Future<void> seekTo(Duration position, {bool allowSeekAhead = false}) async {
    await _callMethod('seekTo(${position.inSeconds}, $allowSeekAhead)');
    _safeSetValue((v) => v.copyWith(position: position));

    await play();
  }

  /// Replays the video.
  Future<void> replay() => seekTo(Duration.zero);

  /// Reloads the player.
  Future<void> reload() async {
    await _initCompleter.future;
    if (_disposed) return;
    final controller = _webViewController;
    if (controller == null) return;
    await controller.reload();
  }

  /// Loads and plays the specified video.
  Future<void> load(String videoId, {int startAt = 0, int? endAt}) async {
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

    await _callMethod('loadById({$params})');
    _safeSetIsPlaylist(false);
  }

  /// Loads the specified video's thumbnail and prepares the player.
  Future<void> cue(String videoId, {int startAt = 0, int? endAt}) async {
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

    await _callMethod('cueById({$params})');
    _safeSetIsPlaylist(false);
  }

  /// Loads the specified playlist and plays it.
  Future<void> loadPlaylist({
    String? playlistId,
    List<String>? videoIds,
    int index = 0,
    int startAt = 0,
  }) async {
    assert(playlistId != null || (videoIds != null && videoIds.isNotEmpty));
    var playlist = playlistId ?? '[${videoIds!.map((e) => '"$e"').join(', ')}]';

    await _callMethod('loadPlaylist($playlist, $index, $startAt)');
    _safeSetIsPlaylist(true);
  }

  /// Queues the specified playlist.
  /// When the playlist is cued and ready to play, `playerState` will be
  /// [PlayerState.cued].
  Future<void> cuePlaylist({
    String? playlistId,
    List<String>? videoIds,
    int index = 0,
    int startAt = 0,
  }) async {
    assert(playlistId != null || (videoIds != null && videoIds.isNotEmpty));
    var playlist = playlistId ?? '[${videoIds!.map((e) => '"$e"').join(', ')}]';

    await _callMethod('cuePlaylist($playlist, $index, $startAt)');
    _safeSetIsPlaylist(true);
  }

  /// Loads and plays the next video in the playlist.
  /// Does nothing when the controller is not playing a playlist.
  Future<void> nextVideo() async {
    if (!_isPlaylist) return;

    await _callMethod('nextVideo()');
  }

  /// Loads and plays the previous video in the playlist.
  /// Does nothing when the controller is not playing a playlist.
  Future<void> previousVideo() async {
    if (!_isPlaylist) return;

    await _callMethod('previousVideo()');
  }

  /// Loads and plays the specified video in the playlist.
  /// Does nothing when the controller is not playing a playlist.
  Future<void> playVideoAt(int index) async {
    if (!_isPlaylist) return;

    await _callMethod('playVideoAt($index)');
  }
}

int _boolean(bool value) => value ? 1 : 0;

/// The user agent to force the video plays in HD.
String hdUserAgent =
    'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/101.0.4951.64 Safari/537.36';
