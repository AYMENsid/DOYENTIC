import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BuyStoreScreen extends StatefulWidget {
  final String productName;
  final String productImageUrl;

  const BuyStoreScreen({
    Key? key,
    required this.productName,
    required this.productImageUrl,
  }) : super(key: key);

  @override
  State<BuyStoreScreen> createState() => _BuyStoreScreenState();
}

class _BuyStoreScreenState extends State<BuyStoreScreen> {
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  String? _selectedSize;

  Future<void> submitOrder() async {
    // Vérifier si tous les champs sont remplis
    if (_fullNameController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _addressController.text.isEmpty) {
      _showError('Veuillez remplir tous les champs.');
      return;
    }

    // Vérifier si une taille a été choisie
    if (_selectedSize == null) {
      _showError('Merci de choisir votre taille.');
      return;
    }

    const String url =
        'http://10.0.2.2/flutterback/add_order.php'; // URL de votre script PHP
    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "productName": widget.productName,
        "productImageUrl": widget.productImageUrl,
        "fullName": _fullNameController.text,
        "phone": _phoneController.text,
        "email": _emailController.text,
        "address": _addressController.text,
        "size": _selectedSize,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data["success"]) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Commande confirmée'),
            content:
                const Text('Votre commande a été enregistrée avec succès.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        _showError(data["message"]);
      }
    } else {
      _showError('Erreur lors de l\'envoi de la commande.');
    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Erreur'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Commander - ${widget.productName}'),
        backgroundColor: const Color.fromARGB(255, 160, 189, 159),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Affichage de l'image et des tailles
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image du produit
                  Container(
                    width: 270,
                    height: 270,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: AssetImage(widget.productImageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Boutons pour choisir la taille
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Choisissez une taille',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: ['S', 'M', 'L', 'XL', 'XXL']
                              .map(
                                (size) => ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _selectedSize == size
                                        ? Colors.green
                                        : Colors.grey.shade300,
                                    foregroundColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _selectedSize = size;
                                    });
                                  },
                                  child: Text(size),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Autres champs du formulaire
              const Text('Nom complet',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: _fullNameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Entrez votre nom complet',
                ),
              ),
              const SizedBox(height: 16),

              const Text('Numéro de téléphone',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Entrez votre numéro de téléphone',
                ),
              ),
              const SizedBox(height: 16),

              const Text('Adresse email',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Entrez votre adresse email',
                ),
              ),
              const SizedBox(height: 16),

              const Text('Adresse de la maison',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: _addressController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Entrez votre adresse de livraison',
                ),
              ),
              const SizedBox(height: 24),

              const Center(
                child: Text(
                  'Le paiement se fait à la livraison.',
                  style: TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey),
                ),
              ),
              const SizedBox(height: 24),

              // Bouton de confirmation
              Center(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 57, 88, 55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                    ),
                    onPressed: submitOrder,
                    child: const Text(
                      'Confirmer la commande',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
