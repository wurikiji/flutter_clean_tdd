import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../error/failures.dart';

abstract class Usecase<Return, Params> {
  Future<Either<Failure, Return>> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}
