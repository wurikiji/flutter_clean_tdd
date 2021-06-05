import 'package:dartz/dartz.dart';
import 'package:flutter_clean_tdd/core/error/failures.dart';

class InputConverter {
  Either<Failure, int> stringToUnsignedInteger(String str) {
    try {
      final integer = int.parse(str);
      if (integer < 0) {
        throw const FormatException("A negative integer is not acceptable");
      }
      return Right(integer);
    } on Exception catch (_) {
      return Left(InvalidInputFailure());
    }
  }
}

class InvalidInputFailure extends Failure {}
