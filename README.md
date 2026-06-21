# Play YouTube videos on mobile devices with WebView

Use [IFrame Player API](https://developers.google.com/youtube/iframe_api_reference) and WebView to play YouTube videos on mobile devices.

This package leverages [webview_flutter](https://pub.dev/packages/webview_flutter) to embed a YouTube video player through the [IFrame Player API](https://developers.google.com/youtube/iframe_api_reference). For state management, it utilizes the [provider](https://pub.dev/packages/provider) package.

## Demo

### IFrame player

![default iframe player view](https://raw.githubusercontent.com/yh-luo/webviewtube/main/resources/default_1.png)

## Features

- `WebviewtubePlayer` provides a WebView that integrates with the YouTube IFrame Player API. Combine it with `WebviewtubeOptions(showControls: true)` to use YouTube's native controls, or build your own UI around `WebviewtubeController`.

> **Note:** `WebviewtubeVideoPlayer` (the widgets-decorated player) is deprecated as of 4.0.0. Overlaying custom controls on the YouTube iframe violates [YouTube's Required Minimum Functionality](https://developers.google.com/youtube/terms/required-minimum-functionality#overlays-and-frames). It will be removed in a future major release.

## Supported Platforms

The same as [webview_flutter](https://pub.dev/packages/webview_flutter). On Android, hybrid composition mode is used.

- Android: SDK 21+
- iOS: 12.0+

## Setup

### Android

Set the correct `minSdkVersion` in `android/app/build.gradle`

```groovy
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

### Configure the player

To customize or interact with the player, you can use a `WebviewtubeController` along with `WebviewtubeOptions`. The controller allows you to configure player options and interact with the player. Follow these steps to set up and use the controller:

1. **Initialize the Controller**: Create an instance of `WebviewtubeController` and pass the desired options using `WebviewtubeOptions`.

2. **Pass the Controller to the Player**: Provide the controller to the player widget.

3. **Dispose of the Controller**: To avoid memory leaks, always dispose of the controller when it's no longer needed to free up resources.

```dart
// ...
// inside a state of a stateful widget
late final WebviewtubeController controller;

@override
void initState() {
  super.initState();
  controller = WebviewtubeController(
    options: const WebviewtubeOptions(
      enableCaption: false,
    ),
  );
}

@override
void dispose() {
  controller.dispose();
  super.dispose();
}

@override
Widget build(BuildContext context) {
    return WebviewtubePlayer(
      videoId: '4AoFA19gbLo',
      controller: controller,
    );
}
```

## Customize the player

This package uses [provider](https://pub.dev/packages/provider) for state management, but you're free to fork and use your preferred tools. Build your own UI around `WebviewtubeController` — see `example/lib/customized_player.dart` for a worked example that demonstrates controlling the player and updating UI based on player events and state changes.

## Acknowledgments

This package is inspired by the following packages, for which credit goes out to the respective authors.

- [youtube_player_flutter](https://pub.dev/packages/youtube_player_flutter) by [Sarbagya Dhaubanjar](https://github.com/sarbagyastha/youtube_player_flutter)
- [youtube_player_webview](https://pub.dev/packages/youtube_player_webview) by [Ravindra barthwal](https://github.com/ravindrabarthwal/youtube_player_webview)
