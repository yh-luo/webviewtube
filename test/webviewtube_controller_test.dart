// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_declarations
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:webviewtube/webviewtube.dart';

import 'webviewtube_controller_test.mocks.dart';

@GenerateMocks([WebViewController])
void main() {
  final webViewController = MockWebViewController();

  group('WebviewtubeController', () {
    test('can be instantiated', () {
      final actual = WebviewtubeController();

      expect(actual, isNotNull);
      expect(actual.isPlaylist, false);
      expect(actual.value, WebviewTubeValue());
    });

    test('onWebviewCreated', () {
      final controller = WebviewtubeController();

      controller.onWebviewCreated(webViewController);
      expect(controller.webViewController, webViewController);
    });

    group('onReady', () {
      test('updates value', () {
        final controller = WebviewtubeController();

        controller.onReady();
        expect(controller.value.isReady, true);
        verifyNoMoreInteractions(webViewController);
      });

      test('calls callback', () {
        var called = false;
        final controller = WebviewtubeController(onPlayerReady: () {
          called = true;
        });

        controller.onReady();
        expect(called, true);
      });
    });

    group('onError', () {
      test('updates value', () {
        final controller = WebviewtubeController();

        controller.onError(100);
        expect(controller.value.playerError, PlayerError.videoNotFound);
      });

      test('calls callback', () {
        var called = false;
        final controller = WebviewtubeController(onPlayerError: (error) {
          called = true;
        });

        controller.onError(100);
        expect(called, true);
      });
    });

    group('onWebResourceError', () {
      test('updates value', () {
        final controller = WebviewtubeController();
        final error = WebResourceError(errorCode: 1, description: 'test');

        controller.onWebResourceError(error);
        expect(controller.value.playerError, PlayerError.unknown);
      });

      test('calls callback', () {
        var called = false;
        final controller =
            WebviewtubeController(onPlayerWebResourceError: (error) {
          called = true;
        });

        controller.onWebResourceError(
            WebResourceError(errorCode: 1, description: 'test'));
        expect(called, true);
      });
    });

    group('onPlayerStateChange', () {
      test('updates value', () {
        final controller = WebviewtubeController();

        controller.onPlayerStateChange(2);
        expect(controller.value.playerState, PlayerState.paused);
      });

      test('set isReady false when video is buffering', () {
        final controller = WebviewtubeController();

        controller.onPlayerStateChange(3);
        expect(controller.value.playerState, PlayerState.buffering);
        expect(controller.value.isReady, false);
      });
    });

    group('onPlaybackQualityChange', () {
      test('updates value', () {
        final controller = WebviewtubeController();

        controller.onPlaybackQualityChange('highres');
        expect(controller.value.playbackQuality, PlaybackQuality.highRes);
      });
    });

    group('onPlaybackRateChange', () {
      test('updates value', () {
        final controller = WebviewtubeController();

        controller.onPlaybackRateChange(0.75);
        expect(controller.value.playbackRate, PlaybackRate.threeQuarter);
      });
    });

    group('onVideoDataChange', () {
      test('updates value', () {
        final controller = WebviewtubeController();
        final data = {
          'duration': 100,
          'title': 'The Great Dart',
          'author': 'Dash',
          'videoId': '12345678901',
        };

        controller.onVideoDataChange(data);
        final actual = controller.value.videoMetadata;
        expect(actual.isEmpty, false);
        expect(actual.title, data['title']);
      });
    });

    group('onCurrentTimeChange', () {
      test('updates value', () {
        final controller = WebviewtubeController();
        final data = {
          'position': 100.0,
          'buffered': 0.5,
        };

        controller.onCurrentTimeChange(data);
        expect(controller.value.position, Duration(seconds: 100));
        expect(controller.value.buffered, 0.5);
      });
    });

    group('play', () {
      test('calls play()', () {
        final controller = WebviewtubeController();
        controller.onWebviewCreated(webViewController);
        controller.onReady();

        controller.play();
        verify(webViewController.runJavascript('play()'));
      });
    });

    group('pause', () {
      test('calls pause()', () {
        final controller = WebviewtubeController();
        controller.onWebviewCreated(webViewController);
        controller.onReady();

        controller.pause();
        verify(webViewController.runJavascript('pause()'));
      });
    });

    group('mute', () {
      test('calls mute()', () {
        final controller = WebviewtubeController();
        controller.onWebviewCreated(webViewController);
        controller.onReady();

        controller.mute();
        verify(webViewController.runJavascript('mute()'));
      });

      test('updates value', () {
        final controller = WebviewtubeController();
        controller.onWebviewCreated(webViewController);
        controller.onReady();

        controller.mute();
        expect(controller.value.isMuted, true);
      });
    });

    group('unMute', () {
      test('calls unMute()', () {
        final controller = WebviewtubeController();
        controller.onWebviewCreated(webViewController);
        controller.onReady();

        controller.unMute();
        verify(webViewController.runJavascript('unMute()'));
      });

      test('updates value', () {
        final controller = WebviewtubeController();
        controller.onWebviewCreated(webViewController);
        controller.onReady();

        controller.unMute();
        expect(controller.value.isMuted, false);
      });
    });

    group('setPlaybackRate', () {
      test('calls setPlaybackRate()', () {
        final controller = WebviewtubeController();
        controller.onWebviewCreated(webViewController);
        controller.onReady();

        controller.setPlaybackRate(PlaybackRate.half);
        verify(webViewController.runJavascript('setPlaybackRate(0.5)'));
      });
    });

    group('seekTo', () {
      test('calls seekTo()', () {
        final controller = WebviewtubeController();
        controller.onWebviewCreated(webViewController);
        controller.onReady();

        controller.seekTo(Duration(seconds: 1));
        verify(webViewController.runJavascript('seekTo(1, false)'));
      });

      test('updates value', () {
        final controller = WebviewtubeController();
        controller.onWebviewCreated(webViewController);
        controller.onReady();

        controller.seekTo(Duration(seconds: 1));
        expect(controller.value.position, Duration(seconds: 1));
      });

      test('calls play() afterwards', () {
        final controller = WebviewtubeController();
        controller.onWebviewCreated(webViewController);
        controller.onReady();

        controller.seekTo(Duration(seconds: 1));
        verifyInOrder([
          webViewController.runJavascript('seekTo(1, false)'),
          webViewController.runJavascript('play()')
        ]);
      });
    });

    group('replay', () {
      test('calls seekTo() and play()', () {
        final controller = WebviewtubeController();
        controller.onWebviewCreated(webViewController);
        controller.onReady();

        controller.replay();
        verifyInOrder([
          webViewController.runJavascript('seekTo(0, false)'),
          webViewController.runJavascript('play()')
        ]);
      });
    });

    group('reload', () {
      test('calls reload', () {
        final controller = WebviewtubeController();
        controller.onWebviewCreated(webViewController);

        controller.reload();

        verify(webViewController.reload());
      });
    });

    group('load', () {
      test('calls loadById', () {
        final videoId = 'test123';
        final controller = WebviewtubeController();
        controller.onWebviewCreated(webViewController);
        controller.onReady();

        controller.load(videoId);

        verify(
            webViewController.runJavascript('loadById({videoId: "$videoId"})'));
      });

      test('calls with startAt', () {
        final videoId = 'test123';
        final startAt = 5;
        final controller = WebviewtubeController();
        controller.onWebviewCreated(webViewController);
        controller.onReady();

        controller.load(videoId, startAt: startAt);

        verify(webViewController.runJavascript(
            'loadById({videoId: "$videoId", startSeconds: $startAt})'));
      });

      test('calls with endAt', () {
        final videoId = 'test123';
        final startAt = 1;
        final endAt = 5;
        final controller = WebviewtubeController();
        controller.onWebviewCreated(webViewController);
        controller.onReady();

        controller.load(videoId, startAt: startAt, endAt: endAt);

        verify(webViewController.runJavascript(
            'loadById({videoId: "$videoId", startSeconds: $startAt, '
            'endSeconds: $endAt})'));
      });

      test('isPlaylist = false', () {
        final videoId = 'test123';
        final controller = WebviewtubeController();
        controller.onWebviewCreated(webViewController);
        controller.onReady();

        controller.load(videoId);

        expect(controller.isPlaylist, false);
      });

      test('nextVideo is doing nothing', () {
        final videoId = 'test123';
        final controller = WebviewtubeController();
        controller.onWebviewCreated(webViewController);
        controller.onReady();

        controller.load(videoId);
        controller.nextVideo();

        verifyNever(webViewController.runJavascript('nextVideo()'));
      });

      test('previousVideo is doing nothing', () {
        final videoId = 'test123';
        final controller = WebviewtubeController();
        controller.onWebviewCreated(webViewController);
        controller.onReady();

        controller.load(videoId);
        controller.previousVideo();

        verifyNever(webViewController.runJavascript('previousVideo()'));
      });

      test('playVideoAt is doing nothing', () {
        final videoId = 'test123';
        final controller = WebviewtubeController();
        controller.onWebviewCreated(webViewController);
        controller.onReady();

        controller.load(videoId);
        controller.playVideoAt(2);

        verifyNever(webViewController.runJavascript('playVideoAt(2)'));
      });
    });

    group('cue', () {
      test('calls cueById', () {
        final videoId = 'test123';
        final controller = WebviewtubeController();
        controller.onWebviewCreated(webViewController);
        controller.onReady();

        controller.cue(videoId);

        verify(
            webViewController.runJavascript('cueById({videoId: "$videoId"})'));
      });

      test('calls with startAt', () {
        final videoId = 'test123';
        final startAt = 5;
        final controller = WebviewtubeController();
        controller.onWebviewCreated(webViewController);
        controller.onReady();

        controller.cue(videoId, startAt: startAt);

        verify(webViewController.runJavascript(
            'cueById({videoId: "$videoId", startSeconds: $startAt})'));
      });

      test('calls with endAt', () {
        final videoId = 'test123';
        final startAt = 1;
        final endAt = 5;
        final controller = WebviewtubeController();
        controller.onWebviewCreated(webViewController);
        controller.onReady();

        controller.cue(videoId, startAt: startAt, endAt: endAt);

        verify(webViewController.runJavascript(
            'cueById({videoId: "$videoId", startSeconds: $startAt, '
            'endSeconds: $endAt})'));
      });

      test('isPlaylist = false', () {
        final videoId = 'test123';
        final controller = WebviewtubeController();
        controller.onWebviewCreated(webViewController);
        controller.onReady();

        controller.cue(videoId);

        expect(controller.isPlaylist, false);
      });

      test('nextVideo is doing nothing', () {
        final videoId = 'test123';
        final controller = WebviewtubeController();
        controller.onWebviewCreated(webViewController);
        controller.onReady();

        controller.cue(videoId);
        controller.nextVideo();

        verifyNever(webViewController.runJavascript('nextVideo()'));
      });

      test('previousVideo is doing nothing', () {
        final videoId = 'test123';
        final controller = WebviewtubeController();
        controller.onWebviewCreated(webViewController);
        controller.onReady();

        controller.cue(videoId);
        controller.previousVideo();

        verifyNever(webViewController.runJavascript('previousVideo()'));
      });

      test('playVideoAt is doing nothing', () {
        final videoId = 'test123';
        final controller = WebviewtubeController();
        controller.onWebviewCreated(webViewController);
        controller.onReady();

        controller.cue(videoId);
        controller.playVideoAt(2);

        verifyNever(webViewController.runJavascript('playVideoAt(2)'));
      });
    });

    group('loadPlaylist', () {
      test('calls loadPlaylist with a string', () {
        final playlistId = 'test123';
        final controller = WebviewtubeController();
        controller.onWebviewCreated(webViewController);
        controller.onReady();

        controller.loadPlaylist(playlistId: playlistId);

        verify(
            webViewController.runJavascript('loadPlaylist($playlistId, 0, 0)'));
      });

      test('calls loadPlaylist with an array', () {
        final videoIds = ['1', '2', '3', '4', '5'];
        final controller = WebviewtubeController();
        controller.onWebviewCreated(webViewController);
        controller.onReady();

        controller.loadPlaylist(videoIds: videoIds);

        verify(webViewController
            .runJavascript('loadPlaylist(["1", "2", "3", "4", "5"], 0, 0)'));
      });

      test('calls loadPlaylist with index', () {
        final playlistId = 'test123';
        final index = 1;
        final controller = WebviewtubeController();
        controller.onWebviewCreated(webViewController);
        controller.onReady();

        controller.loadPlaylist(playlistId: playlistId, index: index);

        verify(webViewController
            .runJavascript('loadPlaylist($playlistId, $index, 0)'));
      });

      test('calls loadPlaylist with startAt', () {
        final playlistId = 'test123';
        final startAt = 5;
        final controller = WebviewtubeController();
        controller.onWebviewCreated(webViewController);
        controller.onReady();

        controller.loadPlaylist(playlistId: playlistId, startAt: startAt);

        verify(webViewController
            .runJavascript('loadPlaylist($playlistId, 0, $startAt)'));
      });

      test('can call nextVideo', () {
        final playlistId = 'test123';
        final controller = WebviewtubeController();
        controller.onWebviewCreated(webViewController);
        controller.onReady();

        controller.loadPlaylist(playlistId: playlistId);
        controller.nextVideo();

        verify(webViewController.runJavascript('nextVideo()'));
      });

      test('can call previousVideo', () {
        final playlistId = 'test123';
        final controller = WebviewtubeController();
        controller.onWebviewCreated(webViewController);
        controller.onReady();

        controller.loadPlaylist(playlistId: playlistId);
        controller.previousVideo();

        verify(webViewController.runJavascript('previousVideo()'));
      });

      test('can call playVideoAt', () {
        final playlistId = 'test123';
        final controller = WebviewtubeController();
        controller.onWebviewCreated(webViewController);
        controller.onReady();

        controller.loadPlaylist(playlistId: playlistId);
        controller.playVideoAt(2);

        verify(webViewController.runJavascript('playVideoAt(2)'));
      });

      test('isPlaylist is true', () {
        final playlistId = 'test123';
        final controller = WebviewtubeController();
        controller.onWebviewCreated(webViewController);
        controller.onReady();

        controller.loadPlaylist(playlistId: playlistId);
        expect(controller.isPlaylist, true);
      });
    });

    group('cuePlaylist', () {
      test('calls cuePlaylist with a string', () {
        final playlistId = 'test123';
        final controller = WebviewtubeController();
        controller.onWebviewCreated(webViewController);
        controller.onReady();

        controller.cuePlaylist(playlistId: playlistId);

        verify(
            webViewController.runJavascript('cuePlaylist($playlistId, 0, 0)'));
      });

      test('calls cuePlaylist with an array', () {
        final videoIds = ['1', '2', '3', '4', '5'];
        final controller = WebviewtubeController();
        controller.onWebviewCreated(webViewController);
        controller.onReady();

        controller.cuePlaylist(videoIds: videoIds);

        verify(webViewController
            .runJavascript('cuePlaylist(["1", "2", "3", "4", "5"], 0, 0)'));
      });

      test('can call nextVideo', () {
        final playlistId = 'test123';
        final controller = WebviewtubeController();
        controller.onWebviewCreated(webViewController);
        controller.onReady();

        controller.cuePlaylist(playlistId: playlistId);
        controller.nextVideo();

        verify(webViewController.runJavascript('nextVideo()'));
      });

      test('can call previousVideo', () {
        final playlistId = 'test123';
        final controller = WebviewtubeController();
        controller.onWebviewCreated(webViewController);
        controller.onReady();

        controller.cuePlaylist(playlistId: playlistId);
        controller.previousVideo();

        verify(webViewController.runJavascript('previousVideo()'));
      });

      test('can call playVideoAt', () {
        final playlistId = 'test123';
        final controller = WebviewtubeController();
        controller.onWebviewCreated(webViewController);
        controller.onReady();

        controller.cuePlaylist(playlistId: playlistId);
        controller.playVideoAt(2);

        verify(webViewController.runJavascript('playVideoAt(2)'));
      });

      test('isPlaylist is true', () {
        final playlistId = 'test123';
        final controller = WebviewtubeController();
        controller.onWebviewCreated(webViewController);
        controller.onReady();

        controller.cuePlaylist(playlistId: playlistId);
        expect(controller.isPlaylist, true);
      });
    });
  });
}
