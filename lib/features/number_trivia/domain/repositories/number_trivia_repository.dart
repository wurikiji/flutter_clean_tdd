import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/number_trivia.dart';

typedef FailureOrNumberTrivia = Either<Failure, NumberTrivia>;

abstract class NumberTriviaRepository {
  Future<FailureOrNumberTrivia> getConcreteNumberTrivia(int number);
  Future<FailureOrNumberTrivia> getRandomNumberTrivia();
}
