class WebviewtubeOptions {
  const WebviewtubeOptions({
    this.autoPlay = true,
    this.mute = false,
    this.loop = false,
    this.interfaceLanguage = 'en',
    this.enableCaption = true,
    this.captionLanguage = 'en',
    this.startAt = 0,
    this.currentTimeUpdateInterval = 130,
  });

  /// Automatically starts the video after initialization.
  ///
  /// Note that certain mobile browsers (such as Chrome and Safari) only allows
  /// playback to take place if it's initiated by a user interaction (such as
  /// tapping on the player). Due to this restriction, [autoPlay] won't work in
  /// all mobile environments.
  /// Resource: [IFrame Player API: Autoplay and Scripted Playback](https://developers.google.com/youtube/iframe_api_reference#Autoplay_and_scripted_playback)
  ///
  /// Defaults to true.
  final bool autoPlay;

  /// Mutes the player after initialization.
  ///
  /// Defaults to false.
  final bool mute;

  /// Plays the video repeatedly.
  ///
  /// Defaults to false.
  final bool loop;

  /// The player's interface language.
  ///
  /// Set the parameter's value to an
  /// [ISO 639-1 two-letter language code](http://www.loc.gov/standards/iso639-2/php/code_list.php).
  ///
  /// Defaults to `en`.
  final String interfaceLanguage;

  /// Shows causes closed captions by default.
  ///
  /// Defaults to true.
  final bool enableCaption;

  /// The default language that the player will use to display captions.
  ///
  /// Set the parameter's value to an
  /// [ISO 639-1 two-letter language code](http://www.loc.gov/standards/iso639-2/php/code_list.php).
  ///
  /// Defaults to `en`.
  final String captionLanguage;

  /// Interval in milliseconds to get buffered ratio and elapsed seconds
  ///
  /// Smaller values result in smoother updating of the progress bar but reduce
  /// performance.
  /// Defaults to 150.
  final int currentTimeUpdateInterval;

  /// The default starting point of the video in seconds
  ///
  /// Defaults to 0.
  final int startAt;
}
