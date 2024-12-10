import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class TicketFormScreen extends StatefulWidget {
  const TicketFormScreen({super.key});
  @override
  _TicketFormScreenState createState() => _TicketFormScreenState();
}

class _TicketFormScreenState extends State<TicketFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _eventController = TextEditingController();
  final _dateController = TextEditingController();
  bool _isLoading = false;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final url = Uri.parse('http://10.0.2.2/flutterback/ticketinfo.php');

      try {
        final response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "nom": _nameController.text,
            "email": _emailController.text,
            "date_naissance": _dateController.text,
            "event": _eventController.text,
          }),
        );

        final responseData = jsonDecode(response.body);
        final message = responseData["success"]
            ? responseData["message"]
            : responseData["error"] ?? "Une erreur s'est produite.";
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Erreur de connexion.")),
        );
      }
    }
  }

  Future<void> _generateAndPreviewPDF() async {
    final pdf = pw.Document();

    final name = _nameController.text;
    final email = _emailController.text;
    final event = _eventController.text;
    final date = _dateController.text;

    final ticketData =
        "Nom : $name\nEmail : $email\nÉvénement : $event\nDate : $date";

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.center,
          children: [
            pw.Text("Votre Ticket", style: pw.TextStyle(fontSize: 20)),
            pw.SizedBox(height: 20),
            pw.Text(ticketData),
            pw.SizedBox(height: 20),
            pw.BarcodeWidget(
              barcode: pw.Barcode.qrCode(),
              data: "$name|$email|$event|$date",
              width: 100,
              height: 100,
            ),
          ],
        ),
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 160, 189, 159),
        title: const Text('Formulaire de Ticket'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('HomeScreen');
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Nom complet',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Veuillez entrer votre nom.'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer votre email.';
                        } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                            .hasMatch(value)) {
                          return 'Veuillez entrer un email valide.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _eventController,
                      decoration: InputDecoration(
                        labelText: 'Événement',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Veuillez entrer un événement.'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _dateController,
                      decoration: InputDecoration(
                        labelText: 'Date (JJ/MM/AAAA)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onTap: () async {
                        FocusScope.of(context).requestFocus(FocusNode());
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          _dateController.text =
                              DateFormat('dd/MM/yyyy').format(pickedDate);
                        }
                      },
                      validator: (value) => value == null || value.isEmpty
                          ? 'Veuillez entrer une date.'
                          : null,
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: _isLoading
                            ? null
                            : () async {
                                setState(() {
                                  _isLoading = true;
                                });
                                if (_formKey.currentState!.validate()) {
                                  await _submitForm();
                                  await _generateAndPreviewPDF();
                                }
                                setState(() {
                                  _isLoading = false;
                                });
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 160, 189, 159),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 15,
                          ),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : const Text('Générer le ticket'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
