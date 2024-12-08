import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

class ArticleDetails extends StatefulWidget {
  final String articleId;

  ArticleDetails({required this.articleId});

  @override
  _ArticleDetailsState createState() => _ArticleDetailsState();
}

class _ArticleDetailsState extends State<ArticleDetails> {
  late Future<Map<String, dynamic>> articleData;

  @override
  void initState() {
    super.initState();
    articleData = fetchArticleDetails(widget.articleId);
  }

  Future<Map<String, dynamic>> fetchArticleDetails(String articleId) async {
    final url =
        Uri.parse('http://10.0.2.2/flutterback/ArticleById.php?id=$articleId');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data;
    } else {
      throw Exception(
          'Erreur lors de la récupération de l\'article: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
        future: articleData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Erreur: ${snapshot.error}',
                style: TextStyle(color: Colors.black),
              ),
            );
          } else if (snapshot.hasData) {
            final data = snapshot.data!;
            final title = data['title'] ?? 'Titre non disponible';
            final imageUrl = data['image'] ?? 'assets/images/default_image.png';
            final description =
                data['subtitle'] ?? 'Pas de description fournie.';
            return CustomScrollView(
              slivers: [
                // AppBar avec l'image
                SliverAppBar(
                  expandedHeight: MediaQuery.of(context).size.height * 0.4,
                  floating: false,
                  pinned: true,
                  backgroundColor: const Color.fromARGB(255, 160, 189, 159),
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: Padding(
                      padding:
                          const EdgeInsets.only(left: 10.0), // Marge à gauche
                      child: Text(
                        title,
                        style: GoogleFonts.cairo(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    background: imageUrl.startsWith('http')
                        ? Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            imageUrl,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                // Contenu défilable
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Sous-titre (description)
                        Text(
                          description,
                          style: GoogleFonts.cairo(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 20),
                        // Contenu principal
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Center(
              child: Text(
                'Aucune donnée disponible',
                style: TextStyle(color: Colors.black),
              ),
            );
          }
        },
      ),
    );
  }
}
