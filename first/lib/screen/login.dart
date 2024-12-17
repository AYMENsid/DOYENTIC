import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:first/screen/WelcomeScreen.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Fonction pour naviguer vers WelcomeScreen
  void navigateToWelcomeScreen() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
          builder: (context) =>
              const WelcomeScreen()), // Assurez-vous que WelcomeScreen est défini
      (route) => false,
    );
  }

  // Fonction pour naviguer vers HomeScreen
  void navigateToHomeScreen() {
    Navigator.of(context).pushReplacementNamed('HomeScreen');
  }

  // Fonction pour naviguer vers PasswordR
  void navigateToR() {
    Navigator.of(context).pushReplacementNamed('PasswordR');
  }

  // Fonction de connexion utilisateur
  Future<void> loginUser() async {
    final String email = emailController.text.trim();
    final String password = passwordController.text;

    // Validation de l'email
    if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
        .hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez entrer un email valide")),
      );
      return;
    }

    // Données à envoyer à l'API
    final Map<String, String> data = {
      'email': email,
      'password': password,
    };

    // Affiche un indicateur de chargement
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    try {
      // Requête HTTP POST
      final response = await http.post(
        Uri.parse(
            "http://192.168.100.2/flutterback/login.php"), // 10.0.2.2 sur emulateur
        headers: {"Content-Type": "application/json"},
        body: json.encode(data),
      );

      Navigator.of(context).pop(); // Ferme l'indicateur de chargement

      if (response.statusCode == 200) {
        // Enregistrer les données utilisateur dans SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('user_email', email); // Sauvegarde de l'email

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Connexion réussie")),
        );

        // Redirection vers HomeScreen
        navigateToHomeScreen();
      } else if (response.statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Identifiants incorrects")),
        );
      } else {
        final Map<String, dynamic> responseData = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(responseData['message'] ??
                "Problème de connexion avec le serveur"),
          ),
        );
      }
    } catch (error) {
      Navigator.of(context).pop(); // Ferme l'indicateur de chargement
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erreur lors de la connexion au serveur")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 160, 189, 159),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: navigateToWelcomeScreen, // Retourne à WelcomeScreen
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "Connexion",
                      style: GoogleFonts.roboto(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Text(
                      "Connectez-vous pour continuer",
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "Email",
                      labelStyle: const TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.green),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: "Mot de passe",
                      labelStyle: const TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.green),
                      ),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: loginUser,
                      child: const Text(
                        "Se connecter",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Ajouter le bouton "Mot de passe oublié ?"
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed:
                          navigateToR, // Appel de la fonction navigateToR
                      child: Center(
                        child: const Text(
                          "Mot de passe oublié ?",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
