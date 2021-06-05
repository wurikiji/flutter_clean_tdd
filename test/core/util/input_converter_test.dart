import 'package:dartz/dartz.dart';
import 'package:flutter_clean_tdd/core/util/input_converter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late InputConverter inputConverter;
  setUp(() {
    inputConverter = InputConverter();
  });

  group('stringToUnsignedInt', () {
    test(
        'should return an integer when the string represents and unsigned integer',
        () async {
      const str = '123';
      final result = inputConverter.stringToUnsignedInteger(str);
      expect(result, const Right(123));
    });

    test('should return a failure when the string is not an integer', () async {
      // given
      const str = 'abc';
      // when
      final result = inputConverter.stringToUnsignedInteger(str);
      // then
      expect(result, Left(InvalidInputFailure()));
    });

    test('should return a failure when the string is a negative integer',
        () async {
      // given
      const str = '-123';
      // when
      final result = inputConverter.stringToUnsignedInteger(str);
      // then
      expect(result, Left(InvalidInputFailure()));
    });
  });
}
