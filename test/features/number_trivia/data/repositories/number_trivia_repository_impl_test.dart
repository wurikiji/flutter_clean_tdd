import 'package:dartz/dartz.dart';
import 'package:flutter_clean_tdd/core/error/exceptions.dart';
import 'package:flutter_clean_tdd/core/error/failures.dart';
import 'package:flutter_clean_tdd/core/network/network_info.dart';
import 'package:flutter_clean_tdd/features/number_trivia/data/data_sources/local_number_trivia_data_source.dart';
import 'package:flutter_clean_tdd/features/number_trivia/data/data_sources/remote_number_trivia_data_source.dart';
import 'package:flutter_clean_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_clean_tdd/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:flutter_clean_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'number_trivia_repository_impl_test.mocks.dart';

@GenerateMocks(
  [
    RemoteNumberTriviaDataSource,
    LocalNumberTriviaDataSource,
    NetworkInfo,
  ],
)
void main() {
  late NumberTriviaRepositoryImpl repository;
  late MockRemoteNumberTriviaDataSource mockRemoteNumberTriviaDataSource;
  late MockLocalNumberTriviaDataSource mockLocalNumberTriviaDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteNumberTriviaDataSource = MockRemoteNumberTriviaDataSource();
    mockLocalNumberTriviaDataSource = MockLocalNumberTriviaDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImpl(
      remoteDataSource: mockRemoteNumberTriviaDataSource,
      localDataSource: mockLocalNumberTriviaDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
      body();
    });
  }

  void runTestsOffline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });
      body();
    });
  }

  group('getConcreteNumberTrivia', () {
    const tNumber = 1;
    const tNumberTriviaModel =
        NumberTriviaModel(text: 'Test Text', number: tNumber);
    const NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test('should check if the device is online', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      repository.getConcreteNumberTrivia(tNumber);
      verify(mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      test(
          'should return remote data when the call to remote data source is succesful',
          () async {
        when(mockRemoteNumberTriviaDataSource.getConcreteNumberTrivia(any))
            .thenAnswer((_) async => tNumberTriviaModel);
        final result = await repository.getConcreteNumberTrivia(tNumber);

        verify(
            mockRemoteNumberTriviaDataSource.getConcreteNumberTrivia(tNumber));
        expect(result, equals(const Right(tNumberTrivia)));
      });

      test(
          'should return ServerFailure when the call to remote data source is unsuccesful',
          () async {
        when(mockRemoteNumberTriviaDataSource.getConcreteNumberTrivia(any))
            .thenThrow(ServerException());

        final result = await repository.getConcreteNumberTrivia(tNumber);

        verify(mockRemoteNumberTriviaDataSource
                .getConcreteNumberTrivia(tNumber))
            .called(1);
        verifyZeroInteractions(mockLocalNumberTriviaDataSource);
        expect(result, equals(const Left(ServerFailure())));
      });

      test(
          'should cache the data locally when the call to remote data source is succesful',
          () async {
        when(mockRemoteNumberTriviaDataSource.getConcreteNumberTrivia(any))
            .thenAnswer((_) async => tNumberTriviaModel);
        await repository.getConcreteNumberTrivia(tNumber);

        verify(mockRemoteNumberTriviaDataSource
                .getConcreteNumberTrivia(tNumber))
            .called(1);
        verify(mockLocalNumberTriviaDataSource
                .cacheNumberTrivia(tNumberTriviaModel))
            .called(1);
      });
    });

    runTestsOffline(() {
      test(
          'should return last locally cached data when the cached data is present',
          () async {
        when(mockLocalNumberTriviaDataSource.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        final result = await repository.getConcreteNumberTrivia(tNumber);

        verifyZeroInteractions(mockRemoteNumberTriviaDataSource);
        verify(mockLocalNumberTriviaDataSource.getLastNumberTrivia()).called(1);
        expect(result, equals(const Right(tNumberTrivia)));
      });

      test(
          'should return CacheFailure data when there is no cached data present',
          () async {
        when(mockLocalNumberTriviaDataSource.getLastNumberTrivia())
            .thenThrow(CacheException());
        final result = await repository.getConcreteNumberTrivia(tNumber);

        verifyZeroInteractions(mockRemoteNumberTriviaDataSource);
        verify(mockLocalNumberTriviaDataSource.getLastNumberTrivia()).called(1);
        expect(result, equals(const Left(CacheFailure())));
      });
    });
  });
  group('getRandomNumberTrivia', () {
    const tNumber = 1;
    const tNumberTriviaModel =
        NumberTriviaModel(text: 'Test Text', number: tNumber);
    const NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test('should check if the device is online', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      repository.getRandomNumberTrivia();
      verify(mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      test(
          'should return remote data when the call to remote data source is succesful',
          () async {
        when(mockRemoteNumberTriviaDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        final result = await repository.getRandomNumberTrivia();

        verify(mockRemoteNumberTriviaDataSource.getRandomNumberTrivia());
        expect(result, equals(const Right(tNumberTrivia)));
      });

      test(
          'should return ServerFailure when the call to remote data source is unsuccesful',
          () async {
        when(mockRemoteNumberTriviaDataSource.getRandomNumberTrivia())
            .thenThrow(ServerException());

        final result = await repository.getRandomNumberTrivia();

        verify(mockRemoteNumberTriviaDataSource.getRandomNumberTrivia())
            .called(1);
        verifyZeroInteractions(mockLocalNumberTriviaDataSource);
        expect(result, equals(const Left(ServerFailure())));
      });

      test(
          'should cache the data locally when the call to remote data source is succesful',
          () async {
        when(mockRemoteNumberTriviaDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        await repository.getRandomNumberTrivia();

        verify(mockRemoteNumberTriviaDataSource.getRandomNumberTrivia())
            .called(1);
        verify(mockLocalNumberTriviaDataSource
                .cacheNumberTrivia(tNumberTriviaModel))
            .called(1);
      });
    });

    runTestsOffline(() {
      test(
          'should return last locally cached data when the cached data is present',
          () async {
        when(mockLocalNumberTriviaDataSource.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        final result = await repository.getRandomNumberTrivia();

        verifyZeroInteractions(mockRemoteNumberTriviaDataSource);
        verify(mockLocalNumberTriviaDataSource.getLastNumberTrivia()).called(1);
        expect(result, equals(const Right(tNumberTrivia)));
      });

      test(
          'should return CacheFailure data when there is no cached data present',
          () async {
        when(mockLocalNumberTriviaDataSource.getLastNumberTrivia())
            .thenThrow(CacheException());
        final result = await repository.getRandomNumberTrivia();

        verifyZeroInteractions(mockRemoteNumberTriviaDataSource);
        verify(mockLocalNumberTriviaDataSource.getLastNumberTrivia()).called(1);
        expect(result, equals(const Left(CacheFailure())));
      });
    });
  });
}
