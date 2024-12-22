import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:first/screen/ArticleDetaills.dart';
import 'product_details.dart';
import 'buystore.dart';
import 'package:photo_view/photo_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomeScreen> {
  late Future<List<Product>> _products;
  String _searchQuery = "";

  int _selectedBottomIndex = 0; // Indice de la bottom bar
  String _selectedSport = 'Football'; // Sport sélectionné dans le drawer
  bool _isLoading = false; // Indicateur de chargement des données
  List<dynamic> _basketballArticles =
      []; // Liste d'articles BASKETBALL récupérés
  List<dynamic> _footballArticles = []; // Liste d'articles FOOTBALL récupérés
  List<dynamic> _VolleyballArticles = []; // Liste d'articles Volley récupérés
  List<dynamic> _HandballArticles = []; // Liste d'articles Handball récupérés
  List<dynamic> _footballMatch = []; // Liste d'articles FOOTBALL récupérés

  /////////////////////////////////////////////////////////////////////////
  ////
  ///
  /// // Méthode pour charger les produits
  Future<List<Product>> fetchProducts() async {
    const String url = 'http://192.168.246.51/flutterback/get_products.php';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Product.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  // Méthode pour récupérer les match du FOOTBALL via l'API
  Future<void> _fetchInfoMatchs() async {
    final url =
        'http://192.168.246.51/flutterback/footballmatch.php'; // // 10.0.2.2 sur emulateur
    setState(() {
      _isLoading = true;
    });

    final response = await http.get(Uri.parse(url + '?sport=$_selectedSport'));

    if (response.statusCode == 200) {
      try {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          if (data.isNotEmpty) {
            _footballMatch = data;
          } else {
            _footballMatch = [];
          }
          _isLoading = false;
        });
      } catch (e) {
        setState(() {
          _footballMatch = [];
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _footballMatch = [];
        _isLoading = false;
      });
    }
  }

  // Méthode pour récupérer les infos du BASKETBALL via l'API
  Future<void> _fetchSportInfo() async {
    final url =
        'http://192.168.246.51/flutterback/basketballarticle.php'; // Remplacez par l'URL de votre API
    setState(() {
      _isLoading = true;
    });

    final response = await http.get(Uri.parse(url + '?sport=$_selectedSport'));

    if (response.statusCode == 200) {
      try {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          if (data.isNotEmpty) {
            _basketballArticles = data;
          } else {
            _basketballArticles = [];
          }
          _isLoading = false;
        });
      } catch (e) {
        setState(() {
          _basketballArticles = [];
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _basketballArticles = [];
        _isLoading = false;
      });
    }
  }

  ////
  // Méthode pour récupérer les infos du Handball via l'API
  Future<void> _fetchSportHInfo() async {
    final url =
        'http://192.168.246.51/flutterback/handballarticle.php'; // Remplacez par l'URL de votre API
    setState(() {
      _isLoading = true;
    });

    final response = await http.get(Uri.parse(url + '?sport=$_selectedSport'));

    if (response.statusCode == 200) {
      try {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          if (data.isNotEmpty) {
            _HandballArticles = data;
          } else {
            _HandballArticles = [];
          }
          _isLoading = false;
        });
      } catch (e) {
        setState(() {
          _HandballArticles = [];
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _HandballArticles = [];
        _isLoading = false;
      });
    }
  } ////

  // Méthode pour récupérer les infos du Volley via l'API
  Future<void> _fetchSportVInfo() async {
    final url =
        'http://192.168.246.51/flutterback/volleyballarticle.php'; // Remplacez par l'URL de votre API
    setState(() {
      _isLoading = true;
    });

    final response = await http.get(Uri.parse(url + '?sport=$_selectedSport'));

    if (response.statusCode == 200) {
      try {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          if (data.isNotEmpty) {
            _VolleyballArticles = data;
          } else {
            _VolleyballArticles = [];
          }
          _isLoading = false;
        });
      } catch (e) {
        setState(() {
          _VolleyballArticles = [];
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _VolleyballArticles = [];
        _isLoading = false;
      });
    }
  }

  // Méthode pour récupérer les infos du FOOTBALL via l'API
  Future<void> _fetchSportFInfo() async {
    final url =
        'http://192.168.246.51/flutterback/footballarticle.php'; // Remplacez par l'URL de votre API
    setState(() {
      _isLoading = true;
    });

    final response = await http.get(Uri.parse(url + '?sport=$_selectedSport'));

    if (response.statusCode == 200) {
      try {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          if (data.isNotEmpty) {
            _footballArticles = data;
          } else {
            _footballArticles = [];
          }
          _isLoading = false;
        });
      } catch (e) {
        setState(() {
          _footballArticles = [];
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _footballArticles = [];
        _isLoading = false;
      });
    }
  }

  // Options pour le contenu principal en fonction de la bottom bar et du sport
  static const Map<String, Map<int, String>> _content = {
    'Handball': {
      0: 'Accueil - Handball',
      1: 'Boutique - Handball',
      2: 'Matchs - Handball',
      3: 'Infos - Handball',
    },
    'Basketball': {
      0: 'Accueil - Basketball',
      1: 'Boutique - Basketball',
      2: 'Matchs - Basketball',
      3: 'Infos - Basketball',
    },
    'Volley-ball': {
      0: 'Accueil - Volley-ball',
      1: 'Boutique - Volley-ball',
      2: 'Matchs - Volley-ball',
      3: 'Infos - Volley-ball',
    },
    'Football': {
      0: 'Accueil - Football',
      1: 'Boutique - Football',
      2: 'Matchs - Football',
      3: 'Infos - Football',
    },
  };
