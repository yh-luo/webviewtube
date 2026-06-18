// ignore_for_file: prefer_const_declarations
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:webviewtube/src/widgets/widgets.dart';
import 'package:webviewtube/webviewtube.dart' as public;

void main() {
  group('WebviewtubeDefaults', () {
    group('loadingBuilder', () {
      testWidgets('returns SizedBox.shrink when isReady is true', (
        tester,
      ) async {
        late Widget result;
        await tester.pumpWidget(
          Builder(
            builder: (context) {
              result = WebviewtubeDefaults.loadingBuilder(context, true);
              return const SizedBox();
            },
          ),
        );

        expect(result, isA<SizedBox>());
        final sizedBox = result as SizedBox;
        expect(sizedBox.width, 0);
        expect(sizedBox.height, 0);
      });

      testWidgets('returns LoadingIndicator when isReady is false', (
        tester,
      ) async {
        late Widget result;
        await tester.pumpWidget(
          Builder(
            builder: (context) {
              result = WebviewtubeDefaults.loadingBuilder(context, false);
              return const SizedBox();
            },
          ),
        );

        expect(result, isA<LoadingIndicator>());
      });

      testWidgets('respects custom color', (tester) async {
        late Widget result;
        await tester.pumpWidget(
          Builder(
            builder: (context) {
              result = WebviewtubeDefaults.loadingBuilder(
                context,
                false,
                color: Colors.red,
              );
              return const SizedBox();
            },
          ),
        );

        expect((result as LoadingIndicator).color, Colors.red);
      });

      test(
        'matches WebviewtubeLoadingBuilder signature (usable as tear-off)',
        () {
          final WebviewtubeLoadingBuilder builder =
              WebviewtubeDefaults.loadingBuilder;
          expect(builder, isNotNull);
        },
      );
    });

    group('controlsBuilder', () {
      test(
        'matches WebviewtubeControlsBuilder signature (usable as tear-off)',
        () {
          final WebviewtubeControlsBuilder builder =
              WebviewtubeDefaults.controlsBuilder;
          expect(builder, isNotNull);
        },
      );
    });

    group('progressBarBuilder', () {
      test(
        'matches WebviewtubeProgressBarBuilder signature (usable as tear-off)',
        () {
          final WebviewtubeProgressBarBuilder builder =
              WebviewtubeDefaults.progressBarBuilder;
          expect(builder, isNotNull);
        },
      );
    });

    test('is reachable via the public package barrel', () {
      expect(public.WebviewtubeDefaults.loadingBuilder, isNotNull);
      expect(public.WebviewtubeDefaults.controlsBuilder, isNotNull);
      expect(public.WebviewtubeDefaults.progressBarBuilder, isNotNull);
    });
  });
}
