// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_declarations
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:webviewtube/webviewtube.dart';

void main() {
  group('ProgressBarColors', () {
    test('can be instantiated', () {
      expect(
        ProgressBarColors(
          backgroundColor: Colors.white,
          playedColor: Colors.black,
          bufferedColor: Colors.black,
          handleColor: Colors.black,
        ),
        isNotNull,
      );
    });

    test('copyWith', () {
      final colors = ProgressBarColors(
        backgroundColor: Colors.white,
        playedColor: Colors.black,
        bufferedColor: Colors.black,
        handleColor: Colors.black,
      );
      final actual = colors.copyWith(playedColor: Colors.amber);

      expect(colors != actual, true);
      expect(actual.playedColor, Colors.amber);
      expect(actual.backgroundColor, colors.backgroundColor);
      expect(
          actual,
          ProgressBarColors(
            backgroundColor: Colors.white,
            playedColor: Colors.amber,
            bufferedColor: Colors.black,
            handleColor: Colors.black,
          ));
    });
  });
}
