// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_declarations
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:webviewtube/webviewtube.dart';

void main() {
  group('ProgressBarStyle', () {
    test('can be instantiated', () {
      expect(
        ProgressBarStyle(
          backgroundColor: Colors.white,
          playedColor: Colors.black,
          bufferedColor: Colors.black,
          handleColor: Colors.black,
        ),
        isNotNull,
      );
    });

    test('copyWith', () {
      final style = ProgressBarStyle(
        backgroundColor: Colors.white,
        playedColor: Colors.black,
        bufferedColor: Colors.black,
        handleColor: Colors.black,
      );
      final actual = style.copyWith(playedColor: Colors.amber);

      expect(style != actual, true);
      expect(actual.playedColor, Colors.amber);
      expect(actual.backgroundColor, style.backgroundColor);
      expect(
          actual,
          ProgressBarStyle(
            backgroundColor: Colors.white,
            playedColor: Colors.amber,
            bufferedColor: Colors.black,
            handleColor: Colors.black,
          ));
    });
  });
}
