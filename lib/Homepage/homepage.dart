import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomePageWidget extends StatelessWidget {
  final List<Map<String, dynamic>> dailyContent = [
    {
      'title': 'Challenge du jour',
      'description': 'Faites 30 minutes de jogging pour améliorer votre endurance.',
      'image': 'https://via.placeholder.com/300',
    },
    {
      'title': 'Quote du jour',
      'description': '“Le succès n’est pas final, l’échec n’est pas fatal : c’est le courage de continuer qui compte.”',
      'image': 'https://via.placeholder.com/300',
    },
    {
      'title': 'Aliment du jour',
      'description': 'Ajoutez une poignée de noix dans vos repas pour un boost d’énergie !',
      'image': 'https://via.placeholder.com/300',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accueil - Carrousel'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: CarouselSlider(
          options: CarouselOptions(
            height: 450.0,
            enlargeCenterPage: true,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 4),
            aspectRatio: 16 / 9,
            enableInfiniteScroll: true,
            scrollPhysics: const BouncingScrollPhysics(),
          ),
          items: dailyContent.map((content) {
            return Builder(
              builder: (BuildContext context) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0), // Ajout de padding en haut et en bas
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05), // Ombre douce
                          blurRadius: 6,
                          spreadRadius: 1,
                          offset: const Offset(1, 1), // Légère déviation
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Partie Image
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(20.0)),
                          child: Image.network(
                            content['image'],
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),

                        // Légère séparation
                        Container(
                          height: 5,
                          color: Colors.grey.shade200,
                        ),

                        // Partie Texte
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                          child: Column(
                            children: [
                              Text(
                                content['title'],
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                content['description'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black54,
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
      backgroundColor: Colors.grey.shade100,
    );
  }
}
