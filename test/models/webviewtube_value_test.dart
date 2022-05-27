// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_declarations
import 'package:flutter_test/flutter_test.dart';
import 'package:webviewtube/webviewtube.dart';

void main() {
  group('PlayerState', () {
    group('fromData', () {
      test('-1', () {
        final actual = PlayerState.fromData(-1);

        expect(actual, PlayerState.unstarted);
        expect(actual.stateCode, -1);
      });

      test('0', () {
        final actual = PlayerState.fromData(0);

        expect(actual, PlayerState.ended);
        expect(actual.stateCode, 0);
      });

      test('1', () {
        final actual = PlayerState.fromData(1);

        expect(actual, PlayerState.playing);
        expect(actual.stateCode, 1);
      });

      test('2', () {
        final actual = PlayerState.fromData(2);

        expect(actual, PlayerState.paused);
        expect(actual.stateCode, 2);
      });

      test('3', () {
        final actual = PlayerState.fromData(3);

        expect(actual, PlayerState.buffering);
        expect(actual.stateCode, 3);
      });

      test('5', () {
        final actual = PlayerState.fromData(5);

        expect(actual, PlayerState.cued);
        expect(actual.stateCode, 5);
      });

      test('unknown', () {
        final actual = PlayerState.fromData(999);

        expect(actual, PlayerState.unknown);
        expect(actual.stateCode, null);
      });
    });
  });

  group('PlaybackQuality', () {
    group('fromData', () {
      test('small', () {
        final actual = PlaybackQuality.fromData('small');

        expect(actual, PlaybackQuality.small);
        expect(actual.quality, 'small');
      });

      test('medium', () {
        final actual = PlaybackQuality.fromData('medium');

        expect(actual, PlaybackQuality.medium);
        expect(actual.quality, 'medium');
      });

      test('large', () {
        final actual = PlaybackQuality.fromData('large');

        expect(actual, PlaybackQuality.large);
        expect(actual.quality, 'large');
      });

      test('hd720', () {
        final actual = PlaybackQuality.fromData('hd720');

        expect(actual, PlaybackQuality.hd720);
        expect(actual.quality, 'hd720');
      });

      test('hd1080', () {
        final actual = PlaybackQuality.fromData('hd1080');

        expect(actual, PlaybackQuality.hd1080);
        expect(actual.quality, 'hd1080');
      });

      test('highres', () {
        final actual = PlaybackQuality.fromData('highres');

        expect(actual, PlaybackQuality.highRes);
        expect(actual.quality, 'highres');
      });

      test('unknown', () {
        final actual = PlaybackQuality.fromData('?');

        expect(actual, PlaybackQuality.unknown);
        expect(actual.quality, null);
      });
    });
  });

  group('PlaybackRate', () {
    test('rate is correct', () {
      expect(PlaybackRate.quarter.rate, 0.25);
      expect(PlaybackRate.half.rate, 0.5);
      expect(PlaybackRate.threeQuarter.rate, 0.75);
      expect(PlaybackRate.normal.rate, 1);
      expect(PlaybackRate.oneAndAQuarter.rate, 1.25);
      expect(PlaybackRate.oneAndAHalf.rate, 1.5);
      expect(PlaybackRate.oneAndAThreeQuarter.rate, 1.75);
      expect(PlaybackRate.twice.rate, 2);
      expect(PlaybackRate.unknown.rate, null);
    });
  });

  group('PlayerError', () {
    group('fromData', () {
      test('invalidParameter', () {
        final actual = PlayerError.fromData(2);

        expect(actual, PlayerError.invalidParameter);
        expect(actual.errorCode, 2);
      });

      test('html5Error', () {
        final actual = PlayerError.fromData(5);

        expect(actual, PlayerError.html5Error);
        expect(actual.errorCode, 5);
      });

      test('videoNotFound', () {
        final actual = PlayerError.fromData(100);

        expect(actual, PlayerError.videoNotFound);
        expect(actual.errorCode, 100);
      });

      test('notEmbeddable', () {
        final actual = PlayerError.fromData(101);

        expect(actual, PlayerError.notEmbeddable);
        expect(actual.errorCode, 101);
      });

      test('notEmbeddableInDisguise', () {
        final actual = PlayerError.fromData(150);

        expect(actual, PlayerError.notEmbeddableInDisguise);
        expect(actual.errorCode, 150);
      });

      test('unknown', () {
        final actual = PlayerError.fromData(9999);

        expect(actual, PlayerError.unknown);
        expect(actual.errorCode, null);
      });
    });

    test('isEmpty', () {
      expect(PlayerError.empty.isEmpty, true);
      expect(PlayerError.html5Error.isEmpty, false);
    });
  });

  group('WebviewTubeValue', () {
    group('copyWith', () {
      test('isReady', () {
        final value = WebviewTubeValue(isReady: true);
        final actual = value.copyWith(isReady: false);

        expect(value != actual, true);
        expect(actual, WebviewTubeValue(isReady: false));
      });

      test('isMuted', () {
        final value = WebviewTubeValue(isMuted: true);
        final actual = value.copyWith(isMuted: false);

        expect(value != actual, true);
        expect(actual, WebviewTubeValue(isMuted: false));
      });

      test('playerState', () {
        final value = WebviewTubeValue(playerState: PlayerState.playing);
        final actual = value.copyWith(playerState: PlayerState.paused);

        expect(value != actual, true);
        expect(actual, WebviewTubeValue(playerState: PlayerState.paused));
      });

      test('playbackQuality', () {
        final value = WebviewTubeValue(playbackQuality: PlaybackQuality.small);
        final actual = value.copyWith(playbackQuality: PlaybackQuality.medium);

        expect(value != actual, true);
        expect(
            actual, WebviewTubeValue(playbackQuality: PlaybackQuality.medium));
      });

      test('playbackRate', () {
        final value = WebviewTubeValue(playbackRate: PlaybackRate.normal);
        final actual = value.copyWith(playbackRate: PlaybackRate.half);

        expect(value != actual, true);
        expect(actual, WebviewTubeValue(playbackRate: PlaybackRate.half));
      });

      test('position', () {
        final value = WebviewTubeValue(position: Duration(seconds: 1));
        final actual = value.copyWith(position: Duration(seconds: 2));

        expect(value != actual, true);
        expect(actual, WebviewTubeValue(position: Duration(seconds: 2)));
      });

      test('buffered', () {
        final value = WebviewTubeValue(buffered: 0);
        final actual = value.copyWith(buffered: 0.1);

        expect(value != actual, true);
        expect(actual, WebviewTubeValue(buffered: 0.1));
      });

      test('playerError', () {
        final value = WebviewTubeValue(playerError: PlayerError.empty);
        final actual = value.copyWith(playerError: PlayerError.html5Error);

        expect(value != actual, true);
        expect(actual, WebviewTubeValue(playerError: PlayerError.html5Error));
      });

      test('videoMetadata', () {
        final videoData = VideoMetadata(
            videoId: '123test',
            title: '123 test',
            author: 'test',
            duration: Duration(seconds: 2));
        final value = WebviewTubeValue(
            videoMetadata: VideoMetadata(
                videoId: 'test123',
                title: 'test 123',
                author: 'test',
                duration: Duration(seconds: 2)));
        final actual = value.copyWith(videoMetadata: videoData);

        expect(value != actual, true);
        expect(actual, WebviewTubeValue(videoMetadata: videoData));
      });
    });
  });

  group('VideoMetadata', () {
    test('isEmpty', () {
      expect(VideoMetadata.empty.isEmpty, true);
      expect(
          VideoMetadata(
                  videoId: 'test123',
                  title: 'test 123',
                  author: 'test',
                  duration: Duration(seconds: 2))
              .isEmpty,
          false);
    });

    test('fromData', () {
      final data = <String, dynamic>{
        'videoId': 'test123',
        'title': 'test 123',
        'author': 'test',
        'duration': 2.0
      };

      final actual = VideoMetadata.fromData(data);
      expect(actual.videoId, data['videoId']);
      expect(actual.title, data['title']);
      expect(actual.author, data['author']);
      expect(actual.duration,
          Duration(seconds: (data['duration'] as num).toInt()));
    });

    group('copyWith', () {
      test('videoId', () {
        final videoMetadata = VideoMetadata(
            videoId: '123test',
            title: '123 test',
            author: 'test',
            duration: Duration(seconds: 2));
        final videoId = 'test123';
        final actual = videoMetadata.copyWith(videoId: videoId);

        expect(videoMetadata != actual, true);
        expect(actual.videoId, videoId);
      });

      test('title', () {
        final videoMetadata = VideoMetadata(
            videoId: '123test',
            title: '123 test',
            author: 'test',
            duration: Duration(seconds: 2));
        final title = 'test 123';
        final actual = videoMetadata.copyWith(title: title);

        expect(videoMetadata != actual, true);
        expect(actual.title, title);
      });

      test('author', () {
        final videoMetadata = VideoMetadata(
            videoId: '123test',
            title: '123 test',
            author: 'test',
            duration: Duration(seconds: 2));
        final author = 'another test author';
        final actual = videoMetadata.copyWith(author: author);

        expect(videoMetadata != actual, true);
        expect(actual.author, author);
      });

      test('duration', () {
        final videoMetadata = VideoMetadata(
            videoId: '123test',
            title: '123 test',
            author: 'test',
            duration: Duration(seconds: 2));
        final duration = Duration(seconds: 1);
        final actual = videoMetadata.copyWith(duration: duration);

        expect(videoMetadata != actual, true);
        expect(actual.duration, duration);
      });
    });
  });
}
