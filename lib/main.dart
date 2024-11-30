import 'package:packages_persistencia/screens/cadastro_screen.dart';
import 'package:packages_persistencia/screens/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    title: 'Anúncios',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(primaryColor: const Color.fromARGB(255, 28, 124, 77)),
    initialRoute: "/",
    routes: {
      "/": (context) => HomeScreen(),
      "/cadastro": (context) => CadastroScreen()
    },
  ));
}
