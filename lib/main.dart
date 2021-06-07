import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_tdd/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:flutter_clean_tdd/features/number_trivia/presentation/pages/number_trivia_page.dart';
import 'package:flutter_clean_tdd/injection_container.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Number Trivia',
      theme: ThemeData(
        primaryColor: Colors.green.shade800,
      ),
      home: BlocProvider(
        create: (_) => di.sl<NumberTriviaBloc>(),
        child: const NumberTriviaPage(),
      ),
    );
  }
}
