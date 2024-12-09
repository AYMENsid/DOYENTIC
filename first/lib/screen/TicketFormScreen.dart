import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
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

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final url = Uri.parse(
          'http://10.0.2.2/flutterback/ticketinfo.php'); // Remplace par l'URL de ton API PHP

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

        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);

          if (responseData["success"]) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(responseData["message"])),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(responseData["error"] ??
                      "Une erreur s'est produite. Veuillez réessayer.")),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Erreur côté serveur.")),
          );
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Erreur de connexion.")),
        );
      }
    }
  }

  Future<void> _generateAndPreviewPDF() async {
    Future<void> _generateAndPreviewPDF() async {
      final pdf = pw.Document();

      // Charger une image
      final logo = await imageFromAssetBundle('images/mca.png');

      pdf.addPage(
        pw.Page(
          build: (context) {
            return pw.Container(
              decoration: pw.BoxDecoration(
                gradient: pw.LinearGradient(
                  colors: [PdfColors.lightBlue, PdfColors.blue],
                ),
              ),
              child: pw.Padding(
                padding: const pw.EdgeInsets.all(16.0),
                child: pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    // Ajouter une image
                    pw.Center(
                      child: pw.Image(logo, width: 100, height: 100),
                    ),
                    pw.SizedBox(height: 20),

                    // Titre stylisé
                    pw.Text(
                      "Votre Ticket",
                      style: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.red,
                      ),
                    ),
                    pw.Divider(color: PdfColors.white),

                    // Contenu avec styles
                    pw.Text(
                      "Nom : ${_nameController.text}",
                      style: pw.TextStyle(fontSize: 16, color: PdfColors.red),
                    ),
                    pw.Text(
                      "Email : ${_emailController.text}",
                      style: pw.TextStyle(fontSize: 16, color: PdfColors.red),
                    ),
                    pw.Text(
                      "Événement : ${_eventController.text}",
                      style: pw.TextStyle(fontSize: 16, color: PdfColors.red),
                    ),
                    pw.Text(
                      "Date : ${_dateController.text}",
                      style: pw.TextStyle(fontSize: 16, color: PdfColors.red),
                    ),
                    pw.SizedBox(height: 20),

                    // QR Code centré
                    pw.Center(
                      child: pw.Container(
                        width: 150,
                        height: 150,
                        child: pw.BarcodeWidget(
                          barcode: pw.Barcode.qrCode(),
                          data:
                              "${_nameController.text}|${_emailController.text}|${_eventController.text}|${_dateController.text}",
                          drawText: false,
                        ),
                      ),
                    ),

                    pw.SizedBox(height: 10),
                    pw.Text(
                      "Scannez le QR Code à l'entrée de l'événement.",
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(color: PdfColors.red),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );

      // Afficher le PDF dans une vue ou l'imprimer
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
      );
    }

    final pdf = pw.Document();

    final name = _nameController.text;
    final email = _emailController.text;
    final event = _eventController.text;
    final date = _dateController.text;

    final ticketData =
        "Nom : $name\nEmail : $email\nÉvénement : $event\nDate : $date";

    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.Text("Votre Ticket",
                  style: pw.TextStyle(
                      fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.Text(ticketData, textAlign: pw.TextAlign.center),
              pw.SizedBox(height: 20),
              pw.Center(
                child: pw.Container(
                  width: 150,
                  height: 150,
                  child: pw.BarcodeWidget(
                    barcode: pw.Barcode.qrCode(),
                    data: "$name|$email|$event|$date",
                    drawText: false,
                  ),
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text("Scannez le QR Code à l'entrée de l'événement."),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulaire de Ticket'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nom complet'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre nom.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre email.';
                  } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Veuillez entrer un email valide.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _eventController,
                decoration: const InputDecoration(labelText: 'Événement'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le nom de l’événement.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _dateController,
                decoration:
                    const InputDecoration(labelText: 'Date (JJ/MM/AAAA)'),
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une date.';
                  } else if (!RegExp(r'^\d{2}/\d{2}/\d{4}$').hasMatch(value)) {
                    return 'Veuillez entrer une date valide (JJ/MM/AAAA).';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _submitForm();
                    _generateAndPreviewPDF();
                  }
                },
                child: const Text('Générer le ticket'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
