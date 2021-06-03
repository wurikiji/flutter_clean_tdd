import 'package:equatable/equatable.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/number_trivia.dart';
import '../repositories/number_trivia_repository.dart';

class GetConcreteNubmerTrivia implements Usecase<NumberTrivia, Params> {
  final NumberTriviaRepository repository;

  GetConcreteNubmerTrivia(this.repository);

  @override
  Future<FailureOrNumberTrivia> call(Params params) async {
    return await repository.getConcreteNumberTrivia(params.number);
  }
}

class Params extends Equatable {
  final int number;

  const Params({required this.number});
  @override
  List<Object?> get props => [number];
}
