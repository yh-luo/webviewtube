import 'package:flutter/material.dart';

/// Current state of the player.
///
/// [player.getPlayerState()](https://developers.google.com/youtube/iframe_api_reference#Playback_status).
enum PlayerState {
  /// The player is loaded but not started yet.
  unstarted(-1),

  /// The player has finished playing the video.
  ended(0),

  /// The player is playing the video.
  playing(1),

  /// The player is paused.
  paused(2),

  /// The player is buffering the video.
  buffering(3),

  /// The player has loaded the cued video.
  cued(5),

  /// The player status is unknown.
  unknown(null);

  /// The status code.
  final int? stateCode;

  const PlayerState(this.stateCode);

  /// Returns the [PlayerState] for the given [stateCode].
  factory PlayerState.fromData(int data) {
    late final PlayerState playerState;
    switch (data) {
      case -1:
        playerState = PlayerState.unstarted;
        break;
      case 0:
        playerState = PlayerState.ended;
        break;
      case 1:
        playerState = PlayerState.playing;
        break;
      case 2:
        playerState = PlayerState.paused;
        break;
      case 3:
        playerState = PlayerState.buffering;
        break;
      case 5:
        playerState = PlayerState.cued;
        break;
      default:
        playerState = PlayerState.unknown;
        break;
    }

    return playerState;
  }
}

/// Current playback quality of the player.
///
/// Noted that it's currently not possible to set the quality of the player via
/// IFrame API.
enum PlaybackQuality {
  /// Small, 320px by 240px.
  small('small'),

  /// Medium, 640px by 360px (for 16:9 aspect ratio) or 480px by 360px (for 4:3
  /// aspect ratio).
  medium('medium'),

  /// Large, 853px by 480px (for 16:9 aspect ratio) or 640px by 480px (for 4:3
  /// aspect ratio).
  large('large'),

  /// HD720, 1280px by 720px (for 16:9 aspect ratio) or 960px by 720px (for 4:3
  /// aspect ratio).
  hd720('hd720'),

  /// HD1080, 1920px by 1080px (for 16:9 aspect ratio) or 1440px by 1080px  (for
  /// 4:3 aspect ratio).
  hd1080('hd1080'),

  /// High resolution, the player's aspect ratio is greater than 1920px by
  /// 1080px.
  highRes('highres'),

  /// The playback quality is unknown.
  unknown(null);

  /// The quality code.
  final String? quality;
  const PlaybackQuality(this.quality);

  /// Returns the [PlaybackQuality] for the given [quality].
  factory PlaybackQuality.fromData(String data) {
    late final PlaybackQuality playbackQuality;
    switch (data) {
      case 'small':
        playbackQuality = PlaybackQuality.small;
        break;
      case 'medium':
        playbackQuality = PlaybackQuality.medium;
        break;
      case 'large':
        playbackQuality = PlaybackQuality.large;
        break;
      case 'hd720':
        playbackQuality = PlaybackQuality.hd720;
        break;
      case 'hd1080':
        playbackQuality = PlaybackQuality.hd1080;
        break;
      case 'highres':
        playbackQuality = PlaybackQuality.highRes;
        break;
      default:
        playbackQuality = PlaybackQuality.unknown;
        break;
    }

    return playbackQuality;
  }
}

/// Current playback rate of the player.
enum PlaybackRate {
  /// Playback rate is 0.25.
  quarter(0.25),

  /// Playback rate is 0.5.
  half(0.5),

  /// Playback rate is 0.75
  threeQuarter(0.75),

  /// Playback rate is 1.0.
  normal(1),

  /// Playback rate is 1.25.
  oneAndAQuarter(1.25),

  /// Playback rate is 1.5.
  oneAndAHalf(1.5),

  /// Playback rate is 1.75.
  oneAndAThreeQuarter(1.75),

  /// Playback rate is 2.0.
  twice(2),

  /// Playback rate is unknown.
  unknown(null);

  /// The playback rate.
  final double? rate;
  const PlaybackRate(this.rate);

  /// Returns the [PlaybackRate] for the given [rate].
  factory PlaybackRate.fromData(num data) {
    late final PlaybackRate playbackRate;
    final percentage = (data * 100).toInt();
    switch (percentage) {
      case 25:
        playbackRate = PlaybackRate.quarter;
        break;
      case 50:
        playbackRate = PlaybackRate.half;
        break;
      case 75:
        playbackRate = PlaybackRate.threeQuarter;
        break;
      case 100:
        playbackRate = PlaybackRate.normal;
        break;
      case 125:
        playbackRate = PlaybackRate.oneAndAQuarter;
        break;
      case 150:
        playbackRate = PlaybackRate.oneAndAHalf;
        break;
      case 175:
        playbackRate = PlaybackRate.oneAndAThreeQuarter;
        break;
      case 200:
        playbackRate = PlaybackRate.twice;
        break;
      default:
        playbackRate = PlaybackRate.unknown;
        break;
    }

    return playbackRate;
  }
}

/// Current error the player encountered.
enum PlayerError {
  /// No error.
  empty(null),

  /// The request contains an invalid parameter value.
  invalidParameter(2),

  /// The requested content cannot be played in an HTML5 player or another error
  /// related to the HTML5 player has occurred.
  html5Error(5),

