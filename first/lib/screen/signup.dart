import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Signupscreen extends StatefulWidget {
  const Signupscreen({super.key});

  @override
  State<Signupscreen> createState() => _SignupscreenState();
}

class _SignupscreenState extends State<Signupscreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  void navigateToWelcomeScreen() {
    Navigator.of(context).pushReplacementNamed('WelcomeScreen');
  }

  Future<void> registerUser() async {
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Les mots de passe ne correspondent pas")),
      );
      return;
    }

    final String name = nameController.text;
    final String email = emailController.text;
    final String password = passwordController.text;

    if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
        .hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez entrer un email valide")),
      );
      return;
    }

    final Map<String, String> data = {
      'name': name,
      'email': email,
      'password': password,
    };

    // Affiche l'indicateur de chargement
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    try {
      final response = await http.post(
        Uri.parse("http://192.168.100.2/flutterback/register2.php"),
        headers: {"Content-Type": "application/json"},
        body: json.encode(data),
      );

      Navigator.of(context).pop(); // Ferme l'indicateur de chargement

      print("Réponse du serveur : ${response.body}");
      print("Statut HTTP : ${response.statusCode}");

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Inscription réussie")),
        );
        navigateToWelcomeScreen();
      } else if (response.statusCode == 409) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Email déjà utilisé")),
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
          onPressed: navigateToWelcomeScreen, // Retour à la page WelcomeScreen
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
                      "Créer un compte",
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
                      "Inscrivez-vous pour commencer",
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: "Nom",
                      labelStyle: const TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.green),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
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
                  const SizedBox(height: 20),
                  TextField(
                    controller: confirmPasswordController,
                    decoration: InputDecoration(
                      labelText: "Confirmer le mot de passe",
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
                        backgroundColor: Colors.black, // Même couleur que login
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: registerUser,
                      child: const Text(
                        "S'inscrire",
                        style: TextStyle(fontSize: 18, color: Colors.white),
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
