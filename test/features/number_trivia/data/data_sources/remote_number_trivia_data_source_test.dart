import 'dart:convert';

import 'package:flutter_clean_tdd/core/error/exceptions.dart';
import 'package:flutter_clean_tdd/features/number_trivia/data/data_sources/remote_number_trivia_data_source.dart';
import 'package:flutter_clean_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'remote_number_trivia_data_source_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late MockClient mockHttpClient;
  late RemoteNumberTriviaDataSourceImpl remoteNumberTriviaDataSource;
  setUp(() {
    mockHttpClient = MockClient();
    remoteNumberTriviaDataSource =
        RemoteNumberTriviaDataSourceImpl(mockHttpClient);
  });

  void setUpMockHttpClient(String body, int statusCode) {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(body, statusCode));
  }

  void setUpMockHttpClientSuccess200() {
    setUpMockHttpClient(fixture('trivia.json'), 200);
  }

  void setUpMockHttpClientFailure404() {
    setUpMockHttpClient('Something went wrong', 404);
  }

  group('getConcreteNumberTrivia', () {
    const tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
    test('''should perform a GET request on a URL with number being the endpoint
        and with application/json header
      ''', () async {
      setUpMockHttpClientSuccess200();
      remoteNumberTriviaDataSource.getConcreteNumberTrivia(tNumber);
      verify(mockHttpClient.get(Uri.tryParse('http://numbersapi.com/$tNumber'),
          headers: {'Content-Type': 'application/json'})).called(1);
    });
    test('''should return NumberTrivia when the response code is 200 (success)
    ''', () async {
      setUpMockHttpClientSuccess200();
      final result =
          await remoteNumberTriviaDataSource.getConcreteNumberTrivia(tNumber);
      expect(result, equals(tNumberTriviaModel));
    });

    test('''
      should throw a ServerException when the response code is 404 or other
    ''', () async {
      setUpMockHttpClientFailure404();
      final call = remoteNumberTriviaDataSource.getConcreteNumberTrivia;
      expect(
          () => call(tNumber), throwsA(const TypeMatcher<ServerException>()));
    });
  });

  group('getRandomNumberTrivia', () {
    const tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
    test('''should perform a GET request on a URL with *random* endpoint
        and with application/json header
      ''', () async {
      setUpMockHttpClientSuccess200();
      remoteNumberTriviaDataSource.getRandomNumberTrivia();
      verify(mockHttpClient.get(Uri.tryParse('http://numbersapi.com/random'),
          headers: {'Content-Type': 'application/json'})).called(1);
    });
    test('''should return NumberTrivia when the response code is 200 (success)
    ''', () async {
      setUpMockHttpClientSuccess200();
      final result = await remoteNumberTriviaDataSource.getRandomNumberTrivia();
      expect(result, equals(tNumberTriviaModel));
    });

    test('''
      should throw a ServerException when the response code is 404 or other
    ''', () async {
      setUpMockHttpClientFailure404();
      final call = remoteNumberTriviaDataSource.getRandomNumberTrivia;
      expect(() => call(), throwsA(const TypeMatcher<ServerException>()));
    });
  });
}
