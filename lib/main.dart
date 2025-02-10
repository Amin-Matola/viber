import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sham/auth/data.dart';
import 'package:sham/pages/dashboard.dart';
import 'package:sham/pages/home.dart';
import 'package:sham/pages/landing.dart';
import 'package:sham/pages/profile.dart';
import 'package:sham/pages/signup.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => DataManager(),
      child: Sham()
    )
  );
}

class Sham extends StatelessWidget {
  const Sham({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vibe',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF084ca1)),
        useMaterial3: true,
        fontFamily: "Poppins"
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => Home(),
        '/signup': (context) => Signup(),
        '/home': (context) => Landing(),
        '/settings': (context) => Landing(),
        '/profile': (context) => Profile(),
        '/chat': (context) => Dashboard()
      }
    );
  }
}


