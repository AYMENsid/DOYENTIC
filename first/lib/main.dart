import 'package:first/screen/ArticleDetaills.dart';
import 'package:first/screen/HomeScreen.dart';

//import 'package:first/screen/Matchs.dart';
import 'package:first/screen/PasswordR.dart';
import 'package:first/screen/TicketFormScreen.dart';
//import 'package:first/screen/store.dart';
import 'package:flutter/material.dart';
import 'package:first/screen/login.dart';
import 'package:first/screen/WelcomeScreen.dart';
import 'package:first/screen/signup.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const WelcomeScreen(),
        routes: {
          'HomeScreen': (context) => const HomeScreen(),
          'ArticleDetails': (context) => ArticleDetails(
                articleId: '',
              ),
          'PasswordR': (context) => const PasswordR(),
          'Signupscreen': (context) => const Signupscreen(),
          'Loginscreen': (context) => const Loginscreen(),
          //'Matchs': (context) => const Matchs(),
          'WelcomeScreen': (context) => const WelcomeScreen(),
          'TicketFormScreen': (context) => const TicketFormScreen(),
        });
  }
}
