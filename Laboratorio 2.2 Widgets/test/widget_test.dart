import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:laboratorio_widgets/viewmodels/correo_viewmodel.dart';
import 'package:laboratorio_widgets/views/home_page.dart';

void main() {
  testWidgets('Widget Gmail muestra correos simulados',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => CorreoViewModel(),
        child: const MaterialApp(home: HomePage()),
      ),
    );
    expect(find.text('Gmail'), findsOneWidget);
    expect(find.textContaining('no leidos'), findsOneWidget);
    expect(find.text('Redactar'), findsOneWidget);
  });
}
