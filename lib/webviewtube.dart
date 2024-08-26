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
/// To interact with the player (e.g., retrieve video metadata, control
/// playback) and manage its state (e.g., pause, load new videos), use a
/// [WebviewtubeController]. Make sure to pass this controller to the player
/// instance and remember to dispose of it when it's no longer needed to free
/// up resources.
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
///     );
/// }
/// ```
///
/// See also:
///   - [WebviewtubeController]
///   - [WebviewtubeOptions]
library webviewtube;

export 'src/webviewtube.dart';
