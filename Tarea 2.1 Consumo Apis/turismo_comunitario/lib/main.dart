import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/destino_service.dart';
import 'services/reserva_service.dart';
import 'viewmodels/destino_viewmodel.dart';
import 'viewmodels/reserva_viewmodel.dart';
import 'views/splash_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => DestinoViewModel(service: DestinoService()),
        ),
        ChangeNotifierProvider(
          create: (_) => ReservaViewModel(service: ReservaService()),
        ),
      ],
      child: MaterialApp(
        title: "Turismo Comunitario",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF2E7D32),
            surface: Colors.white,
          ),
          scaffoldBackgroundColor: Colors.white,
          useMaterial3: true,
          filledButtonTheme: FilledButtonThemeData(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D32),
              foregroundColor: Colors.white,
            ),
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF388E3C),
            ),
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Color(0xFF2E7D32),
            foregroundColor: Colors.white,
          ),
          snackBarTheme: const SnackBarThemeData(
            backgroundColor: Color(0xFF1B5E20),
            contentTextStyle: TextStyle(color: Colors.white),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ),
        ),
        home: const SplashPage(),
      ),
    );
  }
}
