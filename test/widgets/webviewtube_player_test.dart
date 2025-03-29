// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_declarations
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';
import 'package:webviewtube/src/widgets/widgets.dart';
import 'package:webviewtube/webviewtube.dart';

import 'webviewtube_player_test.mocks.dart';

const String videoId = '4AoFA19gbLo';

class TestApp extends StatelessWidget {
  const TestApp({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Webviewtube',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: child,
      ),
    );
  }
}

@GenerateNiceMocks([
  MockSpec<WebviewtubeController>(),
  MockSpec<WebviewtubeOptions>(),
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('WebviewtubePlayer', () {
    late MockWebviewtubeController controller;
    final value = WebviewTubeValue(isReady: true);

    setUp(() {
      WebViewPlatform.instance = FakeWebViewPlatform();
      controller = MockWebviewtubeController();
      when(controller.value).thenReturn(value);
    });

    testWidgets('initiate widgets properly', (WidgetTester tester) async {
      provideMockedNetworkImages(() async {
        await tester.pumpWidget(TestApp(
          child: WebviewtubePlayer(
            videoId: videoId,
            controller: controller,
          ),
        ));

        verify(controller.onPlayerNavigationRequest).called(1);
        expect(find.byType(WebviewtubePlayer), findsOneWidget);
        expect(find.byType(DurationIndicator), findsNothing);
        // expect(find.byType(WebViewWidget), findsOneWidget);
      });
    });

    testWidgets('initiate the player with configuration',
        (WidgetTester tester) async {
      final options = MockWebviewtubeOptions();
      final value =
          WebviewTubeValue(isReady: true, playerState: PlayerState.paused);
      when(options.showControls).thenReturn(false);
      when(options.mute).thenReturn(true);
      when(options.loop).thenReturn(true);
      when(options.forceHd).thenReturn(true);
      when(options.interfaceLanguage).thenReturn('zh_tw');
      when(options.enableCaption).thenReturn(false);
      when(options.captionLanguage).thenReturn('zh_tw');
      when(options.startAt).thenReturn(1);
      when(options.endAt).thenReturn(5);
      when(options.currentTimeUpdateInterval).thenReturn(200);
      when(options.aspectRatio).thenReturn(16 / 9);
      when(controller.value).thenReturn(value);
      when(controller.onWebviewCreated(any)).thenAnswer((_) {});

      provideMockedNetworkImages(() async {
        await tester.pumpWidget(TestApp(
          child: WebviewtubePlayer(
            videoId: videoId,
            options: options,
            controller: controller,
          ),
        ));

        verify(controller.onWebviewCreated(any));
        verify(options.showControls);
        verify(options.loop);
        verify(options.forceHd);
        verify(options.interfaceLanguage);
        verify(options.enableCaption);
        verify(options.captionLanguage);
        verify(options.startAt);
        verify(options.endAt);
        verify(options.currentTimeUpdateInterval);
        verify(options.aspectRatio);
      });
    });

    // testWidgets('initiate javascriptChannels properly',
    //     (WidgetTester tester) async {
    //   provideMockedNetworkImages(() async {
    //     await tester.pumpWidget(TestApp(
    //       child: WebviewtubePlayer(
    //         videoId: videoId,
    //         controller: controller,
    //       ),
    //     ));

    //     final JavaScriptChannelParams params = verify(
    //             mockPlatformWebViewController.addJavaScriptChannel(captureAny))
    //         .captured[0] as JavaScriptChannelParams;
    //     expect(params.name, 'Webviewtube');
    //   });
    // });

    // group('handle JavaScript channel messages properly', () {
    //   testWidgets('Ready', (WidgetTester tester) async {
    //     final options = WebviewtubeOptions(mute: true);
    //     final controller = MockWebviewtubeController();

    //     when(controller.onWebviewCreated(any)).thenAnswer((_) {});
    //     when(controller.onReady()).thenAnswer((_) {});
    //     when(controller.mute()).thenAnswer((_) {});

    //     provideMockedNetworkImages(() async {
    //       await tester.pumpWidget(TestApp(
    //         child: WebviewtubePlayer(
    //           videoId: videoId,
    //           options: options,
    //           controller: controller,
    //         ),
    //       ));

    //       verify(controller.onReady()).called(1);
    //       verify(controller.mute()).called(1);
    //       verify(mockPlatformWebViewController.runJavaScript('mute()'))
    //           .called(1);
    //     });
    //   });

    //   testWidgets('StateChange', (WidgetTester tester) async {
    //     final controller = MockWebviewtubeController();
    //     when(controller.onWebviewCreated(any)).thenAnswer((_) {});
    //     when(controller.onPlayerStateChange(any)).thenAnswer((_) {});

    //     provideMockedNetworkImages(() async {
    //       await tester.pumpWidget(TestApp(
    //         child: WebviewtubePlayer(
    //           videoId: videoId,
    //           controller: controller,
    //         ),
    //       ));

    //       verify(controller.onPlayerStateChange(any));
    //     });
    //   });

    //   testWidgets('PlaybackQualityChange', (WidgetTester tester) async {
    //     final controller = MockWebviewtubeController();
    //     when(controller.onWebviewCreated(any)).thenAnswer((_) {});
    //     when(controller.onPlaybackQualityChange(any)).thenAnswer((_) {});

    //     provideMockedNetworkImages(() async {
    //       await tester.pumpWidget(TestApp(
    //         child: WebviewtubePlayer(
    //           videoId: videoId,
    //           controller: controller,
    //         ),
    //       ));

    //       final JavascriptChannelRegistry channelRegistry = captureBuildArgs(
    //         mockWebViewPlatform,
    //         javascriptChannelRegistry: true,
    //       ).single as JavascriptChannelRegistry;
    //       final message = jsonEncode({
    //         'method': 'PlaybackQualityChange',
    //         'args': {'playbackQuality': 'small'}
    //       });
    //       channelRegistry.onJavascriptChannelMessage('Webviewtube', message);

    //       verify(controller.onPlaybackQualityChange(any));
    //     });
    //   });

    //   testWidgets('PlaybackQualityChange', (WidgetTester tester) async {
    //     final controller = MockWebviewtubeController();
    //     when(controller.onWebviewCreated(any)).thenAnswer((_) {});
    //     when(controller.onPlaybackQualityChange(any)).thenAnswer((_) {});

    //     provideMockedNetworkImages(() async {
    //       await tester.pumpWidget(TestApp(
    //         child: WebviewtubePlayer(
    //           videoId: videoId,
    //           controller: controller,
    //         ),
    //       ));

    //       final JavascriptChannelRegistry channelRegistry = captureBuildArgs(
    //         mockWebViewPlatform,
    //         javascriptChannelRegistry: true,
    //       ).single as JavascriptChannelRegistry;
    //       final message = jsonEncode({
    //         'method': 'PlaybackQualityChange',
    //         'args': {'playbackQuality': 'small'}
    //       });
    //       channelRegistry.onJavascriptChannelMessage('Webviewtube', message);

    //       verify(controller.onPlaybackQualityChange(any));
    //     });
    //   });

    //   testWidgets('PlaybackRateChange', (WidgetTester tester) async {
    //     final controller = MockWebviewtubeController();
    //     when(controller.onWebviewCreated(any)).thenAnswer((_) {});
    //     when(controller.onPlaybackRateChange(any)).thenAnswer((_) {});

    //     provideMockedNetworkImages(() async {
    //       await tester.pumpWidget(TestApp(
    //         child: WebviewtubePlayer(
    //           videoId: videoId,
    //           controller: controller,
    //         ),
    //       ));

    //       final JavascriptChannelRegistry channelRegistry = captureBuildArgs(
    //         mockWebViewPlatform,
    //         javascriptChannelRegistry: true,
    //       ).single as JavascriptChannelRegistry;
    //       final message = jsonEncode({
    //         'method': 'PlaybackRateChange',
    //         'args': {'playbackRate': 0.75}
    //       });
    //       channelRegistry.onJavascriptChannelMessage('Webviewtube', message);

    //       verify(controller.onPlaybackRateChange(any));
    //     });
    //   });

    //   testWidgets('Errors', (WidgetTester tester) async {
    //     final controller = MockWebviewtubeController();

    //     when(controller.onWebviewCreated(any)).thenAnswer((_) {});
    //     when(controller.onError(any)).thenAnswer((_) {});

    //     provideMockedNetworkImages(() async {
    //       await tester.pumpWidget(TestApp(
    //         child: WebviewtubePlayer(
    //           videoId: videoId,
    //           controller: controller,
    //         ),
    //       ));

    //       final JavascriptChannelRegistry channelRegistry = captureBuildArgs(
    //         mockWebViewPlatform,
    //         javascriptChannelRegistry: true,
    //       ).single as JavascriptChannelRegistry;
    //       final message = jsonEncode({
    //         'method': 'Errors',
    //         'args': {'errorCode': 100}
    //       });
    //       channelRegistry.onJavascriptChannelMessage('Webviewtube', message);

    //       verify(controller.onError(any));
    //     });
    //   });

    //   testWidgets('VideoData', (WidgetTester tester) async {
    //     final controller = MockWebviewtubeController();

    //     when(controller.onWebviewCreated(any)).thenAnswer((_) {});
    //     when(controller.onVideoDataChange(any)).thenAnswer((_) {});

    //     provideMockedNetworkImages(() async {
    //       await tester.pumpWidget(TestApp(
    //         child: WebviewtubePlayer(
    //           videoId: videoId,
    //           controller: controller,
    //         ),
    //       ));

    //       final JavascriptChannelRegistry channelRegistry = captureBuildArgs(
    //         mockWebViewPlatform,
    //         javascriptChannelRegistry: true,
    //       ).single as JavascriptChannelRegistry;
    //       final message = jsonEncode({
    //         'method': 'VideoData',
    //         'args': {
    //           'duration': 10.0,
    //           'title': 'test',
    //           'author': 'test',
    //           'videoId': 'test123'
    //         }
    //       });
    //       channelRegistry.onJavascriptChannelMessage('Webviewtube', message);

    //       verify(controller.onVideoDataChange(any));
    //     });
    //   });

    //   testWidgets('CurrentTime', (WidgetTester tester) async {
    //     final controller = MockWebviewtubeController();

    //     when(controller.onWebviewCreated(any)).thenAnswer((_) {});
    //     when(controller.onCurrentTimeChange(any)).thenAnswer((_) {});

    //     provideMockedNetworkImages(() async {
    //       await tester.pumpWidget(TestApp(
    //         child: WebviewtubePlayer(
    //           videoId: videoId,
    //           controller: controller,
    //         ),
    //       ));

    //       final JavascriptChannelRegistry channelRegistry = captureBuildArgs(
    //         mockWebViewPlatform,
    //         javascriptChannelRegistry: true,
    //       ).single as JavascriptChannelRegistry;
    //       final message = jsonEncode({
    //         'method': 'CurrentTime',
    //         'args': {'position': 0.0, 'buffered': 0.1}
    //       });
    //       channelRegistry.onJavascriptChannelMessage('Webviewtube', message);

    //       verify(controller.onCurrentTimeChange(any));
    //     });
    //   });
    // });
  });

  group('WebviewtubeVideoPlayer', () {
    setUp(() {
      WebViewPlatform.instance = FakeWebViewPlatform();
    });

    testWidgets('initiate widgets properly', (WidgetTester tester) async {
      final controller = MockWebviewtubeController();
      when(controller.value).thenReturn(WebviewTubeValue());
      provideMockedNetworkImages(() async {
        await tester.pumpWidget(TestApp(
          child: WebviewtubeVideoPlayer(
            videoId: videoId,
            controller: controller,
          ),
        ));

        expect(find.byType(LoadingIndicator), findsOneWidget);
        expect(find.byType(WebviewtubeVideoPlayer), findsOneWidget);
        expect(find.byType(DurationIndicator), findsOneWidget);
        expect(find.byType(VolumeButton), findsOneWidget);
        expect(find.byType(PlaybackSpeedButton), findsOneWidget);
        expect(find.byType(ProgressBar), findsOneWidget);
        expect(find.byType(WebViewWidget), findsOneWidget);
      });
    });

    testWidgets('initiate the player with configuration',
        (WidgetTester tester) async {
      final options = MockWebviewtubeOptions();
      final controller = MockWebviewtubeController();
      final value =
          WebviewTubeValue(isReady: true, playerState: PlayerState.paused);
      when(options.copyWith(showControls: false)).thenReturn(options);
      when(options.showControls).thenReturn(false);
      when(options.mute).thenReturn(true);
      when(options.loop).thenReturn(true);
      when(options.forceHd).thenReturn(true);
      when(options.interfaceLanguage).thenReturn('zh_tw');
      when(options.enableCaption).thenReturn(false);
      when(options.captionLanguage).thenReturn('zh_tw');
      when(options.startAt).thenReturn(1);
      when(options.endAt).thenReturn(5);
      when(options.currentTimeUpdateInterval).thenReturn(200);
      when(options.aspectRatio).thenReturn(16 / 9);
      when(controller.value).thenReturn(value);
      when(controller.onWebviewCreated(any)).thenAnswer((_) {});

      provideMockedNetworkImages(() async {
        await tester.pumpWidget(TestApp(
          child: WebviewtubeVideoPlayer(
            videoId: videoId,
            options: options,
            controller: controller,
          ),
        ));

        verify(controller.onWebviewCreated(any));
        verify(options.showControls);
        verify(options.loop);
        verify(options.forceHd);
        verify(options.interfaceLanguage);
        verify(options.enableCaption);
        verify(options.captionLanguage);
        verify(options.startAt);
        verify(options.endAt);
        verify(options.currentTimeUpdateInterval);
        verify(options.aspectRatio);
      });
    });

    group('VolumeButton', () {
      testWidgets('tap to mute', (WidgetTester tester) async {
        final controller = MockWebviewtubeController();
        final value =
            WebviewTubeValue(isReady: true, playerState: PlayerState.paused);

        when(controller.value).thenReturn(value);

        provideMockedNetworkImages(() async {
          await tester.pumpWidget(TestApp(
            child: WebviewtubeVideoPlayer(
              videoId: videoId,
              controller: controller,
            ),
          ));

          expect(find.byIcon(Icons.volume_off), findsOneWidget);
          final volumeButton = find.byType(VolumeButton);

          await tester.tap(volumeButton);
          await tester.pumpAndSettle();

          verify(controller.mute());
        });
      });

      testWidgets('tap to unMute', (WidgetTester tester) async {
        final controller = MockWebviewtubeController();
        final value = WebviewTubeValue(
            isReady: true, isMuted: true, playerState: PlayerState.paused);

        when(controller.value).thenReturn(value);

        provideMockedNetworkImages(() async {
          await tester.pumpWidget(TestApp(
            child: WebviewtubeVideoPlayer(
              videoId: videoId,
              controller: controller,
            ),
          ));
          expect(find.byIcon(Icons.volume_up), findsOneWidget);
          final volumeButton = find.byType(VolumeButton);

          await tester.tap(volumeButton);
          await tester.pumpAndSettle();

          verify(controller.unMute());
        });
      });
    });

    group('PlaybackSpeedButton', () {
      testWidgets('tap to change the playback speed',
          (WidgetTester tester) async {
        final controller = MockWebviewtubeController();
        final value =
            WebviewTubeValue(isReady: true, playerState: PlayerState.paused);

        when(controller.value).thenReturn(value);

        provideMockedNetworkImages(() async {
          await tester.pumpWidget(TestApp(
            child: WebviewtubeVideoPlayer(
              videoId: videoId,
              controller: controller,
            ),
          ));

          final playbackSpeedButton = find.byType(PlaybackSpeedButton);

          await tester.tap(playbackSpeedButton);
          await tester.pumpAndSettle();
          await tester.tap(find.text('0.75').last);
          await tester.pumpAndSettle();

          verify(controller.setPlaybackRate(PlaybackRate.threeQuarter));
        });
      });
    });

    group('replay button', () {
      testWidgets('shows it when the video is finished',
          (WidgetTester tester) async {
        final controller = MockWebviewtubeController();
        final value =
            WebviewTubeValue(isReady: true, playerState: PlayerState.ended);

        when(controller.value).thenReturn(value);

        provideMockedNetworkImages(() async {
          await tester.pumpWidget(TestApp(
            child: WebviewtubeVideoPlayer(
              videoId: videoId,
              controller: controller,
            ),
          ));

          final replayButton = find.byIcon(Icons.replay);
          expect(replayButton, findsOneWidget);
        });
      });

      testWidgets('tap it to replay', (WidgetTester tester) async {
        final controller = MockWebviewtubeController();
        final value =
            WebviewTubeValue(isReady: true, playerState: PlayerState.ended);

        when(controller.value).thenReturn(value);

        provideMockedNetworkImages(() async {
          await tester.pumpWidget(TestApp(
            child: WebviewtubeVideoPlayer(
              videoId: videoId,
              controller: controller,
            ),
          ));

          final replayButton = find.byIcon(Icons.replay);
          await tester.tap(replayButton);
          await tester.pumpAndSettle();

          verify(controller.replay());
        });
      });
    });

    group('ProgressBar', () {
      testWidgets('onHorizontalDragDown', (WidgetTester tester) async {
        final controller = MockWebviewtubeController();
        final value =
            WebviewTubeValue(isReady: true, playerState: PlayerState.paused);

        when(controller.value).thenReturn(value);
        when(controller.seekTo(any, allowSeekAhead: true)).thenAnswer((_) {});

        provideMockedNetworkImages(() async {
          await tester.pumpWidget(TestApp(
            child: WebviewtubeVideoPlayer(
              videoId: videoId,
              controller: controller,
            ),
          ));

          final progressBar = find.byType(ProgressBar);
          await tester.drag(progressBar, Offset(30.0, 0.0));

          verify(controller.seekTo(any, allowSeekAhead: true));
        });
      });
    });
  });
}

// Source: https://github.com/roughike/image_test_utils/blob/master/lib/image_test_utils.dart
R provideMockedNetworkImages<R>(R Function() body,
    {List<int> imageBytes = kTransparentImage}) {
  return HttpOverrides.runZoned(
    body,
    createHttpClient: (_) => createMockImageHttpClient(_),
  );
}

// Source: https://github.com/flutter/flutter/blob/master/dev/manual_tests/test/mock_image_http.dart
// Returns a mock HTTP client that responds with an image to all requests.
FakeHttpClient createMockImageHttpClient(SecurityContext? _) {
  final FakeHttpClient client = FakeHttpClient();
  return client;
}

class FakeHttpClient extends Fake implements HttpClient {
  FakeHttpClient([this.context]);

  SecurityContext? context;

  @override
  bool autoUncompress = false;

  final FakeHttpClientRequest request = FakeHttpClientRequest();

  @override
  Future<HttpClientRequest> getUrl(Uri url) async {
    return request;
  }
}

class FakeHttpClientRequest extends Fake implements HttpClientRequest {
  final FakeHttpClientResponse response = FakeHttpClientResponse();

  @override
  Future<HttpClientResponse> close() async {
    return response;
  }
}

class FakeHttpClientResponse extends Fake implements HttpClientResponse {
  @override
  int get statusCode => 200;

  @override
  int get contentLength => kTransparentImage.length;

  @override
  final FakeHttpHeaders headers = FakeHttpHeaders();

  @override
  HttpClientResponseCompressionState get compressionState =>
      HttpClientResponseCompressionState.notCompressed;

  @override
  StreamSubscription<List<int>> listen(
    void Function(List<int>)? onData, {
    void Function()? onDone,
    Function? onError,
    bool? cancelOnError,
  }) {
    return Stream<List<int>>.fromIterable(<List<int>>[kTransparentImage])
        .listen(onData,
            onDone: onDone, onError: onError, cancelOnError: cancelOnError);
  }
}

class FakeHttpHeaders extends Fake implements HttpHeaders {}

const List<int> kTransparentImage = <int>[
  0x89,
  0x50,
  0x4E,
  0x47,
  0x0D,
  0x0A,
  0x1A,
  0x0A,
  0x00,
  0x00,
  0x00,
  0x0D,
  0x49,
  0x48,
  0x44,
  0x52,
  0x00,
  0x00,
  0x00,
  0x01,
  0x00,
  0x00,
  0x00,
  0x01,
  0x08,
  0x06,
  0x00,
  0x00,
  0x00,
  0x1F,
  0x15,
  0xC4,
  0x89,
  0x00,
  0x00,
  0x00,
  0x0A,
  0x49,
  0x44,
  0x41,
  0x54,
  0x78,
  0x9C,
  0x63,
  0x00,
  0x01,
  0x00,
  0x00,
  0x05,
  0x00,
  0x01,
  0x0D,
  0x0A,
  0x2D,
  0xB4,
  0x00,
  0x00,
  0x00,
  0x00,
  0x49,
  0x45,
  0x4E,
  0x44,
  0xAE,
];

class FakeWebViewPlatform extends WebViewPlatform {
  @override
  PlatformWebViewController createPlatformWebViewController(
    PlatformWebViewControllerCreationParams params,
  ) {
    return FakeWebViewController(params);
  }

  @override
  PlatformWebViewWidget createPlatformWebViewWidget(
    PlatformWebViewWidgetCreationParams params,
  ) {
    return FakeWebViewWidget(params);
  }

  @override
  PlatformWebViewCookieManager createPlatformCookieManager(
    PlatformWebViewCookieManagerCreationParams params,
  ) {
    return FakeCookieManager(params);
  }

  @override
  PlatformNavigationDelegate createPlatformNavigationDelegate(
    PlatformNavigationDelegateCreationParams params,
  ) {
    return FakeNavigationDelegate(params);
  }
}

class FakeWebViewController extends PlatformWebViewController {
  FakeWebViewController(super.params) : super.implementation();

  @override
  Future<void> setJavaScriptMode(JavaScriptMode javaScriptMode) async {}

  @override
  Future<void> setBackgroundColor(Color color) async {}

  @override
  Future<void> setPlatformNavigationDelegate(
    PlatformNavigationDelegate handler,
  ) async {}

  @override
  Future<void> addJavaScriptChannel(
      JavaScriptChannelParams javaScriptChannelParams) async {}

  @override
  Future<void> removeJavaScriptChannel(String javaScriptChannelName) async {}

  @override
  Future<void> loadRequest(LoadRequestParams params) async {}

  @override
  Future<void> setUserAgent(String? userAgent) async {}

  @override
  Future<void> loadHtmlString(String html, {String? baseUrl}) async {}
}

class FakeCookieManager extends PlatformWebViewCookieManager {
  FakeCookieManager(super.params) : super.implementation();
}

class FakeWebViewWidget extends PlatformWebViewWidget {
  FakeWebViewWidget(super.params) : super.implementation();

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class FakeNavigationDelegate extends PlatformNavigationDelegate {
  FakeNavigationDelegate(super.params) : super.implementation();

  @override
  Future<void> setOnNavigationRequest(
    NavigationRequestCallback onNavigationRequest,
  ) async {}

  @override
  Future<void> setOnPageFinished(PageEventCallback onPageFinished) async {}

  @override
  Future<void> setOnPageStarted(PageEventCallback onPageStarted) async {}

  @override
  Future<void> setOnProgress(ProgressCallback onProgress) async {}

  @override
  Future<void> setOnWebResourceError(
    WebResourceErrorCallback onWebResourceError,
  ) async {}
}
