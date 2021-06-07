import 'package:dartz/dartz.dart';
import 'package:flutter_clean_tdd/core/error/failures.dart';
import 'package:flutter_clean_tdd/core/usecases/usecase.dart';
import 'package:flutter_clean_tdd/core/util/input_converter.dart';
import 'package:flutter_clean_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_clean_tdd/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:flutter_clean_tdd/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:flutter_clean_tdd/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:meta/meta.dart';

import 'number_trivia_bloc_test.mocks.dart';

@GenerateMocks([GetConcreteNubmerTrivia, GetRandomNumberTrivia, InputConverter])
void main() {
  late NumberTriviaBloc bloc;
  late MockGetConcreteNubmerTrivia mockGetConcreteNubmerTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNubmerTrivia = MockGetConcreteNubmerTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();

    bloc = NumberTriviaBloc(
      getConcreteNubmerTrivia: mockGetConcreteNubmerTrivia,
      getRandomNumberTrivia: mockGetRandomNumberTrivia,
      inputConverter: mockInputConverter,
    );
  });

  test('initialState should be empty', () async {
    expect(bloc.state, equals(Empty()));
  });

  group('GetTriviaForConcreteNumber', () {
    const tNumberString = '1';
    final tNumberParsed = int.parse(tNumberString);
    const tNumberTrivia = NumberTrivia(text: 'test trivia', number: 1);
    void setUpDepedency(
        {bool invalidInput = false,
        bool serverFailed = false,
        bool cacheFailed = false}) {
      when(mockInputConverter.stringToUnsignedInteger(any)).thenReturn(
          invalidInput ? Left(InvalidInputFailure()) : Right(tNumberParsed));
      when(mockGetConcreteNubmerTrivia(any)).thenAnswer((_) async =>
          serverFailed
              ? const Left(ServerFailure())
              : (cacheFailed
                  ? const Left(CacheFailure())
                  : const Right(tNumberTrivia)));
    }

    @isTest
    void testWithDependency(
      String title,
      Function() body, {
      bool invalidInput = false,
      bool serverFailed = false,
      bool cacheFailed = false,
    }) {
      test(title, () async {
        setUpDepedency(
            invalidInput: invalidInput,
            serverFailed: serverFailed,
            cacheFailed: cacheFailed);
        await body();
      });
    }

    testWithDependency(
        'should call the InputConverter to validate and convert the string to integer',
        () async {
      // when
      bloc.add(const GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(mockInputConverter.stringToUnsignedInteger(any));
      // then
      verify(mockInputConverter.stringToUnsignedInteger(tNumberString))
          .called(1);
    });
    testWithDependency('should emit [Error] when the input is invalid',
        () async {
      // when
      bloc.add(const GetTriviaForConcreteNumber(tNumberString));

      // then
      await expectLater(bloc.stream,
          emitsInAnyOrder([const Error(INVALID_INPUT_FAILURE_MESSAGE)]));
    }, invalidInput: true);

    testWithDependency('should get data from the concrete use case', () async {
      // when
      bloc.add(const GetTriviaForConcreteNumber(tNumberString));
      // then
      await untilCalled(mockGetConcreteNubmerTrivia(any));
      verify(mockGetConcreteNubmerTrivia(Params(number: tNumberParsed)))
          .called(1);
    });
    testWithDependency(
        'should emit [Loading, Loaded] when data is gotten succesfully',
        () async {
      // when
      bloc.add(const GetTriviaForConcreteNumber(tNumberString));
      // then
      final expected = [
        Loading(),
        const Loaded(tNumberTrivia),
      ];

      expectLater(bloc.stream, emitsInOrder(expected));
    });

    testWithDependency('should emit [Loading, Error] when getting data fails',
        () async {
      // when
      bloc.add(const GetTriviaForConcreteNumber(tNumberString));
      // then
      final expected = [
        Loading(),
        const Error(SERVER_FAILURE_MESSAGE),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
    }, serverFailed: true);
    testWithDependency(
        'should emit [Loading, Error] with a proper message for the error with CacheFailure',
        () async {
      // when
      bloc.add(const GetTriviaForConcreteNumber(tNumberString));
      // then
      final expected = [
        Loading(),
        const Error(CACHE_FAILURE_MESSAGE),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
    }, cacheFailed: true);
  });

  group('GetTriviaForRandomNumber', () {
    const tNumberTrivia = NumberTrivia(text: 'test trivia', number: 1);
    void setUpDepedency({bool serverFailed = false, bool cacheFailed = false}) {
      when(mockGetRandomNumberTrivia(any)).thenAnswer((_) async => serverFailed
          ? const Left(ServerFailure())
          : (cacheFailed
              ? const Left(CacheFailure())
              : const Right(tNumberTrivia)));
    }

    @isTest
    void testWithDependency(
      String title,
      Function() body, {
      bool invalidInput = false,
      bool serverFailed = false,
      bool cacheFailed = false,
    }) {
      test(title, () async {
        setUpDepedency(serverFailed: serverFailed, cacheFailed: cacheFailed);
        await body();
      });
    }

    testWithDependency('should get data from the random use case', () async {
      // when
      bloc.add(GetTriviaForRandomNubmer());
      await untilCalled(mockGetRandomNumberTrivia(any));
      // then
      verify(mockGetRandomNumberTrivia(NoParams())).called(1);
    });
    testWithDependency(
        'should emit [Loading, Loaded] when data is gotten succesfully',
        () async {
      // when
      bloc.add(GetTriviaForRandomNubmer());
      // then
      final expected = [
        Loading(),
        const Loaded(tNumberTrivia),
      ];

      expectLater(bloc.stream, emitsInOrder(expected));
    });

    testWithDependency('should emit [Loading, Error] when getting data fails',
        () async {
      // when
      bloc.add(GetTriviaForRandomNubmer());
      // then
      final expected = [
        Loading(),
        const Error(SERVER_FAILURE_MESSAGE),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
    }, serverFailed: true);

    testWithDependency(
        'should emit [Loading, Error] with a proper message for the error with CacheFailure',
        () async {
      // when
      bloc.add(GetTriviaForRandomNubmer());
      // then
      final expected = [
        Loading(),
        const Error(CACHE_FAILURE_MESSAGE),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
    }, cacheFailed: true);
  });
}
