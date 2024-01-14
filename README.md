# Webviewtube

Play YouTube videos on mobile devices with [webview_flutter](https://pub.dev/packages/webview_flutter) and [IFrame Player API](https://developers.google.com/youtube/iframe_api_reference). 

This package is largely inspired by the popular [youtube_player_flutter](https://pub.dev/packages/youtube_player_flutter), but with the official Flutter support of WebView and simpler state management via [provider](https://pub.dev/packages/provider).

## Demo

### IFrame player

![default iframe player view](https://github.com/yh-luo/webviewtube/blob/main/resources/default_1.png)

### Decorated player

![decorated player view](https://github.com/yh-luo/webviewtube/blob/main/resources/decorated_1.png)

- [Webviewtube](#webviewtube)
  - [Why another package?](#why-another-package)
  - [Supported Platforms](#supported-platforms)
  - [Setup](#setup)
    - [Android](#android)
    - [iOS](#ios)
  - [Usage](#usage)
    - [Default IFrame player](#default-iframe-player)
    - [Widgets decorated player](#widgets-decorated-player)
    - [Configure the player](#configure-the-player)
      - [WebviewtubeOptions](#webviewtubeoptions)
      - [WebviewtubeController](#webviewtubecontroller)
  - [Customize the player](#customize-the-player)
  - [Acknowledgments](#acknowledgments)


## Why another package?

`youtube_player_flutter` and its dependency `flutter_inappwebview` have been in hiatus for a while. It's more reassuring to use the official [webview_flutter](https://pub.dev/packages/webview_flutter). Also, the performance issues of `youtube_player_flutter` are not resolved and make it problematic to use in some situations.

This package aims to solve the problems by:
- Depends on the official [webview_flutter](https://pub.dev/packages/webview_flutter) to provide a default IFrame player.
  - `WebviewtubePlayer` is a WebView and does not bundle with any other widgets.
- Proper state management with [provider](https://pub.dev/packages/provider).
  - `WebviewtubeVideoPlayer` combines the default player with customized widgets. The state management is carefully handled, which makes the player more maintainable, testable, and easily customizable.

## Supported Platforms

The same as [webview_flutter](https://pub.dev/packages/webview_flutter). On Android, hybrid composition mode is used.

- Android: SDK 19+
- iOS: 11.0+

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
WebviewtubePlayer(videoId: '4AoFA19gbLo')
```

### Widgets decorated player

```dart
WebviewtubeVideoPlayer(videoId: '4AoFA19gbLo')
```

### Configure the player

To configure the player, pass a `WebviewtubeOptions` to the player.
```dart
final options = const WebviewtubeOptions(
    forceHd: true,
    enableCaption: false,
);

/// `showControls` will always be false for [WebviewtubeVideoPlayer]
WebviewtubeVideoPlayer(videoId: '4AoFA19gbLo', options: options);
```

To listen to the player value (e.g., video metadata) and control the player (e.g., pause or load other videos), pass a `WebviewtubeController` and remember to dispose the controller when it's not in need.
```dart
// ...
// inside a state of a stateful widget
final controller = WebviewtubeController();

@override
void dispose() {
  controller.dispose();
  super.dispose();
}

@override
Widget build(BuildContext context) {
    return WebviewtubeVideoPlayer(
      videoId: '4AoFA19gbLo',
      controller: controller,
      );
}
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
