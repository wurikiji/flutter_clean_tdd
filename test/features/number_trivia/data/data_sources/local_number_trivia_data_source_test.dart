import 'dart:convert';

import 'package:flutter_clean_tdd/core/error/exceptions.dart';
import 'package:flutter_clean_tdd/features/number_trivia/data/data_sources/local_number_trivia_data_source.dart';
import 'package:flutter_clean_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'local_number_trivia_data_source_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main() {
  late MockSharedPreferences mockSharedPreferences;
  late LocalNumberTriviaDataSourceImpl localNumberTriviaDataSource;
  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    localNumberTriviaDataSource =
        LocalNumberTriviaDataSourceImpl(mockSharedPreferences);
  });

  group('getLastNumberTrivia', () {
    final fixtureModel = fixture('trivia_cached.json');
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixtureModel));
    test(
        'should return NumberTrivia from SharedPreferences when there is one in the cache',
        () async {
      when(mockSharedPreferences.getString(any))
          .thenAnswer((_) => fixtureModel);
      final result = await localNumberTriviaDataSource.getLastNumberTrivia();

      verify(mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA)).called(1);
      expect(result, equals(tNumberTriviaModel));
    });

    test(
        'should throw a CacheException from SharedPreferences when there is nothing cached',
        () async {
      when(mockSharedPreferences.getString(any)).thenReturn(null);

      expect(
        localNumberTriviaDataSource.getLastNumberTrivia,
        throwsA(const TypeMatcher<CacheException>()),
      );
    });
  });

  group('cacheNumberTrivia', () {
    const tNumberTriviaModel =
        NumberTriviaModel(text: 'test trivia', number: 1);
    test('should call SharedPreferences to cache the data', () async {
      when(mockSharedPreferences.setString(any, any))
          .thenAnswer((_) => Future.value(true));
      localNumberTriviaDataSource.cacheNumberTrivia(tNumberTriviaModel);

      final expectedJsonString = json.encode(tNumberTriviaModel.toJson());

      verify(mockSharedPreferences.setString(
              CACHED_NUMBER_TRIVIA, expectedJsonString))
          .called(1);
    });
  });
}
