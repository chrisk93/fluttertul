import 'package:flutter/material.dart';
import 'package:tulprueba/routes/routes.dart';

import 'pages/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tul',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: applicationRoutes(),
      onGenerateRoute: (RouteSettings settings){
        print('Ruta llamada ${settings.name}');
        return MaterialPageRoute(
            builder: (BuildContext context) => HomePage()
        );
      },
    );
  }
}
