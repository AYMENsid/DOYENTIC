import 'dart:convert';
import 'package:first/screen/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:google_fonts/google_fonts.dart';
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
          'http://192.168.246.51/flutterback/ticketinfo.php'); // 10.0.2.2 sur emulateur
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
        'http://192.168.246.51/flutterback/TicDispo.php'; // 10.0.2.2 sur emulateur
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
                  //decoration: pw.BoxDecoration(
                  // border: pw.Border.all(width: 2),
                  // ),
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
                              fontSize: 28, fontWeight: pw.FontWeight.normal)),
                      pw.Text("Porte : Toutes les portes ",
                          style: pw.TextStyle(
                              fontSize: 28, fontWeight: pw.FontWeight.normal)),
                      pw.Text("Stade : Ali-Ammar 'La pointe'",
                          style: pw.TextStyle(
                              fontSize: 28, fontWeight: pw.FontWeight.normal)),
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
        title: Text(
          'Formulaire de Ticket',
          style: const TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
            fontSize: 19,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      HomeScreen()), // Remplacez par l'écran vers lequel vous voulez revenir.
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Texte d'introduction avec style amélioré
              Text(
                "Bienvenue dans le formulaire de ticket. Veuillez remplir les informations ci-dessous pour générer votre ticket.",
                style: GoogleFonts.cairo(
                  fontSize: 23,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 20),

              // Engagements avec des styles distincts
              Text(
                "- Je m'engage à préserver les biens publics et les installations présentes dans le stade .",
                style: GoogleFonts.cairo(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey),
              ),
              Text(
                "- Je m'engage à respecter l'interdiction d'introduire tout objet dangereux dans le stade .",
                style: GoogleFonts.cairo(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey),
              ),
              Text(
                "- Je m'engage à respecter les autres supporters et les participants .",
                style: GoogleFonts.cairo(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey),
              ),
              Text(
                "- Je m'engage à respecter les règles de conduite et les lois en vigueur dans le stade . ",
                style: GoogleFonts.cairo(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey),
              ),
              const SizedBox(height: 20),

              // Card pour le formulaire
              Card(
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
                        // Affichage des tickets disponibles
                        _InfosTicket.isNotEmpty
                            ? Text(
                                '   Tickets disponibles: ${_InfosTicket.first['ticnbr']} / ${_InfosTicket.first['TotalTicket']}',
                                style: GoogleFonts.cairo(
                                    fontSize: 19,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black),
                              )
                            : Text(
                                'Aucun ticket disponible',
                                style: TextStyle(fontSize: 18),
                              ),
                        const SizedBox(height: 20),

                        // Champs du formulaire
                        _buildTextField(
                          controller: _nameController,
                          label: 'Nom complet',
                          icon: Icons.person,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _emailController,
                          label: 'Email',
                          icon: Icons.email,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _numController,
                          label: 'Numéro téléphone',
                          icon: Icons.phone,
                        ),
                        const SizedBox(height: 16),
                        _buildDateField(
                          controller: _dateController,
                          label: 'Date de naissance',
                          icon: Icons.calendar_today,
                        ),
                        const SizedBox(height: 20),

                        // Bouton de soumission
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              side: const BorderSide(color: Colors.green),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                await _submitForm();
                                await _generateAndPreviewPDF();
                              }
                            },
                            child: Text(
                              'Générer le ticket',
                              style: GoogleFonts.cairo(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
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

// Méthode pour un texte d'engagement avec un style uniforme
  Widget _buildEngagementText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.black54,
        ),
      ),
    );
  }

// Méthode pour générer un champ de texte standard
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(),
      ),
    );
  }

// Méthode pour générer un champ de sélection de date
  Widget _buildDateField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
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
          controller.text = DateFormat('dd/MM/yyyy').format(pickedDate);
        }
      },
    );
  }
}
