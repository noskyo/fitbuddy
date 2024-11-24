import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomePageWidget extends StatelessWidget {
  final List<Map<String, dynamic>> dailyContent = [
    {
      'title': 'Challenge du jour',
      'description': 'Faites 30 minutes de jogging pour améliorer votre endurance.',
      'image': 'assets/images/running.png',
    },
    {
      'title': 'Citation du jour',
      'description':
      '“Le succès n’est pas final, l’échec n’est pas fatal : c’est le courage de continuer qui compte.”',
      'image': 'assets/images/montagne.png',
    },
    {
      'title': 'Aliment du jour',
      'description':
      'Ajoutez une poignée de noix dans vos repas pour un boost d’énergie !',
      'image': 'assets/images/nuts.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Color(0xFFE8EAF6)], // Dégradé
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            AppBar(
              title: const Text('Accueil - Carrousel'),
              centerTitle: true,
              elevation: 0,
              backgroundColor: Colors.transparent,
            ),
            Expanded(
              child: CarouselSlider(
                options: CarouselOptions(
                  height: 450.0,
                  enlargeCenterPage: true,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 5),
                  aspectRatio: 16 / 9,
                  enableInfiniteScroll: true,
                  scrollPhysics: const BouncingScrollPhysics(),
                ),
                items: dailyContent.map((content) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 12.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                spreadRadius: 3,
                                offset: const Offset(2, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(20.0),
                                ),
                                child: Image.asset(
                                  content['image'],
                                  height: 200,
                                  width: double.infinity,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16.0,
                                  horizontal: 16.0,
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      content['title'],
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF3E4A59),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      content['description'],
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Color(0xFF6C7A89),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  backgroundColor: const Color(0xFF6C63FF),
                  elevation: 5,
                  shadowColor: Colors.black.withOpacity(0.2),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/feed'); // Naviguer vers FeedPage
                },
                child: const Text(
                  "Partir à l'aventure",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
