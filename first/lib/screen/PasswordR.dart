import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';

// Import des pages nécessaires
import 'login.dart'; // Assurez-vous que login.dart est dans le bon dossier
import 'confirmation_form.dart';

class PasswordR extends StatefulWidget {
  const PasswordR({super.key});

  @override
  _PasswordRState createState() => _PasswordRState();
}

class _PasswordRState extends State<PasswordR> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _sendPasswordReset() async {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text;
      final url = Uri.parse(
          'http://10.0.2.2/flutterback/recover_password.php'); // Remplace par l'URL de ton API PHP

      try {
        final response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({"email": email}),
        );

        final responseData = jsonDecode(response.body);

        if (responseData["success"]) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(responseData["message"])),
          );

          // Redirection vers la page contenant le formulaire
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ConfirmationForm()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(responseData["message"])),
          );
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Erreur de connexion")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 160, 189, 159),
        title: Text("Récupération de mot de passe",
            style: GoogleFonts.robotoCondensed(
              color: Colors.white,
            )),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Retour à la page Login
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Loginscreen()),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: UnderlineInputBorder(
                    // Bordure en bas uniquement
                    borderSide: BorderSide(
                      color: Colors.grey, // Couleur de la bordure
                    ),
                  ),
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un email';
                  }
                  if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                    return 'Veuillez entrer un email valide';
                  }
                  return null;
                },
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _sendPasswordReset,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 0, 128, 113),
                ),
                child: Text(
                  'Envoyer un code de confirmation',
                  style: GoogleFonts.robotoCondensed(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
