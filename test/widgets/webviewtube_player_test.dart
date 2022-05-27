// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_declarations
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:webview_flutter/webview_flutter.dart';
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

@GenerateMocks([WebviewtubeController])
void main() {
  testWidgets('WebviewtubePlayer', (WidgetTester tester) async {
    provideMockedNetworkImages(() async {
      await tester.pumpWidget(TestApp(
        child: WebviewtubePlayer(videoId),
      ));

      expect(find.byType(WebviewtubePlayer), findsOneWidget);
      expect(find.byType(WebviewtubePlayerView), findsOneWidget);
      expect(find.byType(DurationIndicator), findsNothing);
      expect(find.byType(WebView), findsOneWidget);
    });
  });

  testWidgets('WebviewtubeVideoPlayer', (WidgetTester tester) async {
    provideMockedNetworkImages(() async {
      await tester.pumpWidget(TestApp(
        child: WebviewtubeVideoPlayer(videoId),
      ));

      expect(find.byType(WebviewtubeVideoPlayer), findsOneWidget);
      expect(find.byType(WebviewtubeVideoPlayerView), findsOneWidget);
      expect(find.byType(DurationIndicator), findsOneWidget);
      expect(find.byType(VolumeButton), findsOneWidget);
      expect(find.byType(PlaybackSpeedButton), findsOneWidget);
      expect(find.byType(ProgressBar), findsOneWidget);
      expect(find.byType(WebView), findsOneWidget);
    });
  });

  testWidgets('VolumeButton: mute', (WidgetTester tester) async {
    provideMockedNetworkImages(() async {
      final options = WebviewtubeOptions();
      final controller = MockWebviewtubeController();
      final value =
          WebviewTubeValue(isReady: true, playerState: PlayerState.paused);
      when(controller.options).thenReturn(options);
      when(controller.value).thenReturn(value);

      await tester.pumpWidget(TestApp(
        child: WebviewtubeVideoPlayer(
          videoId,
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

  testWidgets('VolumeButton: unMute', (WidgetTester tester) async {
    provideMockedNetworkImages(() async {
      final options = WebviewtubeOptions();
      final controller = MockWebviewtubeController();
      final value = WebviewTubeValue(
          isReady: true, isMuted: true, playerState: PlayerState.paused);
      when(controller.options).thenReturn(options);
      when(controller.value).thenReturn(value);

      await tester.pumpWidget(TestApp(
        child: WebviewtubeVideoPlayer(
          videoId,
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

  testWidgets('PlaybackSpeedButton', (WidgetTester tester) async {
    provideMockedNetworkImages(() async {
      final options = WebviewtubeOptions();
      final controller = MockWebviewtubeController();
      final value =
          WebviewTubeValue(isReady: true, playerState: PlayerState.paused);
      when(controller.options).thenReturn(options);
      when(controller.value).thenReturn(value);

      await tester.pumpWidget(TestApp(
        child: WebviewtubeVideoPlayer(
          videoId,
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
