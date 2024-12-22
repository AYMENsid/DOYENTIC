import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';

class ConfirmationForm extends StatelessWidget {
  const ConfirmationForm({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController codeController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController confirmPasswordController =
        TextEditingController();

    final _formKey = GlobalKey<FormState>();

    Future<void> _submitForm() async {
      if (_formKey.currentState!.validate()) {
        String email = emailController.text;
        String code = codeController.text;
        String newPassword = passwordController.text;

        final url = Uri.parse(
            'http://192.168.246.51/flutterback/reset_password.php'); // Remplace par l'URL de ton API PHP

        try {
          final response = await http.post(
            url,
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({
              "email": email,
              "code": code,
              "new_password": newPassword,
            }),
          );

          final responseData = jsonDecode(response.body);

          if (responseData["success"]) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(responseData["message"])),
            );
            // Rediriger ou afficher un message de succès
          } else {
            Navigator.of(context).pushReplacementNamed('Loginscreen');
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

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 160, 189, 159),
        title: Text(
          "Définir un nouveau mot de passe",
          style: GoogleFonts.robotoCondensed(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              TextFormField(
                controller: emailController,
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
                    return 'Veuillez entrer votre email';
                  }
                  if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                    return 'Veuillez entrer un email valide';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: codeController,
                decoration: const InputDecoration(
                  labelText: 'Code de confirmation',
                  border: UnderlineInputBorder(
                    // Bordure en bas uniquement
                    borderSide: BorderSide(
                      color: Colors.grey, // Couleur de la bordure
                    ),
                  ),
                  prefixIcon: Icon(Icons.confirmation_number),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le code de confirmation';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'Nouveau mot de passe',
                  border: UnderlineInputBorder(
                    // Bordure en bas uniquement
                    borderSide: BorderSide(
                      color: Colors.grey, // Couleur de la bordure
                    ),
                  ),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un mot de passe';
                  }
                  if (value.length < 6) {
                    return 'Le mot de passe doit contenir au moins 6 caractères';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: confirmPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Confirmer le mot de passe',
                  border: UnderlineInputBorder(
                    // Bordure en bas uniquement
                    borderSide: BorderSide(
                      color: Colors.grey, // Couleur de la bordure
                    ),
                  ),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez confirmer votre mot de passe';
                  }
                  if (value != passwordController.text) {
                    return 'Les mots de passe ne correspondent pas';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 0, 128, 113),
                ),
                child: Text(
                  'Soumettre',
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
