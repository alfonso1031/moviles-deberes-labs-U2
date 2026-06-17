import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/correo_viewmodel.dart';
import 'views/home_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CorreoViewModel(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Laboratorio 2.2 Widgets',
        theme: ThemeData(
          colorSchemeSeed: Colors.red,
          useMaterial3: true,
        ),
        home: const HomePage(),
      ),
    ),
  );
}
