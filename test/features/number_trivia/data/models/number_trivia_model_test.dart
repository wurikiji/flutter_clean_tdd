import 'dart:convert';

import 'package:flutter_clean_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_clean_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'Test Text');

  test('should be a subclass of NumberTrivia entity', () async {
    expect(tNumberTriviaModel, isA<NumberTrivia>());
  });

  group('fromJson', () {
    test(
      'should return a valid model when the JSON number is an integer',
      () async {
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('trivia.json'));

        final result = NumberTriviaModel.fromJson(jsonMap);

        expect(result, equals(tNumberTriviaModel));
      },
    );

    test('should return a valid model when the JSON number is a double',
        () async {
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('trivia_double.json'));

      final result = NumberTriviaModel.fromJson(jsonMap);

      expect(result, equals(tNumberTriviaModel));
    });
  });

  group('toJson', () {
    test('should return a JSON map containing the proper data', () async {
      final result = tNumberTriviaModel.toJson();
      var matcher = {"text": "Test Text", "number": 1};
      expect(result, matcher);
    });
  });
}
