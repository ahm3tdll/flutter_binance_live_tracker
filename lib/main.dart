import 'package:flutter/material.dart';
import 'package:flutter_binance_tracker/bloc/price_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'bloc/price_bloc.dart';
import 'view/price_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env"); 
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Blocnance',
      home: BlocProvider(
        create: (_) => PriceBloc()..add(StartListening()),
        child: const PriceScreen(),
      ),
    );
  }
}
