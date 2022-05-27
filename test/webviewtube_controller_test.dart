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

      test('calls mute if options.mute=true', () {
        final controller =
            WebviewtubeController(options: WebviewtubeOptions(mute: true));
        controller.onWebviewCreated(webViewController);

        controller.onReady();
        verify(webViewController.runJavascript('mute()'));
      });
    });

    group('onError', () {
      test('updates value', () {
        final controller = WebviewtubeController();

        controller.onError(100);
        expect(controller.value.playerError, PlayerError.videoNotFound);
      });
    });

    group('onWebResourceError', () {
      test('updates value', () {
        final controller = WebviewtubeController();
        final error = WebResourceError(errorCode: 1, description: 'test');

        controller.onWebResourceError(error);
        expect(controller.value.playerError, PlayerError.unknown);
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

      test('updates value', () {
        final controller = WebviewtubeController();
        controller.onWebviewCreated(webViewController);
        controller.onReady();

        controller.setPlaybackRate(PlaybackRate.half);
        expect(controller.value.playbackRate, PlaybackRate.half);
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
        var videoId = 'test123';
        final controller = WebviewtubeController();
        controller.onWebviewCreated(webViewController);
        controller.onReady();

        controller.load(videoId);

        verify(
            webViewController.runJavascript('loadById({videoId: "$videoId"})'));
      });

      test('calls with startAt', () {
        var videoId = 'test123';
        var startAt = 5;
        final controller = WebviewtubeController();
        controller.onWebviewCreated(webViewController);
        controller.onReady();

        controller.load(videoId, startAt: startAt);

        verify(webViewController.runJavascript(
            'loadById({videoId: "$videoId", startSeconds: $startAt})'));
      });

      test('calls with endAt', () {
        var videoId = 'test123';
        var startAt = 1;
        var endAt = 5;
        final controller = WebviewtubeController();
        controller.onWebviewCreated(webViewController);
        controller.onReady();

        controller.load(videoId, startAt: startAt, endAt: endAt);

        verify(webViewController.runJavascript(
            'loadById({videoId: "$videoId", startSeconds: $startAt, '
            'endSeconds: $endAt})'));
      });
    });

    group('cue', () {
      test('calls cueById', () {
        var videoId = 'test123';
        final controller = WebviewtubeController();
        controller.onWebviewCreated(webViewController);
        controller.onReady();

        controller.cue(videoId);

        verify(
            webViewController.runJavascript('cueById({videoId: "$videoId"})'));
      });

      test('calls with startAt', () {
        var videoId = 'test123';
        var startAt = 5;
        final controller = WebviewtubeController();
        controller.onWebviewCreated(webViewController);
        controller.onReady();

        controller.cue(videoId, startAt: startAt);

        verify(webViewController.runJavascript(
            'cueById({videoId: "$videoId", startSeconds: $startAt})'));
      });

      test('calls with endAt', () {
        var videoId = 'test123';
        var startAt = 1;
        var endAt = 5;
        final controller = WebviewtubeController();
        controller.onWebviewCreated(webViewController);
        controller.onReady();

        controller.cue(videoId, startAt: startAt, endAt: endAt);

        verify(webViewController.runJavascript(
            'cueById({videoId: "$videoId", startSeconds: $startAt, '
            'endSeconds: $endAt})'));
      });
    });
  });
}
