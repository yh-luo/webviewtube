# 3.1.0

## Breaking Changes

- Updated minimum supported SDK version to Flutter 3.16.6
- Updated minimum supported iOS version to 12.0

## Features

- Added `origin` to `WebviewtubeOptions` to specify the domain origin for the embedded YouTube player iframe.

# 3.0.0

This release introduces breaking changes, new features and important fixes. Please refer to the `Configure the player` section in the README for updated usage instructions.

## Breaking Changes

- The `options` parameter has been moved from `WebviewtubeVideoPlayer` to `WebviewtubeController`.

## Features

- Added `onPlayerNavigationRequest` to controller which allow webview navigation events to be handled by the app.

## Fixes

- Fixed cast errors in the `onCurrentTimeChange` callback.
- Prevented video loading errors by setting the `origin` parameter in the player configuration.

# 2.1.3

- chore: update example
- refactor!: prevent exporting internal widgets
- chore: update supported platforms and description
- refactor: remove webviewtube javascript channel when not used

# 2.1.2

- doc: update library doc
- ci: test 3.13.9, 3.16.9, 3.19.6, 3.22.3 and 3.24.0
- doc: update readme

# 2.1.1

- refactor: fix linting problems to supports both versions above/below 3.10
- chore: upgrade dependencies

# 2.1.0

- doc: updates iOS minimum version in README
- feat: supports Dart 3.0
- refactor: remove `modestbranding` from player configuration after the [deprecation announcement](https://developers.google.com/youtube/player_parameters#august-15,-2023)
- refactor: do not finalize internal `WebViewController` (to make hot reloading work)
- refactor: disable the restrictions on automatic media playback for android platform
- fix: safer casting of messages

# 2.0.0

- fix: `WebviewtubeOptions.loop` was not working
- refactor!: `autoplay` was removed from options
  - Since it's not working on mobile platforms, it's removed to avoid confusion.
    - [source](https://stackoverflow.com/a/15093243/9717762)
- refactor!: [webview_flutter](https://pub.dev/packages/webview_flutter) 4.0 migration
- feat: the ability to change aspect ratio in `WebviewtubeOptions.aspectRatio`
- fix: `WebviewtubeOptions.copyWith` incorrectly overrode `currentTimeUpdateInterval`

# 1.4.1

- fix: playlist_player demo is unable to go back to the first video
- fix: `==` should include runtimeType

# 1.4.0

- feat: implement `loadPlaylist` and `cuePlaylist`
- feat: add demo for playing a playlist
- refactor: update the demo for customized player
- doc: fix typos

# 1.3.1

- refactor: implement `toString` for models
- doc: use templates for constructors
- doc: add more explanation for `WebviewtubeController`

# 1.3.0

- doc: update outdated documentation
- refactor: finalize webview controller
- doc: update example and readme for player configuration
- __BREAKING__ refactor!: decouple options from controller
- refactor: dispose the default controller automatically
  - If a controller is provided to the player, the user should dispose it manually.

# 1.2.0

- refactor: remove unused functions
- feat: add onPlayerReady, onPlayerError and onPlayerWebResourceError callbacks
- __BREAKING__ refactor!: make videoId a named parameter

# 1.1.0

## Fixed

- `hashCode` for `WebviewTubeValue`, `VideoMetadata`, and `ProgressBarColors`
should include `runtimeType`
- Ignore gestures for the controls when the video is playing

## Changed

- Removed the unused `ActionButton` widget
- A replay button is shown when video has ended

# 1.0.0

- Initial release.
