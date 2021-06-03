import 'package:flutter_clean_tdd/core/platform/network_info.dart';
import 'package:flutter_clean_tdd/features/number_trivia/data/data_sources/local_number_trivia_data_source.dart';
import 'package:flutter_clean_tdd/features/number_trivia/data/data_sources/remote_number_trivia_data_source.dart';
import 'package:flutter_clean_tdd/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

import 'number_trivia_repository_impl.mocks.dart';

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
}
