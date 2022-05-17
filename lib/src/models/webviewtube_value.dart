import 'package:flutter/material.dart';

enum PlayerState {
  unstarted(-1),
  ended(0),
  playing(1),
  paused(2),
  buffering(3),
  cued(5),
  unknown(null);

  final int? stateCode;
  const PlayerState(this.stateCode);
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

enum PlaybackQuality {
  small('small'),
  medium('medium'),
  large('large'),
  hd720('hd720'),
  hd1080('hd1080'),
  highRes('highres'),
  unknown(null);

  final String? quality;
  const PlaybackQuality(this.quality);
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

enum PlayerError {
  empty(null),
  invalidParameter(2),
  html5Error(5),
  videoNotFound(100),
  notEmbeddable(101),
  notEmbeddableInDisguise(150),
  unknown(null);

  final int? errorCode;
  const PlayerError(this.errorCode);
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
}

@immutable
class WebviewTubeValue {
  final bool isReady;
  final PlayerState playerState;
  final PlaybackQuality playbackQuality;
  final Duration position;
  final double buffered;
  final PlayerError playerError;
  final VideoMetadata videoMetadata;

  const WebviewTubeValue({
    this.isReady = false,
    this.playerState = PlayerState.unstarted,
    this.playbackQuality = PlaybackQuality.hd720,
    this.position = Duration.zero,
    this.buffered = 0,
    this.playerError = PlayerError.empty,
    this.videoMetadata = VideoMetadata.empty,
  });

  WebviewTubeValue copyWith({
    bool? isReady,
    PlayerState? playerState,
    PlaybackQuality? playbackQuality,
    Duration? position,
    double? buffered,
    PlayerError? playerError,
    VideoMetadata? videoMetadata,
  }) {
    return WebviewTubeValue(
      isReady: isReady ?? this.isReady,
      playerState: playerState ?? this.playerState,
      playbackQuality: playbackQuality ?? this.playbackQuality,
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
      other.playerState == playerState &&
      other.playbackQuality == playbackQuality &&
      other.position == position &&
      other.buffered == buffered &&
      other.playerError == playerError &&
      other.videoMetadata == videoMetadata;

  @override
  int get hashCode => hashValues(isReady, playerState, playbackQuality,
      position, buffered, playerError, videoMetadata);
}

@immutable
class VideoMetadata {
  final String videoId;
  final String title;
  final String author;
  final Duration duration;

  const VideoMetadata({
    required this.videoId,
    required this.title,
    required this.author,
    required this.duration,
  });

  static const VideoMetadata empty = VideoMetadata(
      videoId: '', title: '', author: '', duration: Duration.zero);

  factory VideoMetadata.fromData(Map<String, dynamic> data) {
    final durationInMs = (((data['duration'] ?? 0) as num) * 1000.0).floor();
    return VideoMetadata(
        videoId: data['videoId'],
        title: data['title'],
        author: data['author'],
        duration: Duration(milliseconds: durationInMs));
  }

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
