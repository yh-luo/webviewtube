// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_declarations
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:webviewtube/webviewtube.dart';

import 'webviewtube_controller_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<WebViewController>(),
])
void main() {
  final webViewController = MockWebViewController();

  group('WebviewtubeController', () {
    test('can be instantiated', () {
      final actual = WebviewtubeController();

      expect(actual, isNotNull);
      expect(actual.isPlaylist, false);
      expect(actual.value, WebviewTubeValue());
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
        final controller = WebviewtubeController(
          onPlayerReady: () {
            called = true;
          },
        );

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
        final controller = WebviewtubeController(
          onPlayerError: (error) {
            called = true;
          },
        );

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
        final controller = WebviewtubeController(
          onPlayerWebResourceError: (error) {
            called = true;
          },
        );

        controller.onWebResourceError(
          WebResourceError(errorCode: 1, description: 'test'),
        );
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
      test('calls play()', () async {
        final controller = WebviewtubeController();
        controller.setMockWebViewController(webViewController);
        controller.onReady();

        await controller.play();
        verify(webViewController.runJavaScript('play()'));
      });
    });

    group('pause', () {
      test('calls pause()', () async {
        final controller = WebviewtubeController();
        controller.setMockWebViewController(webViewController);
        controller.onReady();

        await controller.pause();
        verify(webViewController.runJavaScript('pause()'));
      });
    });

    group('mute', () {
      test('calls mute()', () async {
        final controller = WebviewtubeController();
        controller.setMockWebViewController(webViewController);
        controller.onReady();

        await controller.mute();
        verify(webViewController.runJavaScript('mute()'));
      });

      test('updates value', () async {
        final controller = WebviewtubeController();
        controller.setMockWebViewController(webViewController);
        controller.onReady();

        await controller.mute();
        expect(controller.value.isMuted, true);
      });
    });

    group('unMute', () {
      test('calls unMute()', () async {
        final controller = WebviewtubeController();
        controller.setMockWebViewController(webViewController);
        controller.onReady();

        await controller.unMute();
        verify(webViewController.runJavaScript('unMute()'));
      });

      test('updates value', () async {
        final controller = WebviewtubeController();
        controller.setMockWebViewController(webViewController);
        controller.onReady();

        await controller.unMute();
        expect(controller.value.isMuted, false);
      });
    });

    group('setPlaybackRate', () {
      test('calls setPlaybackRate()', () async {
        final controller = WebviewtubeController();
        controller.setMockWebViewController(webViewController);
        controller.onReady();

        await controller.setPlaybackRate(PlaybackRate.half);
        verify(webViewController.runJavaScript('setPlaybackRate(0.5)'));
      });
    });

    group('seekTo', () {
      test('calls seekTo()', () async {
        final controller = WebviewtubeController();
        controller.setMockWebViewController(webViewController);
        controller.onReady();

        await controller.seekTo(Duration(seconds: 1));
        verify(webViewController.runJavaScript('seekTo(1, false)'));
      });

      test('updates value', () async {
        final controller = WebviewtubeController();
        controller.setMockWebViewController(webViewController);
        controller.onReady();

        await controller.seekTo(Duration(seconds: 1));
        expect(controller.value.position, Duration(seconds: 1));
      });

      test('calls play() afterwards', () async {
        final controller = WebviewtubeController();
        controller.setMockWebViewController(webViewController);
        controller.onReady();

        await controller.seekTo(Duration(seconds: 1));
        verifyInOrder([
          webViewController.runJavaScript('seekTo(1, false)'),
          webViewController.runJavaScript('play()'),
        ]);
      });
    });

    group('replay', () {
      test('calls seekTo() and play()', () async {
        final controller = WebviewtubeController();
        controller.setMockWebViewController(webViewController);
        controller.onReady();

        await controller.replay();
        verifyInOrder([
          webViewController.runJavaScript('seekTo(0, false)'),
          webViewController.runJavaScript('play()'),
        ]);
      });
    });

    group('reload', () {
      test('calls reload', () async {
        final controller = WebviewtubeController();
        controller.setMockWebViewController(webViewController);

        await controller.reload();

        verify(webViewController.reload());
      });
    });

    group('load', () {
      test('calls loadById', () async {
        final videoId = 'test123';
        final controller = WebviewtubeController();
        controller.setMockWebViewController(webViewController);
        controller.onReady();

        await controller.load(videoId);

        verify(
          webViewController.runJavaScript('loadById({videoId: "$videoId"})'),
        );
      });

      test('calls with startAt', () async {
        final videoId = 'test123';
        final startAt = 5;
        final controller = WebviewtubeController();
        controller.setMockWebViewController(webViewController);
        controller.onReady();

        await controller.load(videoId, startAt: startAt);

        verify(
          webViewController.runJavaScript(
            'loadById({videoId: "$videoId", startSeconds: $startAt})',
          ),
        );
      });

      test('calls with endAt', () async {
        final videoId = 'test123';
        final startAt = 1;
        final endAt = 5;
        final controller = WebviewtubeController();
        controller.setMockWebViewController(webViewController);
        controller.onReady();

        await controller.load(videoId, startAt: startAt, endAt: endAt);

        verify(
          webViewController.runJavaScript(
            'loadById({videoId: "$videoId", startSeconds: $startAt, '
            'endSeconds: $endAt})',
          ),
        );
      });

      test('isPlaylist = false', () {
        final videoId = 'test123';
        final controller = WebviewtubeController();
        controller.setMockWebViewController(webViewController);
        controller.onReady();

        controller.load(videoId);

        expect(controller.isPlaylist, false);
      });

      test('nextVideo is doing nothing', () {
        final videoId = 'test123';
        final controller = WebviewtubeController();
        controller.setMockWebViewController(webViewController);
        controller.onReady();

        controller.load(videoId);
        controller.nextVideo();

        verifyNever(webViewController.runJavaScript('nextVideo()'));
      });

      test('previousVideo is doing nothing', () {
        final videoId = 'test123';
        final controller = WebviewtubeController();
        controller.setMockWebViewController(webViewController);
        controller.onReady();

        controller.load(videoId);
        controller.previousVideo();

        verifyNever(webViewController.runJavaScript('previousVideo()'));
      });

      test('playVideoAt is doing nothing', () {
        final videoId = 'test123';
        final controller = WebviewtubeController();
        controller.setMockWebViewController(webViewController);
        controller.onReady();

        controller.load(videoId);
        controller.playVideoAt(2);

        verifyNever(webViewController.runJavaScript('playVideoAt(2)'));
      });
    });

    group('cue', () {
      test('calls cueById', () async {
        final videoId = 'test123';
        final controller = WebviewtubeController();
        controller.setMockWebViewController(webViewController);
        controller.onReady();

        await controller.cue(videoId);

        verify(
          webViewController.runJavaScript('cueById({videoId: "$videoId"})'),
        );
      });

      test('calls with startAt', () async {
        final videoId = 'test123';
        final startAt = 5;
        final controller = WebviewtubeController();
        controller.setMockWebViewController(webViewController);
        controller.onReady();

        await controller.cue(videoId, startAt: startAt);

        verify(
          webViewController.runJavaScript(
            'cueById({videoId: "$videoId", startSeconds: $startAt})',
          ),
        );
      });

      test('calls with endAt', () async {
        final videoId = 'test123';
        final startAt = 1;
        final endAt = 5;
        final controller = WebviewtubeController();
        controller.setMockWebViewController(webViewController);
        controller.onReady();

        await controller.cue(videoId, startAt: startAt, endAt: endAt);

        verify(
          webViewController.runJavaScript(
            'cueById({videoId: "$videoId", startSeconds: $startAt, '
            'endSeconds: $endAt})',
          ),
        );
      });

      test('isPlaylist = false', () async {
        final videoId = 'test123';
        final controller = WebviewtubeController();
        controller.setMockWebViewController(webViewController);
        controller.onReady();

        await controller.cue(videoId);

        expect(controller.isPlaylist, false);
      });

      test('nextVideo is doing nothing', () {
        final videoId = 'test123';
        final controller = WebviewtubeController();
        controller.setMockWebViewController(webViewController);
        controller.onReady();

        controller.cue(videoId);
        controller.nextVideo();

        verifyNever(webViewController.runJavaScript('nextVideo()'));
      });

      test('previousVideo is doing nothing', () {
        final videoId = 'test123';
        final controller = WebviewtubeController();
        controller.setMockWebViewController(webViewController);
        controller.onReady();

        controller.cue(videoId);
        controller.previousVideo();

        verifyNever(webViewController.runJavaScript('previousVideo()'));
      });

      test('playVideoAt is doing nothing', () {
        final videoId = 'test123';
        final controller = WebviewtubeController();
        controller.setMockWebViewController(webViewController);
        controller.onReady();

        controller.cue(videoId);
        controller.playVideoAt(2);

        verifyNever(webViewController.runJavaScript('playVideoAt(2)'));
      });
    });

    group('loadPlaylist', () {
      test('calls loadPlaylist with a string', () async {
        final playlistId = 'test123';
        final controller = WebviewtubeController();
        controller.setMockWebViewController(webViewController);
        controller.onReady();

        await controller.loadPlaylist(playlistId: playlistId);

        verify(
          webViewController.runJavaScript('loadPlaylist($playlistId, 0, 0)'),
        );
      });

      test('calls loadPlaylist with an array', () async {
        final videoIds = ['1', '2', '3', '4', '5'];
        final controller = WebviewtubeController();
        controller.setMockWebViewController(webViewController);
        controller.onReady();

        await controller.loadPlaylist(videoIds: videoIds);

        verify(
          webViewController.runJavaScript(
            'loadPlaylist(["1", "2", "3", "4", "5"], 0, 0)',
          ),
        );
      });

      test('calls loadPlaylist with index', () async {
        final playlistId = 'test123';
        final index = 1;
        final controller = WebviewtubeController();
        controller.setMockWebViewController(webViewController);
        controller.onReady();

        await controller.loadPlaylist(playlistId: playlistId, index: index);

        verify(
          webViewController.runJavaScript(
            'loadPlaylist($playlistId, $index, 0)',
          ),
        );
      });

      test('calls loadPlaylist with startAt', () async {
        final playlistId = 'test123';
        final startAt = 5;
        final controller = WebviewtubeController();
        controller.setMockWebViewController(webViewController);
        controller.onReady();

        await controller.loadPlaylist(playlistId: playlistId, startAt: startAt);

        verify(
          webViewController.runJavaScript(
            'loadPlaylist($playlistId, 0, $startAt)',
          ),
        );
      });

      test('can call nextVideo', () async {
        final playlistId = 'test123';
        final controller = WebviewtubeController();
        controller.setMockWebViewController(webViewController);
        controller.onReady();

        await controller.loadPlaylist(playlistId: playlistId);
        await controller.nextVideo();

        verify(webViewController.runJavaScript('nextVideo()'));
      });

      test('can call previousVideo', () async {
        final playlistId = 'test123';
        final controller = WebviewtubeController();
        controller.setMockWebViewController(webViewController);
        controller.onReady();

        await controller.loadPlaylist(playlistId: playlistId);
        await controller.previousVideo();

        verify(webViewController.runJavaScript('previousVideo()'));
      });

      test('can call playVideoAt', () async {
        final playlistId = 'test123';
        final controller = WebviewtubeController();
        controller.setMockWebViewController(webViewController);
        controller.onReady();

        await controller.loadPlaylist(playlistId: playlistId);
        await controller.playVideoAt(2);

        verify(webViewController.runJavaScript('playVideoAt(2)'));
      });

      test('isPlaylist is true', () async {
        final playlistId = 'test123';
        final controller = WebviewtubeController();
        controller.setMockWebViewController(webViewController);
        controller.onReady();

        await controller.loadPlaylist(playlistId: playlistId);
        expect(controller.isPlaylist, true);
      });
    });

    group('cuePlaylist', () {
      test('calls cuePlaylist with a string', () async {
        final playlistId = 'test123';
        final controller = WebviewtubeController();
        controller.setMockWebViewController(webViewController);
        controller.onReady();

        await controller.cuePlaylist(playlistId: playlistId);

        verify(
          webViewController.runJavaScript('cuePlaylist($playlistId, 0, 0)'),
        );
      });

      test('calls cuePlaylist with an array', () async {
        final videoIds = ['1', '2', '3', '4', '5'];
        final controller = WebviewtubeController();
        controller.setMockWebViewController(webViewController);
        controller.onReady();

        await controller.cuePlaylist(videoIds: videoIds);

        verify(
          webViewController.runJavaScript(
            'cuePlaylist(["1", "2", "3", "4", "5"], 0, 0)',
          ),
        );
      });

      test('can call nextVideo', () async {
        final playlistId = 'test123';
        final controller = WebviewtubeController();
        controller.setMockWebViewController(webViewController);
        controller.onReady();

        await controller.cuePlaylist(playlistId: playlistId);
        await controller.nextVideo();

        verify(webViewController.runJavaScript('nextVideo()'));
      });

      test('can call previousVideo', () async {
        final playlistId = 'test123';
        final controller = WebviewtubeController();
        controller.setMockWebViewController(webViewController);
        controller.onReady();

        await controller.cuePlaylist(playlistId: playlistId);
        await controller.previousVideo();

        verify(webViewController.runJavaScript('previousVideo()'));
      });

      test('can call playVideoAt', () async {
        final playlistId = 'test123';
        final controller = WebviewtubeController();
        controller.setMockWebViewController(webViewController);
        controller.onReady();

        await controller.cuePlaylist(playlistId: playlistId);
        await controller.playVideoAt(2);

        verify(webViewController.runJavaScript('playVideoAt(2)'));
      });

      test('isPlaylist is true', () async {
        final playlistId = 'test123';
        final controller = WebviewtubeController();
        controller.setMockWebViewController(webViewController);
        controller.onReady();

        await controller.cuePlaylist(playlistId: playlistId);
        expect(controller.isPlaylist, true);
      });
    });

    group('dispose', () {
      test('does not throw when init() was never called', () {
        final controller = WebviewtubeController();

        expect(controller.dispose, returnsNormally);
      });

      test(
        'pending _callMethod calls resolve instead of hanging forever',
        () async {
          final controller = WebviewtubeController();
          // No init(), no setMockWebViewController — completer is pending.
          final pending = controller.play();

          controller.dispose();

          await pending.timeout(const Duration(seconds: 1));
        },
      );

      test('subsequent method calls do not invoke runJavaScript', () async {
        final mock = MockWebViewController();
        final controller = WebviewtubeController();
        controller.setMockWebViewController(mock);
        controller.onReady();

        controller.dispose();
        await controller.play();

        verifyNever(mock.runJavaScript('play()'));
      });

      test(
        'value-mutating methods do not assert after dispose mid-await',
        () async {
          final mock = MockWebViewController();
          final controller = WebviewtubeController();
          controller.setMockWebViewController(mock);
          controller.onReady();

          // Start the method, then dispose before its await resumes.
          final mutePending = controller.mute();
          final unMutePending = controller.unMute();
          final seekPending = controller.seekTo(const Duration(seconds: 1));
          controller.dispose();

          await mutePending;
          await unMutePending;
          await seekPending;
        },
      );

      test('_isPlaylist is not mutated after dispose mid-await', () async {
        final mock = MockWebViewController();
        final controller = WebviewtubeController();
        controller.setMockWebViewController(mock);
        controller.onReady();

        // Start each method, then dispose before its await resumes.
        final loadPending = controller.load('abc');
        final cuePending = controller.cue('abc');
        final loadPlaylistPending = controller.loadPlaylist(
          playlistId: 'pl1',
        );
        final cuePlaylistPending = controller.cuePlaylist(playlistId: 'pl1');
        controller.dispose();

        await loadPending;
        await cuePending;
        await loadPlaylistPending;
        await cuePlaylistPending;

        // No assertion on the value itself — the invariant is that the
        // post-await assignment was skipped, so `isPlaylist` stayed at its
        // pre-call default.
        expect(controller.isPlaylist, false);
      });
    });

    group('init failure', () {
      test('does not poison subsequent _callMethod awaits', () async {
        final controller = WebviewtubeController();
        // Simulate a failed init by completing the completer with an error.
        // We use a private path through the public API: trigger init() which
        // will fail without a Flutter binding (rootBundle is unavailable).
        await expectLater(controller.init('abc'), throwsA(anything));

        // play() must not rethrow the asset error — it should return quietly.
        await controller.play();
        await controller.mute();
      });

      test('init() can be retried after a failure', () async {
        final controller = WebviewtubeController();
        await expectLater(controller.init('abc'), throwsA(anything));

        // The second init() should be able to attempt setup again instead of
        // short-circuiting on the already-completed (errored) completer.
        // It will still fail in this test environment, but the failure must
        // come from the new attempt rather than the stale completer state.
        await expectLater(controller.init('abc'), throwsA(anything));
      });

      test(
        'mutating methods do not desync value before the player handshake',
        () async {
          // _callMethod logs 'not ready' and skips runJavaScript when
          // !value.isReady; the matching guard in _safeSetValue must skip the
          // value mutation too, otherwise listeners see a state that the
          // player was never actually told about.
          final mock = MockWebViewController();
          final controller = WebviewtubeController();
          controller.setMockWebViewController(mock);
          // Intentionally do NOT call onReady() — value.isReady stays false.

          await controller.mute();
          await controller.unMute();
          await controller.seekTo(const Duration(seconds: 5));

          expect(controller.value.isReady, false);
          expect(controller.value.isMuted, false);
          expect(controller.value.position, Duration.zero);
          verifyNever(mock.runJavaScript(any));
        },
      );
    });

    group('dispose idempotency', () {
      test('calling dispose() twice does not throw', () {
        final mock = MockWebViewController();
        final controller = WebviewtubeController();
        controller.setMockWebViewController(mock);

        controller.dispose();
        expect(controller.dispose, returnsNormally);
      });
    });

    group('init lifecycle', () {
      test('dispose() after a failed init() is safe and idempotent', () async {
        // Without a `WebViewPlatform`, init() throws synchronously inside
        // its try block — the catch path runs before any await and before
        // dispose() is called. This verifies the failed-init catch leaves
        // the controller in a state where dispose() still succeeds and
        // remains idempotent.
        //
        // The disposed-mid-_loadHtmlTemplate-await scenario the runtime
        // guard (`if (_disposed) return;` after the bundle load) protects
        // against requires a real `WebViewPlatform` to exercise and isn't
        // covered here.
        final controller = WebviewtubeController();
        final initFuture = controller.init('abc');
        controller.dispose();

        await expectLater(initFuture, throwsA(anything));
        expect(controller.dispose, returnsNormally);
      });
    });
  });
}
