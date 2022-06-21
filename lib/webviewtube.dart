/// Play YouTube videos using WebView and the IFrame Player API.
///
/// Use [WebviewtubeVideoPlayer] for the IFrame player.
/// ```dart
/// WebviewtubePlayer(videoId: '4AoFA19gbLo')
/// ```
///
/// Use [WebviewtubeVideoPlayer] for a more decorated player.
/// ```dart
/// WebviewtubeVideoPlayer(videoId: '4AoFA19gbLo')
/// ```
///
/// To configure the player, use [WebviewtubeOptions]
/// ```dart
/// final options = const WebviewtubeOptions(
///     forceHd: true,
///     enableCaption: false,
/// );
///
/// WebviewtubeVideoPlayer('4AoFA19gbLo', options: options)
/// ```
///
/// To listen to the player value (e.g., video metadata) or control the player
/// (e.g., pause or load other videos), pass a [WebviewtubeController] and
/// remember to dispose the controller when it's not in need.
/// ```dart
/// // ...
/// // inside a state of a stateful widget
/// final controller = WebviewtubeController();
///
/// @override
/// void dispose() {
///   controller.dispose();
///   super.dispose();
/// }
///
/// @override
/// Widget build(BuildContext context) {
///     return WebviewtubeVideoPlayer(
///       videoId: '4AoFA19gbLo',
///       controller: controller,
///       );
/// }
/// ```
///
/// See also:
///   - [WebviewtubeController]
///   - [WebviewtubeOptions]
library webviewtube;

export 'src/webviewtube.dart';
