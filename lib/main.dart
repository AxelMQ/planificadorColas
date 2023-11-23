import 'package:flutter/material.dart';
import 'package:p_colas_prioridad/screens/home_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simulador de Colas de Prioridad',
      home: const HomeScreen(),
      theme: ThemeData(useMaterial3: true),
      debugShowCheckedModeBanner: false,
    );
  }
}