//METHODE DE DECONNEXION
  void deconnexion() {
    Navigator.of(context).pushReplacementNamed('Loginscreen');
  }

  void ToFormMatch() {
    Navigator.of(context).pushReplacementNamed('TicketFormScreen');
  }

//METHODE ARTICLE TAPER
  void ArticleDetaills() {
    Navigator.of(context).pushReplacementNamed('Loginscreen');
  }

  // Méthode appelée lorsqu'un élément de la bottom bar est sélectionné
  void _onBottomBarTapped(int index) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    _selectedBottomIndex = args?['_selectedBottomIndex'] ?? 0;
    setState(() {
      _selectedBottomIndex = index;
      // Charger les infos quand l'onglet "Infos" est sélectionné
      if (index == 3 && _selectedSport == 'Basketball') {
        _fetchSportInfo();
        // Charger les infos sportives BASKET
      }
      if (index == 3 && _selectedSport == 'Football') {
        _fetchSportFInfo();
        // Charger les infos sportives FOOT
      }
      if (index == 3 && _selectedSport == 'Handball') {
        _fetchSportHInfo();
        // Charger les infos sportives Handball
      }
      if (index == 3 && _selectedSport == 'Volley-ball') {
        _fetchSportVInfo();
        // Charger les infos sportives Volley
      }
      if (index == 2 && _selectedSport == 'Football') {
        _fetchInfoMatchs();
        // Charger les infos sportives Volley
      }
      if (index == 1) {
        _products = fetchProducts();
        //Navigator.of(context).pushReplacementNamed('StoreScreen');
        // Charger les infos sportives Volley
      }
    });
  }

  // Méthode appelée lorsqu'une option du drawer est sélectionnée
  void _onDrawerOptionTapped(String sport) {
    setState(() {
      _selectedSport = sport;
    });
    Navigator.pop(context); // Ferme le drawer
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 160, 189, 159),
        title: Text(
          "$_selectedSport - Mouloudia d'Alger",
          style: const TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
            fontSize: 19,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      body: SafeArea(
        child: Center(
          child: _getContent(),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 160, 189, 159),
              ),
              child: Text(
                "Sections sportives",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            ListTile(
              title: const Text('Football'),
              selected: _selectedSport == 'Football',
              onTap: () => _onDrawerOptionTapped('Football'),
            ),
            ListTile(
              title: const Text('Handball'),
              selected: _selectedSport == 'Handball',
              onTap: () => _onDrawerOptionTapped('Handball'),
            ),
            ListTile(
              title: const Text('Basketball'),
              selected: _selectedSport == 'Basketball',
              onTap: () => _onDrawerOptionTapped('Basketball'),
            ),
            ListTile(
              title: const Text('Volley-ball'),
              selected: _selectedSport == 'Volley-ball',
              onTap: () => _onDrawerOptionTapped('Volley-ball'),
            ),
            ListTile(
              title: const Text('Deconnecter'),
              selected: _selectedSport == 'Deconnecter',
              onTap: () => deconnexion(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: 'Boutique',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_soccer),
            label: 'Matchs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: 'Infos',
          ),
        ],
        currentIndex: _selectedBottomIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        onTap: _onBottomBarTapped,
      ),
    );
  }

  // Affichage des articles de FOOTBALL
  Widget _buildFootballInfo() {
    return SingleChildScrollView(
      child: Column(
        children: _footballArticles.map((article) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ArticleDetails(articleId: article['id'].toString()),
                ),
              );
            },
            child: Card(
              margin: const EdgeInsets.only(
                  bottom: 16.0, right: 16, left: 16, top: 16),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Column(
                children: [
                  // Image en haut
                  Container(
                    width: double.infinity,
                    height: 220, // Augmente la hauteur pour un effet plus grand
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12.0),
                        topRight: Radius.circular(12.0),
                      ),
                      image: DecorationImage(
                        image: article['image'] != null
                            ? AssetImage(article['image'])
                            : const AssetImage(
                                'assets/images/default_image.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Contenu en bas (titre et sous-titre)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          article['title'] ?? 'Titre non disponible',
                          style: const TextStyle(
                            fontSize: 22, // Texte légèrement plus grand
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

// Affichage des articles de VolleyBall
  Widget _buildVolleyballInfo() {
    return SingleChildScrollView(
      child: Column(
        children: _VolleyballArticles.map((article) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ArticleDetails(articleId: article['id'].toString()),
                ),
              );
            },
            child: Card(
              margin: const EdgeInsets.only(
                  bottom: 16.0, right: 16, left: 16, top: 16),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Column(
                children: [
                  // Image en haut
                  Container(
                    width: double.infinity,
                    height: 220, // Augmente la hauteur pour un effet plus grand
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12.0),
                        topRight: Radius.circular(12.0),
                      ),
                      image: DecorationImage(
                        image: article['image'] != null
                            ? AssetImage(article['image'])
                            : const AssetImage(
                                'assets/images/default_image.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Contenu en bas (titre et sous-titre)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          article['title'] ?? 'Titre non disponible',
                          style: const TextStyle(
                            fontSize: 22, // Texte légèrement plus grand
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

// Affichage des articles de HANDBALL
  Widget _buildHandballInfo() {
    return SingleChildScrollView(
      child: Column(
        children: _HandballArticles.map((article) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ArticleDetails(articleId: article['id'].toString()),
                ),
              );
            },
            child: Card(
              margin: const EdgeInsets.only(
                  bottom: 16.0, right: 16, left: 16, top: 16),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Column(
                children: [
                  // Image en haut
                  Container(
                    width: double.infinity,
                    height: 220, // Augmente la hauteur pour un effet plus grand
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12.0),
                        topRight: Radius.circular(12.0),
                      ),
                      image: DecorationImage(
                        image: article['image'] != null
                            ? AssetImage(article['image'])
                            : const AssetImage(
                                'assets/images/default_image.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Contenu en bas (titre et sous-titre)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          article['title'] ?? 'Titre non disponible',
                          style: const TextStyle(
                            fontSize: 22, // Texte légèrement plus grand
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // Affichage des articles de basketball
  Widget _buildBasketballInfo() {
    return SingleChildScrollView(
      child: Column(
        children: _basketballArticles.map((article) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ArticleDetails(articleId: article['id'].toString()),
                ),
              );
            },
            child: Card(
              margin: const EdgeInsets.only(
                  bottom: 16.0, right: 16, left: 16, top: 16),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Column(
                children: [
                  // Image en haut
                  Container(
                    width: double.infinity,
                    height: 220, // Augmente la hauteur pour un effet plus grand
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12.0),
                        topRight: Radius.circular(12.0),
                      ),
                      image: DecorationImage(
                        image: article['image'] != null
                            ? AssetImage(article['image'])
                            : const AssetImage(
                                'assets/images/default_image.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Contenu en bas (titre et sous-titre)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          article['title'] ?? 'Titre non disponible',
                          style: const TextStyle(
                            fontSize: 22, // Texte légèrement plus grand
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

// POUR AFFICHER LES MATCH DU FOOT /
  Widget _buildFootballMatch() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: _footballMatch.map((match) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Présentation spécifique du match
              Text(
                'Présentation du match :',
                style: GoogleFonts.cairo(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                match['presentation'] ?? 'Aucune présentation disponible.',
                style: GoogleFonts.cairo(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              // Carte du match
              Card(
                margin: const EdgeInsets.only(bottom: 16.0),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Ligne supérieure (Type et heure)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            match['type'] ?? 'Football • Equipe sénior',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            match['heur'] ?? '24 Jul - 04:10',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Score et noms des équipes
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Équipe A
                          Column(
                            children: [
                              match['imageA'] != null
                                  ? Image.asset(
                                      match['imageA'],
                                      width: 40,
                                      height: 40,
                                    )
                                  : const Icon(Icons.error, size: 40),
                              const SizedBox(height: 8),
                              Text(
                                match['equipeA'] ?? 'Real Madrid',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          // Score
                          Column(
                            children: [
                              Center(
                                child: Text(
                                  'VS',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Container(
                              // padding: const EdgeInsets.symmetric(
                              //   horizontal: 12,
                              //   vertical: 4,
                              // ),
                              //  decoration: BoxDecoration(
                              //   color: Colors.blue.shade50,
                              //    borderRadius: BorderRadius.circular(12.0),
                              //  ),
                              //child: const Text(
                              //  'Full time',
                              ///  style: TextStyle(
                              //     fontSize: 12,
                              //     color: Colors.blue,
                              ////     fontWeight: FontWeight.bold,
                              //   ),
                              // ),
                              //  ),
                            ],
                          ),
                          // Équipe B
                          Column(
                            children: [
                              match['imageB'] != null
                                  ? Image.asset(
                                      match['imageB'],
                                      width: 40,
                                      height: 40,
                                    )
                                  : const Icon(Icons.error, size: 40),
                              const SizedBox(height: 8),
                              Text(
                                match['equipeB'] ?? 'Milan',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Bouton et lieu
                      Column(
                        children: [
                          ElevatedButton(
                            onPressed:
                                ToFormMatch, // Implement this function to handle navigation
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              side: const BorderSide(color: Colors.green),
                            ),
                            child: Center(
                              child: const Text(
                                'Réserver le ticket',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            match['lieu'] ?? 'Stade Ali-Ammar • Alger',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

//HOME ESSAI
  Widget _buildHomeFootball() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image principale avec zoom plein écran

            Image.asset('images/doyen.png'),

            SizedBox(height: 20),

            // Titre "La naissance du doyen"
            Text(
              "La naissance du doyen",
              style: GoogleFonts.cairo(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),

            // Texte descriptif
            Text(
              "En 1921, Abderahmane Aouf, un jeune de 19 ans, décide de créer le premier club musulman représentant l'identité musulmane algérienne, après avoir entendu les paroles moqueuses d'un soldat français envers des enfants jouant au football sur l'actuelle place des Martyrs : « Voici le Parc des Princes des Arabes. »",
              style: GoogleFonts.cairo(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 10),

            // Row des deux images avec zoom interactif en plein écran et texte en bas
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => Dialog(
                          insetPadding: EdgeInsets.zero,
                          child: Container(
                            color: Colors.black,
                            child: PhotoView(
                              imageProvider: AssetImage('images/1921.jpg'),
                              backgroundDecoration:
                                  BoxDecoration(color: Colors.black),
                            ),
                          ),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        Image.asset('images/1921.jpg',
                            height: 140, fit: BoxFit.cover),
                        SizedBox(height: 8),
                        Text('Composition 1921',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.cairo(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => Dialog(
                          insetPadding: EdgeInsets.zero,
                          child: Container(
                            color: Colors.black,
                            child: PhotoView(
                              imageProvider: AssetImage('images/aouf.jpg'),
                              backgroundDecoration:
                                  BoxDecoration(color: Colors.black),
                            ),
                          ),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        Image.asset('images/aouf.jpg',
                            height: 140, fit: BoxFit.cover),
                        SizedBox(height: 8),
                        Text('Abderahmane Aouf',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.cairo(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),
            Text(
              "Palmarès actuel :",
              style: GoogleFonts.cairo(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),

            // Autres lignes avec images et titres
            _buildRow('images/titre.png', '8', "Championnat d'Algerie"),
            _buildRow('images/titre.png', '8', "Coupe d'Algerie"),
            _buildRow('images/titre.png', '1', "Champions league"),
            _buildRow('images/titre.png', '3', "Super coupe d'Algerie"),
            _buildRow('images/titre.png', '1', "Coupe de la ligue"),
            _buildRow('images/titre.png', '2', "Championnat maghrebine"),
            _buildRow(
                'images/titre.png', '2', "Championnat d'Algerie-Francaise"),
            _buildRow('images/titre.png', '2', "Coupe d'Algerie-Francaise"),
            Image.asset('images/doyen.png'),
          ],
        ),
      ),
    );
  }

//HOME BASKETBALL
  Widget _buildHomeBasketball() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image principale avec zoom plein écran

            Image.asset('images/doyen.png'),

            SizedBox(height: 20),

            // Titre "La naissance du doyen"
            Text(
              "La naissance du section",
              style: GoogleFonts.cairo(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),

            // Texte descriptif
            Text(
              "En 1940, l'administration du Mouloudia, sous la présidence de Mouloud Djazouli, a demandé à Adoune Mahmoud avec l'aide de Assla Houcine et Bachtarzi de créer une section de basket-ball au sein du Mouloudia d'Alger. Cela a marqué la naissance d'une des nombreuses sections sportives du club, telles que la water-polo,VolleyBall, la gymnastique, la boxe, et le cyclisme.",
              style: GoogleFonts.cairo(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 10),

            // Row des deux images avec zoom interactif en plein écran et texte en bas
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => Dialog(
                          insetPadding: EdgeInsets.zero,
                          child: Container(
                            color: Colors.black,
                            child: PhotoView(
                              imageProvider:
                                  AssetImage('images/adounMahmoud.jpg'),
                              backgroundDecoration:
                                  BoxDecoration(color: Colors.black),
                            ),
                          ),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        Image.asset('images/adounMahmoud.jpg',
                            height: 140, fit: BoxFit.cover),
                        SizedBox(height: 8),
                        Text('Adoune Mahmoud',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.cairo(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => Dialog(
                          insetPadding: EdgeInsets.zero,
                          child: Container(
                            color: Colors.black,
                            child: PhotoView(
                              imageProvider: AssetImage('images/basket.jpg'),
                              backgroundDecoration:
                                  BoxDecoration(color: Colors.black),
                            ),
                          ),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        Image.asset('images/basket.jpg',
                            height: 140, fit: BoxFit.cover),
                        SizedBox(height: 8),
                        Text('Composition des années 40 ',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.cairo(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),
            Text(
              "Palmarès actuel :",
              style: GoogleFonts.cairo(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Hommes:",
              style: GoogleFonts.cairo(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),

            // Autres lignes avec images et titres
            _buildRow('images/titre.png', '21', "Championnat d'Algerie"),
            _buildRow('images/titre.png', '20', "Coupe d'Algerie"),

            _buildRow('images/titre.png', '1', "Coupe arab"),
            _buildRow('images/titre.png', '2', "Championnat maghrebine"),

            SizedBox(
              height: 10,
            ),
            Text(
              "Femmes:",
              style: GoogleFonts.cairo(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),

            // Autres lignes avec images et titres
            _buildRow('images/titre.png', '13', "Championnat d'Algerie"),
            _buildRow('images/titre.png', '6', "Coupe d'Algerie"),
            _buildRow('images/titre.png', '1', "Coupe arab"),

            Image.asset('images/doyen.png'),
          ],
        ),
      ),
    );
  }

  //home volleyball

  Widget _buildHomeVoleyball() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image principale avec zoom plein écran

            Image.asset('images/doyen.png'),

            SizedBox(height: 20),

            // Titre "La naissance du doyen"
            Text(
              "La naissance du section",
              style: GoogleFonts.cairo(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),

            // Texte descriptif
            Text(
              "Après avoir contribué au développement du basketball, Mouloud Djazouli a pris une décision cruciale pour l'histoire du sport au sein du Mouloudia Club d'Alger (MCA). En 1947, il a décidé de créer une section de volleyball pour le club. Cette initiative a marqué une diversification des activités sportives et a enrichi l'identité du MCA, en intégrant le volleyball comme une composante essentielle du club",
              style: GoogleFonts.cairo(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 10),

            // Row des deux images avec zoom interactif en plein écran et texte en bas
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => Dialog(
                          insetPadding: EdgeInsets.zero,
                          child: Container(
                            color: Colors.black,
                            child: PhotoView(
                              imageProvider: AssetImage('images/djazouli.jpg'),
                              backgroundDecoration:
                                  BoxDecoration(color: Colors.black),
                            ),
                          ),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        Image.asset('images/djazouli.jpg',
                            height: 140, fit: BoxFit.cover),
                        SizedBox(height: 8),
                        Text('Mouloud Djazouli',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.cairo(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
              ],
            ),

            SizedBox(height: 20),
            Text(
              "Palmarès actuel :",
              style: GoogleFonts.cairo(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Hommes:",
              style: GoogleFonts.cairo(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),

            // Autres lignes avec images et titres
            _buildRow('images/titre.png', '10', "Championnat d'Algerie"),
            _buildRow('images/titre.png', '13', "Coupe d'Algerie"),

            _buildRow('images/titre.png', '2', "Champions league"),

            SizedBox(
              height: 10,
            ),
            Text(
              "Femmes:",
              style: GoogleFonts.cairo(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),

            // Autres lignes avec images et titres
            _buildRow('images/titre.png', '23', "Championnat d'Algerie"),
            _buildRow('images/titre.png', '29', "Coupe d'Algerie"),
            _buildRow('images/titre.png', '1', "Champions league"),
            _buildRow('images/titre.png', '1', "Coupe arab"),

            Image.asset('images/doyen.png'),
          ],
        ),
      ),
    );
  }

  //HOME HANBALL
  Widget _buildHomeHandball() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image principale avec zoom plein écran

            Image.asset('images/doyen.png'),

            SizedBox(height: 20),

            // Titre "La naissance du doyen"
            Text(
              "La naissance du section",
              style: GoogleFonts.cairo(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),

            // Texte descriptif
            Text(
              "La section handball du Mouloudia d'Alger, créée en 1964, est une équipe historique dans le monde du handball. Pour déterminer si elle est la plus titrée au niveau mondial avant des clubs comme le FC Barcelone et Zamalek, cela dépend des titres remportés dans les compétitions locales, régionales et internationales.",
              style: GoogleFonts.cairo(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 10),

            Text(
              "Palmarès actuel :",
              style: GoogleFonts.cairo(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Section Hommes :",
              style: GoogleFonts.cairo(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),

            // Autres lignes avec images et titres
            _buildRow('images/titre.png', '28', "Championnat d'Algerie"),
            _buildRow('images/titre.png', '29', "Coupe d'Algerie"),
            _buildRow('images/titre.png', '11', "Champions league"),
            _buildRow('images/titre.png', '2', "Super coupe d'Algerie"),
            _buildRow('images/titre.png', '1', "coupe des vaiqueurs de CL"),
            _buildRow('images/titre.png', '9', "Super coupe africaine"),
            _buildRow('images/titre.png', '2', "Coupe arab"),
            SizedBox(
              height: 15,
            ),
            Text(
              "Section Femmes :",
              style: GoogleFonts.cairo(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),

            // Autres lignes avec images et titres
            _buildRow('images/titre.png', '26', "Championnat d'Algerie"),
            _buildRow('images/titre.png', '20', "Coupe d'Algerie"),

            _buildRow('images/titre.png', '4', "Super coupe d'Algerie"),
            _buildRow('images/titre.png', '3', "coupe des vaiqueurs de CL"),

            _buildRow('images/titre.png', '1', "Coupe arab"),

            Image.asset('images/doyen.png'),
          ],
        ),
      ),
    );
  }

// Fonction pour construire un Row réutilisable
  Widget _buildRow(String imagePath, String number, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            imagePath,
            width: 100,
            height: 100,
          ),
          SizedBox(width: 20),
          Text(
            number,
            style: GoogleFonts.cairo(
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 20),
          Expanded(
            // Ajouté pour éviter les débordements horizontaux
            child: Text(
              title,
              style: GoogleFonts.oswald(fontSize: 20, color: Colors.black),
              overflow: TextOverflow.ellipsis, // Coupe le texte si trop long
            ),
          ),
        ],
      ),
    );
  }

// Afficher la boutique
  Widget _buildProductStore() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(30.0),
            shadowColor: Colors.black.withOpacity(0.2),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                hintText: 'Recherche...',
                hintStyle: TextStyle(color: Colors.grey.shade500),
                prefixIcon: const Icon(Icons.search,
                    color: Color.fromARGB(255, 57, 88, 55)),
                filled: true,
                fillColor: Colors.white,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 14.0, horizontal: 20.0),
              ),
            ),
          ),
        ),
        Expanded(
          child: FutureBuilder<List<Product>>(
            future: _products,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                    child: Text('Erreur : ${snapshot.error}',
                        style: const TextStyle(color: Colors.red)));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                    child: Text('Aucun produit disponible pour le moment.'));
              } else {
                List<Product> products = snapshot.data!
                    .where((product) =>
                        product.name.toLowerCase().contains(_searchQuery))
                    .toList();

                return ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return ProductCard(
                      product: products[index],
                      onBuy: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BuyStoreScreen(
                                  productName: products[index].name,
                                  productImageUrl: products[index].imageUrl)),
                        );
                      },
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ProductDetails(product: products[index])),
                        );
                      },
                    );
                  },
                );
              }
            },
          ),
        ),
      ],
    );
  }

  void initState() {
    super.initState();
    _products = fetchProducts();
  }

// POUR AFFICHER LES INFO DES SPORTS
  Widget _getContent() {
    if (_selectedBottomIndex == 1) {
      return _buildProductStore(); // Afficher la boutique
    }
    if (_selectedBottomIndex == 3 && _selectedSport == 'Basketball') {
      return _isLoading
          ? const CircularProgressIndicator()
          : _buildBasketballInfo();
    } else if (_selectedSport == 'Football' && _selectedBottomIndex == 3) {
      return _isLoading
          ? const CircularProgressIndicator()
          : _buildFootballInfo();
    } else if (_selectedSport == 'Handball' && _selectedBottomIndex == 3) {
      return _isLoading
          ? const CircularProgressIndicator()
          : _buildHandballInfo();
    } else if (_selectedSport == 'Football' && _selectedBottomIndex == 2) {
      return _isLoading
          ? const CircularProgressIndicator()
          : _buildFootballMatch();
    } else if (_selectedSport == 'Volley-ball' && _selectedBottomIndex == 3) {
      return _isLoading
          ? const CircularProgressIndicator()
          : _buildVolleyballInfo();
    } else if (_selectedSport == 'Football' && _selectedBottomIndex == 0) {
      return _isLoading
          ? const CircularProgressIndicator()
          : _buildHomeFootball();
    } else if (_selectedSport == 'Handball' && _selectedBottomIndex == 0) {
      return _isLoading
          ? const CircularProgressIndicator()
          : _buildHomeHandball();
    } else if (_selectedSport == 'Basketball' && _selectedBottomIndex == 0) {
      return _isLoading
          ? const CircularProgressIndicator()
          : _buildHomeBasketball();
    } else if (_selectedSport == 'Volley-ball' && _selectedBottomIndex == 0) {
      return _isLoading
          ? const CircularProgressIndicator()
          : _buildHomeVoleyball();
    }

    // Retourne le texte générique pour les autres onglets
    return Text(
      _content[_selectedSport]?[_selectedBottomIndex] ?? 'Erreur',
      style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    );
  }
}

class Product {
  final int id;
  final String name;
  final String price;
  final String description;
  final String imageUrl;
  final String image2Url;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.imageUrl,
    required this.image2Url,
  });
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] ?? 'Nom indisponible',
      price: json['price'] ?? '0',
      description: json['description'] ?? 'Description non disponible',
      imageUrl: '${json['image_url'] ?? 'default_image.jpg'}',
      image2Url: '${json['image2_url'] ?? 'default_image.jpg'}',
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onBuy;
  final VoidCallback onTap;

  const ProductCard({
    Key? key,
    required this.product,
    required this.onBuy,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        elevation: 5,
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  image: DecorationImage(
                    image: AssetImage(product.imageUrl), // Images locales
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Prix : ${product.price} DA',
                      style: const TextStyle(
                        color: Color.fromARGB(255, 57, 88, 55),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 57, 88, 55),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                      ),
                      onPressed: onBuy,
                      child: const Text(
                        'Acheter',
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
