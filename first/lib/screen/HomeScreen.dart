import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:first/screen/ArticleDetaills.dart';
import 'product_details.dart';
import 'buystore.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomeScreen> {
  late Future<List<Product>> _products;
  String _searchQuery = "";

  int _selectedBottomIndex = 0; // Indice de la bottom bar
  String _selectedSport = 'Handball'; // Sport sélectionné dans le drawer
  bool _isLoading = false; // Indicateur de chargement des données
  List<dynamic> _basketballArticles =
      []; // Liste d'articles BASKETBALL récupérés
  List<dynamic> _footballArticles = []; // Liste d'articles FOOTBALL récupérés
  List<dynamic> _VolleyballArticles = []; // Liste d'articles Volley récupérés
  List<dynamic> _HandballArticles = []; // Liste d'articles Handball récupérés
  List<dynamic> _footballMatch = []; // Liste d'articles FOOTBALL récupérés

  /////////////////////////////////////////////////////////////////////////
  ////
  ///  // Méthode pour charger les produits
  Future<List<Product>> fetchProducts() async {
    const String url = 'http://10.0.2.2/flutterback/get_products.php';
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
        'http://10.0.2.2/flutterback/footballmatch.php'; // Remplacez par l'URL de votre API
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
        'http://10.0.2.2/flutterback/basketballarticle.php'; // Remplacez par l'URL de votre API
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
        'http://10.0.2.2/flutterback/handballarticle.php'; // Remplacez par l'URL de votre API
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
        'http://10.0.2.2/flutterback/volleyballarticle.php'; // Remplacez par l'URL de votre API
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
        'http://10.0.2.2/flutterback/footballarticle.php'; // Remplacez par l'URL de votre API
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
  Widget _buildfootballInfo() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _footballArticles.map((article) {
          return Card(
            margin: const EdgeInsets.only(bottom: 16.0),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0.0),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 8.0, horizontal: 16.0), // Ajustez les paddings
              child: Row(
                crossAxisAlignment:
                    CrossAxisAlignment.center, // Alignement vertical centré
                children: [
                  // Affichage de l'image à gauche
                  article['image'] != null
                      ? Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            image: DecorationImage(
                              image: AssetImage(article['image']),
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      : Container(
                          width: 80,
                          height: 80,
                          color: Colors.grey,
                          child: const Icon(Icons.image),
                        ),
                  const SizedBox(width: 16), // Espace entre l'image et le texte
                  // Contenu textuel à droite de l'image
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          article['title'] ?? 'Titre non disponible',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _VolleyballArticles.map((article) {
          return Card(
            margin: const EdgeInsets.only(bottom: 16.0),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // Affichage de l'image à gauche
                  article['image'] != null
                      ? Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            image: DecorationImage(
                              image: AssetImage(
                                  article['image']), // Utilisez AssetImage ici
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      : Container(
                          width: 80,
                          height: 80,
                          color: Colors.grey,
                          child: const Icon(Icons.image),
                        ),
                  const SizedBox(width: 16), // Espace entre l'image et le texte
                  // Contenu textuel à droite de l'image
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          article['title'] ?? 'Titre non disponible',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          article['subtitle'] ?? 'Sous-titre non disponible',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(article['content'] ?? 'Contenu non disponible'),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _footballMatch.map((match) {
          return Card(
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
                        match['type'] ?? 'Football • First Team',
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
                          color: Colors.blue,
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
                          Image.asset(
                            match['imageA'],
                            width: 40,
                            height: 40,
                          ),
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
                          Text(
                            'VS',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: const Text(
                              'Full time',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Équipe B
                      Column(
                        children: [
                          Image.asset(
                            match['imageB'],
                            width: 40,
                            height: 40,
                          ),
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
                        onPressed: () {
                          // Logique pour ouvrir le centre de match
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          side: const BorderSide(color: Colors.blue),
                        ),
                        child: ElevatedButton(
                          onPressed: ToFormMatch,
                          child: const Text(
                            'Réserver le ticket',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        match['lieu'] ?? 'Soccer Champions Tour • Rose Bowl',
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
          );
        }).toList(),
      ),
    );
  }

//STOOOORE
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
          : _buildfootballInfo();
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
