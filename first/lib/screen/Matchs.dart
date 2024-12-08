import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Matchs extends StatefulWidget {
  const Matchs({super.key});

  @override
  State<Matchs> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Matchs> {
  int _selectedBottomIndex = 2; // Indice de la bottom bar
  String _selectedSport = 'Football'; // Sport sélectionné dans le drawer
  bool _isLoading = false; // Indicateur de chargement des données

  List<dynamic> _footballMatch = []; // Liste d'articles FOOTBALL récupérés

  /////////////////////////////////////////////////////////////////////////
  ////
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

  // Méthode appelée lorsqu'un élément de la bottom bar est sélectionné
  void _onBottomBarTapped(int index) {
    setState(() {
      _selectedBottomIndex = index;
    });

    // Navigation conditionnelle en fonction de l'index sélectionné
    switch (index) {
      case 0:
        Navigator.of(context).pushReplacementNamed('HomeScreen');
        break;
      case 1:
        Navigator.of(context).pushReplacementNamed('StoreScreen');
        break;
      case 2:
        Navigator.of(context).pushReplacementNamed('Matchs');
        break;
      case 3:
        Navigator.of(context).pushReplacementNamed('HomeScreen');
        break;
    }
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
                        child: const Text(
                          'Réserver votre ticket',
                          style: TextStyle(fontWeight: FontWeight.bold),
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

  // POUR AFFICHER LES INFO DES SPORTS
  Widget _getContent() {
    if (_selectedSport == 'Football' && _selectedBottomIndex == 2) {
      return _isLoading
          ? const CircularProgressIndicator()
          : _buildFootballMatch();
    }

    // Retourne le texte générique pour les autres onglets
    return Text(
      _content[_selectedSport]?[_selectedBottomIndex] ?? 'Erreur',
      style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    );
  }
}
