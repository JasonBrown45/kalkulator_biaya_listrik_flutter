import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'calculation.dart';
import 'home_page.dart';

void main() => runApp(const MainApp());

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CalculatorState(),
      child: MaterialApp(
        title: 'Kalkulator Biaya Listrik',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: HomePage(),
      ),
    );
  }
}
