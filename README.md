# Webviewtube

Play YouTube videos on mobile devices with [webview_flutter](https://pub.dev/packages/webview_flutter) and [IFrame Player API](https://developers.google.com/youtube/iframe_api_reference). 

This package is largely inspired by the popular [youtube_player_flutter](https://pub.dev/packages/youtube_player_flutter), but with the official Flutter support of WebView and simpler state management via [provider](https://pub.dev/packages/provider).

## Why another package?

`youtube_player_flutter` and its dependency `flutter_inappwebview` have been in hiatus for a while. It's more reassuring to use the official [webview_flutter](https://pub.dev/packages/webview_flutter). Also, the performance issues of `youtube_player_flutter` are not resolved and make it problematic to use in some situations.

This package aims to solve the problems by:
- Depends on the official [webview_flutter](https://pub.dev/packages/webview_flutter) to provide a default IFrame player.
  - `WebviewtubePlayer` is a pure IFrame player and does not require any Flutter widgets. It's just a WebView, (mostly) free from the janks.
- Proper state management with [provider](https://pub.dev/packages/provider).
  - `WebviewtubeVideoPlayer` combines the default player with customized widgets. The state management is carefully handled, which makes the player more maintainable, testable, and easily customizable.

## Supported Platforms

The same as [webview_flutter](https://pub.dev/packages/webview_flutter). On Android, hybrid composition mode is used.

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

Check out `example/lib/` for more details.

### Default IFrame player

```dart
WebviewtubePlayer('4AoFA19gbLo')
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

## Customize the player

Using a proper state management is highly recommended. This package uses [provider](https://pub.dev/packages/provider), but you can fork and use your choice of tools.
Check out the source code of `WebviewtubeVideoPlayer` and make your own player!

### With StatefulWidget and setState

Refers to `example/lib/customized_player.dart` for a use case with stateful widgets.

## Acknowledgments

This package is built upon/inspired by the following packages, for which credit goes out to the respective authors.

- [youtube_player_flutter](https://pub.dev/packages/youtube_player_flutter) by [Sarbagya Dhaubanjar](https://github.com/sarbagyastha/youtube_player_flutter)
- [youtube_player_webview](https://pub.dev/packages/youtube_player_webview) by [Ravindra barthwal](https://github.com/ravindrabarthwal/youtube_player_webview)
