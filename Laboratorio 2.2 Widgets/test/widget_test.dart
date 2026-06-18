import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:laboratorio_widgets/views/gmail_page.dart';

void main() {
  testWidgets('La app muestra la pantalla de Gmail',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: GmailPage()),
    );
    await tester.pump();

    // El titulo de la AppBar siempre esta visible.
    expect(find.text('Gmail'), findsOneWidget);
  });
}
