import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  List<dynamic> _InfosTicket = [];
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _numController = TextEditingController();
  final _dateController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _TicDispo(); // Appel pour récupérer les tickets au démarrage
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final url = Uri.parse(
          'http://192.168.100.2/flutterback/ticketinfo.php'); // 10.0.2.2 sur emulateur
      try {
        final response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "nom": _nameController.text,
            "email": _emailController.text,
            "date_naissance": _dateController.text,
            "event": _numController.text,
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

  Future<void> _TicDispo() async {
    final url =
        'http://192.168.100.2/flutterback/TicDispo.php'; // 10.0.2.2 sur emulateur
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _InfosTicket = data['data'] is List ? data['data'] : [];
        });
      } else {
        setState(() {
          _InfosTicket = [];
        });
      }
    } catch (e) {
      setState(() {
        _InfosTicket = [];
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _generateAndPreviewPDF() async {
    final pdf = pw.Document();

    final name = _nameController.text;
    final email = _emailController.text;
    final num = _numController.text;
    final date = _dateController.text;

    // Charger l'image d'arrière-plan depuis les assets
    final imageBytes = await rootBundle.load('images/tikii.jpg');
    final backgroundImage = pw.MemoryImage(imageBytes.buffer.asUint8List());

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Stack(
            children: [
              // Arrière-plan
              pw.Positioned.fill(
                child: pw.Image(backgroundImage, fit: pw.BoxFit.cover),
              ),
              // Contenu du ticket
              pw.Center(
                child: pw.Container(
                  padding: pw.EdgeInsets.all(20),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(width: 2),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      pw.Text("Ticket de match",
                          style: pw.TextStyle(
                              fontSize: 40, fontWeight: pw.FontWeight.bold)),
                      pw.SizedBox(height: 20),
                      pw.Text("Nom : $name",
                          style: pw.TextStyle(
                              fontSize: 28, fontWeight: pw.FontWeight.bold)),
                      pw.Text("Porte : Toutes les portes ",
                          style: pw.TextStyle(
                              fontSize: 28, fontWeight: pw.FontWeight.bold)),
                      pw.Text("Stade : Ali-Ammar 'La pointe'",
                          style: pw.TextStyle(
                              fontSize: 28, fontWeight: pw.FontWeight.bold)),
                      // pw.Text("Date : $date",
                      //  style: pw.TextStyle(
                      //     fontSize: 28, fontWeight: pw.FontWeight.bold)),
                      pw.SizedBox(height: 20),
                      pw.BarcodeWidget(
                        barcode: pw.Barcode.qrCode(),
                        data: "$name|$email|$num|$date",
                        width: 100,
                        height: 100,
                      ),
                      pw.SizedBox(height: 15),
                      pw.Text("Merci d'avoir participé !",
                          style: pw.TextStyle(
                              fontSize: 30, fontWeight: pw.FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
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
                    _InfosTicket.isNotEmpty
                        ? Text(
                            'Tickets disponibles: ${_InfosTicket.first['ticnbr']} / ${_InfosTicket.first['TotalTicket']}',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          )
                        : Text('Aucun ticket disponible',
                            style: TextStyle(fontSize: 18)),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Nom complet',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _numController,
                      decoration: InputDecoration(
                        labelText: 'Numero téléphone',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _dateController,
                      decoration: InputDecoration(
                        labelText: 'Date de naissance ',
                        border: OutlineInputBorder(),
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
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await _submitForm();
                            await _generateAndPreviewPDF();
                          }
                        },
                        child: const Text('Générer le ticket'),
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
