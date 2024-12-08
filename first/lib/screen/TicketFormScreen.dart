import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulaire de Ticket'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nom complet'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre nom.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre email.';
                  } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Veuillez entrer un email valide.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _eventController,
                decoration: InputDecoration(labelText: 'Événement'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le nom de l’événement.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _dateController,
                decoration: InputDecoration(labelText: 'Date (JJ/MM/AAAA)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer la date de l’événement.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _generateAndPreviewPDF();
                  }
                },
                child: Text('Générer le ticket'),
              ),
            ],
          ),
        ),
      ),
    );
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
}
