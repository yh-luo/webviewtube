// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_declarations
import 'package:flutter_test/flutter_test.dart';
import 'package:webviewtube/webviewtube.dart';

void main() {
  group('WebviewtubeOptions', () {
    group('copyWith', () {
      late WebviewtubeOptions options;

      setUp(() {
        options = WebviewtubeOptions();
      });

      test('showControls', () {
        final actual = options.copyWith(showControls: false);

        expect(options != actual, true);
        expect(actual, WebviewtubeOptions(showControls: false));
      });

      test('autoPlay', () {
        final actual = options.copyWith(autoPlay: false);

        expect(options != actual, true);
        expect(actual, WebviewtubeOptions(autoPlay: false));
      });

      test('mute', () {
        final actual = options.copyWith(mute: true);

        expect(options != actual, true);
        expect(actual, WebviewtubeOptions(mute: true));
      });

      test('loop', () {
        final actual = options.copyWith(loop: true);

        expect(options != actual, true);
        expect(actual, WebviewtubeOptions(loop: true));
      });

      test('forceHd', () {
        final actual = options.copyWith(forceHd: true);

        expect(options != actual, true);
        expect(actual, WebviewtubeOptions(forceHd: true));
      });

      test('interfaceLanguage', () {
        final actual = options.copyWith(interfaceLanguage: 'zh-Hant');

        expect(options != actual, true);
        expect(actual, WebviewtubeOptions(interfaceLanguage: 'zh-Hant'));
      });

      test('enableCaption', () {
        final actual = options.copyWith(enableCaption: false);

        expect(options != actual, true);
        expect(actual, WebviewtubeOptions(enableCaption: false));
      });

      test('captionLanguage', () {
        final actual = options.copyWith(captionLanguage: 'zh-Hant');

        expect(options != actual, true);
        expect(actual, WebviewtubeOptions(captionLanguage: 'zh-Hant'));
      });

      test('startAt', () {
        final actual = options.copyWith(startAt: 1);

        expect(options != actual, true);
        expect(actual, WebviewtubeOptions(startAt: 1));
      });

      test('endAt', () {
        final actual = options.copyWith(endAt: 1);

        expect(options != actual, true);
        expect(actual, WebviewtubeOptions(endAt: 1));
      });

      test('currentTimeUpdateInterval', () {
        final actual = options.copyWith(currentTimeUpdateInterval: 1);

        expect(options != actual, true);
        expect(actual, WebviewtubeOptions(currentTimeUpdateInterval: 1));
      });
    });
  });
}
