import 'dart:convert';

import 'package:flutter_clean_tdd/core/error/exceptions.dart';
import 'package:flutter_clean_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalNumberTriviaDataSource {
  /// Gets the cached [NumberTriviaModel] which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws [NoLocalDataException] if no cached data is present.
  Future<NumberTriviaModel> getLastNumberTrivia();

  Future<void> cacheNumberTrivia(NumberTriviaModel trivia);
}

// ignore: constant_identifier_names
const CACHED_NUMBER_TRIVIA = 'CACHED_NUMBER_TRIVIA';

class LocalNumberTriviaDataSourceImpl implements LocalNumberTriviaDataSource {
  final SharedPreferences sharedPreferences;

  LocalNumberTriviaDataSourceImpl(this.sharedPreferences);
  @override
  Future<NumberTriviaModel> getLastNumberTrivia() async {
    final jsonString = sharedPreferences.getString(CACHED_NUMBER_TRIVIA);
    if (jsonString != null) {
      return NumberTriviaModel.fromJson(json.decode(jsonString));
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel trivia) async {
    sharedPreferences.setString(
        CACHED_NUMBER_TRIVIA, json.encode(trivia.toJson()));
  }
}
