/// Play YouTube videos using WebView and the IFrame Player API.
///
/// Use [WebviewtubeVideoPlayer] for the IFrame player.
/// ```dart
/// WebviewtubePlayer(videoId: '4AoFA19gbLo')
/// ```
///
/// Use [WebviewtubeVideoPlayer] for a more decorated player.
/// ```dart
/// WebviewtubeVideoPlayer('4AoFA19gbLo')
/// ```
///
/// To configure the player, use [WebviewtubeController] with
/// [WebviewtubeOptions].
/// ```dart
/// final webviewtubeController = WebviewtubeController(
///   options: const WebviewtubeOptions(
///       // remember to set `showControls` to false to hide the
///       // iframe player controls
///       showControls: false,
///       forceHd: true,
///       enableCaption: false),
/// );
///
/// WebviewtubeVideoPlayer('4AoFA19gbLo', controller: webviewtubeController)
/// ```
///
/// See also:
///   - [WebviewtubeController]
///   - [WebviewtubeOptions]
library webviewtube;

export 'src/webviewtube.dart';
