import 'package:flutter_clean_tdd/features/number_trivia/domain/repositories/number_trivia_repository.dart';

class GetConcreteNubmerTrivia {
  final NumberTriviaRepository repository;

  GetConcreteNubmerTrivia(this.repository);

  Future<FailureOrNumberTrivia> execute({required int number}) async {
    return await repository.getConcreteNumberTrivia(number);
  }
}
