import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropdown_alert/dropdown_alert.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/home.dart';
import 'screens/login.dart';
import 'screens/registration.dart';
import 'tools/styles.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar', 'AE'),
      ],
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'AmiriR',
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: colorPrimary,
          secondary: colorSecondary,
        ),
      ),
      builder: (context, child) => Stack(
            children: [
              child!,
              const DropdownAlert(
                position: AlertPosition.TOP,
                duration: 6,
              )
            ],
          ),
      initialRoute: Login.root,
      routes: {
        Login.root: (context) => const Login(),
        Registration.root: (context) => const Registration(),
        Home.root: (context) => const Home(),
      }));
}
