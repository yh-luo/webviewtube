# Webviewtube

Use the official [webview_flutter](https://pub.dev/packages/webview_flutter) to play YouTube videos using the [IFrame Player API](https://developers.google.com/youtube/iframe_api_reference) on mobile devices.

This package can be considered a rewrite of the popular [youtube_player_flutter](https://pub.dev/packages/youtube_player_flutter), with the official WebView support and state management using [provider](https://pub.dev/packages/provider).

## Why another package?

`youtube_player_flutter` and its dependency `flutter_inappwebview` have been in hiatus for a while. It's more reassuring to use the official support for WebView. Also, the performance issues of `youtube_player_flutter` are not resolved and make it problematic to use.

This package aims to solve the problems by:
- Depends on the official [webview_flutter](https://pub.dev/packages/webview_flutter) to provides a default IFrame player.
  - `WebviewtubePlayer` is a pure IFrame player and does not require any Flutter widgets. It's just a WebView, (mostly) free from the janks.
- Proper state management with [provider](https://pub.dev/packages/provider).
  - `WebviewtubeVideoPlayer` combines the default player with customized widgets. The state management is carefully handled, which makes the player more maintainable, testable, and easily customizable.

## Supported Platforms

The same as `webview_flutter`. On Android, hybrid composition  mode is used.

- Android: SDK 19+
- iOS: 9.0+

## Setup

### Android

Set the correct `minSdkVersion` in `android/app/build.gradle`

```
android {
    defaultConfig {
        minSdkVersion 19
    }
}
```

### iOS

No configuration needed.

## Usage

Check out `example` for more details.

### Default IFrame player

```dart
WebviewtubePlayer(videoId: '4AoFA19gbLo')
```

With configuration:

```dart
final webviewtubeController = WebviewtubeController(
  options: const WebviewtubeOptions(
    forceHd: true,
    enableCaption: false,
  ),
);

WebviewtubePlayer('4AoFA19gbLo', controller: webviewtubeController);
```

### With material widgets

```dart
WebviewtubeVideoPlayer('4AoFA19gbLo')
```

With configuration:

```dart
final webviewtubeController = WebviewtubeController(
  options: const WebviewtubeOptions(
      // remember to set `showControls` to false to hide the
      // iframe player controls
      showControls: false,
      forceHd: true,
      enableCaption: false),
);

WebviewtubeVideoPlayer('4AoFA19gbLo', controller: webviewtubeController)
```

### Customize the player

Using a proper state management is highly recommended. Check out the source code of `WebviewtubeVideoPlayer` and make your own player!

Refers to `example/lib/customized_player.dart` for a stateful widget use case.