  /// The video requested was not found.
  videoNotFound(100),

  /// The owner of the requested video does not allow it to be played in
  /// embedded players
  notEmbeddable(101),

  /// This error is the same as 101. It's just a 101 error in disguise!
  notEmbeddableInDisguise(150),

  /// The error is unknown.
  unknown(null);

  /// The error code.
  final int? errorCode;
  const PlayerError(this.errorCode);

  /// Returns the [PlayerError] for the given [errorCode].
  factory PlayerError.fromData(int data) {
    late final PlayerError playerError;
    switch (data) {
      case 2:
        playerError = PlayerError.invalidParameter;
        break;
      case 5:
        playerError = PlayerError.html5Error;
        break;
      case 100:
        playerError = PlayerError.videoNotFound;
        break;
      case 101:
        playerError = PlayerError.notEmbeddable;
        break;
      case 150:
        playerError = PlayerError.notEmbeddableInDisguise;
        break;
      default:
        playerError = PlayerError.unknown;
        break;
    }

    return playerError;
  }

  /// Whether no error is present.
  bool get isEmpty => this == empty;
}

/// Current value [WebviewtubeController] holds.
@immutable
class WebviewTubeValue {
  /// Constructor for [WebviewTubeValue].
  const WebviewTubeValue({
    this.isReady = false,
    this.isMuted = false,
    this.playerState = PlayerState.unstarted,
    this.playbackQuality = PlaybackQuality.hd720,
    this.playbackRate = PlaybackRate.normal,
    this.position = Duration.zero,
    this.buffered = 0,
    this.playerError = PlayerError.empty,
    this.videoMetadata = VideoMetadata.empty,
  });

  /// Whether the player is ready.
  final bool isReady;

  /// Whether the player is muted.
  final bool isMuted;

  /// The current player state.
  final PlayerState playerState;

  /// The current playback quality.
  final PlaybackQuality playbackQuality;

  /// The current playback rate.
  final PlaybackRate playbackRate;

  /// The current position of the video.
  final Duration position;

  /// The current buffered position of the video.
  final double buffered;

  /// The current error.
  final PlayerError playerError;

  /// The current video metadata.
  final VideoMetadata videoMetadata;

  /// Returns a new [WebviewTubeValue] with updated parameters.
  WebviewTubeValue copyWith({
    bool? isReady,
    bool? isMuted,
    PlayerState? playerState,
    PlaybackQuality? playbackQuality,
    PlaybackRate? playbackRate,
    Duration? position,
    double? buffered,
    PlayerError? playerError,
    VideoMetadata? videoMetadata,
  }) {
    return WebviewTubeValue(
      isReady: isReady ?? this.isReady,
      isMuted: isMuted ?? this.isMuted,
      playerState: playerState ?? this.playerState,
      playbackQuality: playbackQuality ?? this.playbackQuality,
      playbackRate: playbackRate ?? this.playbackRate,
      position: position ?? this.position,
      buffered: buffered ?? this.buffered,
      playerError: playerError ?? this.playerError,
      videoMetadata: videoMetadata ?? this.videoMetadata,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is WebviewTubeValue &&
      other.isReady == isReady &&
      other.isMuted == isMuted &&
      other.playerState == playerState &&
      other.playbackQuality == playbackQuality &&
      other.playbackRate == playbackRate &&
      other.position == position &&
      other.buffered == buffered &&
      other.playerError == playerError &&
      other.videoMetadata == videoMetadata;

  @override
  int get hashCode => hashValues(isReady, isMuted, playerState, playbackQuality,
      playbackRate, position, buffered, playerError, videoMetadata);
}

/// The metadata of the video.
@immutable
class VideoMetadata {
  /// Constructor for [VideoMetadata].
  const VideoMetadata({
    required this.videoId,
    required this.title,
    required this.author,
    required this.duration,
  });

  /// The video id of the current loaded video.
  final String videoId;

  /// The title of the current loaded video.
  final String title;

  /// The author of the current loaded video.
  final String author;

  /// The duration of the current loaded video.
  final Duration duration;

  /// Whether the metadata is empty. The metadata is available after the video
  /// starts playing.
  bool get isEmpty => this == empty;

  /// Empty metadata.
  static const VideoMetadata empty = VideoMetadata(
      videoId: '', title: '', author: '', duration: Duration.zero);

  /// Returns the [VideoMetadata] with given data.
  factory VideoMetadata.fromData(Map<String, dynamic> data) {
    final durationInMs = (((data['duration'] ?? 0) as num) * 1000.0).floor();
    return VideoMetadata(
        videoId: data['videoId'],
        title: data['title'],
        author: data['author'],
        duration: Duration(milliseconds: durationInMs));
  }

  /// Returns a new [VideoMetadata] with updated parameters.
  VideoMetadata copyWith({
    String? videoId,
    String? title,
    String? author,
    Duration? duration,
  }) {
    return VideoMetadata(
        videoId: videoId ?? this.videoId,
        title: title ?? this.title,
        author: author ?? this.author,
        duration: duration ?? this.duration);
  }

  @override
  bool operator ==(Object other) =>
      other is VideoMetadata &&
      other.videoId == videoId &&
      other.title == title &&
      other.author == author &&
      other.duration == duration;

  @override
  int get hashCode => hashValues(videoId, title, author, duration);
}
