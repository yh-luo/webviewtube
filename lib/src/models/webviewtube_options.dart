class WebviewtubeOptions {
  const WebviewtubeOptions(
      {this.currentTimeUpdateInterval = 130,
      this.enableCaption = true,
      this.captionLanguage = 'en',
      this.startAt = 0});

  /// Interval in milliseconds to get buffered ratio and elapsed seconds
  ///
  /// Smaller values result in smoother updating of the progress bar but reduce
  /// performance.
  /// Defaults to 150.
  final int currentTimeUpdateInterval;

  /// Enabling causes closed captions to be shown by default
  ///
  /// Defaults to true.
  final bool enableCaption;

  /// Specifies the default language that the player will use to display
  ///
  /// captions. Set the parameter's value to an
  /// [ISO 639-1 two-letter language code](http://www.loc.gov/standards/iso639-2/php/code_list.php).
  ///
  /// Defaults to `en`.
  final String captionLanguage;

  /// Specifies the default starting point of the video in seconds
  ///
  /// Defaults to 0.
  final int startAt;
}
