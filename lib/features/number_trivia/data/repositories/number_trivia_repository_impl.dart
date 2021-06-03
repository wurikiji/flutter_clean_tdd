import 'package:flutter_clean_tdd/core/platform/network_info.dart';
import 'package:flutter_clean_tdd/features/number_trivia/data/data_sources/local_number_trivia_data_source.dart';
import 'package:flutter_clean_tdd/features/number_trivia/data/data_sources/remote_number_trivia_data_source.dart';
import 'package:flutter_clean_tdd/features/number_trivia/domain/repositories/number_trivia_repository.dart';

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
  Future<FailureOrNumberTrivia> getConcreteNumberTrivia(int number) {
    // TODO: implement getConcreteNumberTrivia
    throw UnimplementedError();
  }

  @override
  Future<FailureOrNumberTrivia> getRandomNumberTrivia() {
    // TODO: implement getRandomNumberTrivia
    throw UnimplementedError();
  }
}
