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
