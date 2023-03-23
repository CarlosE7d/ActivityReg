import 'package:activity_register/pages/addUser.dart';
import 'package:activity_register/pages/homepage.dart';
import 'package:activity_register/pages/vivencias.dart';
import 'package:activity_register/pages/addVivencias.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: HomeScreen.ROUTE,
      routes: {
        //Manejador de turas
        HomeScreen.ROUTE: (_) => HomeScreen(),
        AddUser.ROUTE: (_) => AddUser(),
        ListVivencia.ROUTE: (_) => ListVivencia(),
        AddVivencia.ROUTE: (_) => AddVivencia(),
      },
    );
  }
}
