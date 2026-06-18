import 'package:flutter/material.dart';
import 'views/gmail_page.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Conexion a Gmail',
      theme: ThemeData(
        colorSchemeSeed: Colors.red,
        useMaterial3: true,
      ),
      home: const GmailPage(),
    ),
  );
}
