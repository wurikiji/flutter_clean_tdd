import 'package:dartz/dartz.dart';
import 'package:flutter_clean_tdd/core/error/exceptions.dart';
import 'package:flutter_clean_tdd/core/error/failures.dart';
import 'package:flutter_clean_tdd/core/network/network_info.dart';
import 'package:flutter_clean_tdd/features/number_trivia/data/data_sources/local_number_trivia_data_source.dart';
import 'package:flutter_clean_tdd/features/number_trivia/data/data_sources/remote_number_trivia_data_source.dart';
import 'package:flutter_clean_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_clean_tdd/features/number_trivia/domain/repositories/number_trivia_repository.dart';

typedef _NumberTriviaBuilder = Future<NumberTriviaModel> Function();

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final RemoteNumberTriviaDataSource remoteDataSource;
  final LocalNumberTriviaDataSource localDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });
  @override
  Future<FailureOrNumberTrivia> getConcreteNumberTrivia(int number) async {
    return await _getTrivia(
        () async => await remoteDataSource.getConcreteNumberTrivia(number));
  }

  @override
  Future<FailureOrNumberTrivia> getRandomNumberTrivia() async {
    return await _getTrivia(
        () async => await remoteDataSource.getRandomNumberTrivia());
  }

  Future<FailureOrNumberTrivia> _getTrivia(_NumberTriviaBuilder trivia) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteTrivia = await trivia();
        localDataSource.cacheNumberTrivia(remoteTrivia);
        return Right(remoteTrivia);
      } on ServerException {
        return const Left(ServerFailure());
      } catch (_) {
        return const Left(ServerFailure());
      }
    } else {
      try {
        final localTrivia = await localDataSource.getLastNumberTrivia();
        return Right(localTrivia);
      } on Exception catch (_) {
        return const Left(CacheFailure());
      }
    }
  }
}
