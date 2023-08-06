import 'package:flutter/material.dart';

/// {@template webviewtube_options}
/// Options for the player.
/// {@endtemplate}
@immutable
class WebviewtubeOptions {
  /// {@macro webviewtube_options}
  const WebviewtubeOptions({
    this.showControls = true,
    this.mute = false,
    this.loop = false,
    this.forceHd = false,
    this.interfaceLanguage = 'en',
    this.enableCaption = true,
    this.captionLanguage = 'en',
    this.startAt = 0,
    this.endAt,
    this.currentTimeUpdateInterval = 130,
    this.aspectRatio = 16 / 9,
  });

  /// Display the YouTube video player controls.
  ///
  /// Set to false if you want to use customized controls.
  /// Defaults to true.
  final bool showControls;

  /// Mutes the player after initialization.
  ///
  /// Defaults to false.
  final bool mute;

  /// Plays the video repeatedly.
  ///
  /// Defaults to false.
  final bool loop;

  /// Forces High Definition video quality when possible.
  ///
  /// Defaults to false.
  final bool forceHd;

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

  /// The default starting point of the video in seconds
  ///
  /// Defaults to 0.
  final int startAt;

  /// The default end point of the video in seconds
  ///
  /// If not set, this parameter is not passed to the player.
  /// Defaults to null.
  final int? endAt;

  /// Interval in milliseconds to get buffered ratio and elapsed seconds.
  ///
  /// Smaller values result in more frequent updates but reduce the performance.
  /// Defaults to 130.
  final int currentTimeUpdateInterval;

  /// The aspect ratio to attempt to use.
  ///
  /// Defaults to 16 / 9.
  final double aspectRatio;

  WebviewtubeOptions copyWith({
    bool? showControls,
    bool? mute,
    bool? loop,
    bool? forceHd,
    String? interfaceLanguage,
    bool? enableCaption,
    String? captionLanguage,
    int? startAt,
    int? endAt,
    int? currentTimeUpdateInterval,
    double? aspectRatio,
  }) {
    return WebviewtubeOptions(
      showControls: showControls ?? this.showControls,
      mute: mute ?? this.mute,
      loop: loop ?? this.loop,
      forceHd: forceHd ?? this.forceHd,
      interfaceLanguage: interfaceLanguage ?? this.interfaceLanguage,
      enableCaption: enableCaption ?? this.enableCaption,
      captionLanguage: captionLanguage ?? this.captionLanguage,
      startAt: startAt ?? this.startAt,
      endAt: endAt ?? this.endAt,
      currentTimeUpdateInterval:
          currentTimeUpdateInterval ?? this.currentTimeUpdateInterval,
      aspectRatio: aspectRatio ?? this.aspectRatio,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is WebviewtubeOptions &&
      other.runtimeType == runtimeType &&
      other.showControls == showControls &&
      other.mute == mute &&
      other.loop == loop &&
      other.forceHd == forceHd &&
      other.interfaceLanguage == interfaceLanguage &&
      other.enableCaption == enableCaption &&
      other.captionLanguage == captionLanguage &&
      other.startAt == startAt &&
      other.endAt == endAt &&
      other.currentTimeUpdateInterval == currentTimeUpdateInterval &&
      other.aspectRatio == aspectRatio;

  @override
  int get hashCode => Object.hash(
        runtimeType,
        showControls,
        mute,
        loop,
        forceHd,
        interfaceLanguage,
        enableCaption,
        captionLanguage,
        startAt,
        endAt,
        currentTimeUpdateInterval,
        aspectRatio,
      );

  @override
  String toString() {
    return 'WebviewtubeOptions('
        'showControls: $showControls, '
        'mute: $mute, '
        'loop: $loop, '
        'forceHd: $forceHd, '
        'interfaceLanguage: $interfaceLanguage, '
        'enableCaption: $enableCaption, '
        'captionLanguage: $captionLanguage, '
        'startAt: $startAt, '
        'endAt: $endAt, '
        'currentTimeUpdateInterval: $currentTimeUpdateInterval, '
        'aspectRatio: $aspectRatio)';
  }
}
