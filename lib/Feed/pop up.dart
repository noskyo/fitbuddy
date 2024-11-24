import 'package:flutter/material.dart';

import 'are_you_sure_page.dart'; // Import the new page

class SecondPage extends StatefulWidget {
  const SecondPage({super.key});

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  List<String> _names = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchNames();
  }

  Future<void> _fetchNames() async {
    try {
      // Simulate Firebase Firestore data fetching
      await Future.delayed(const Duration(seconds: 1)); // Simulated delay
      setState(() {
        _names = ['John Doe', 'Jane Smith', 'Alice Brown']; // Example names
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load names: $e')),
      );
    }
  }

  void _showSuccessPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: const Text('Successful!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).pop(); // Navigate back to home screen
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Header Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Gym 17:30',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Row(
                      children: [
                        const Text(
                          'with xavier ',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        Text(
                          '(LEG DAY)',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.yellow.shade400,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                // Placeholder for photo
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      'photo\nde xavier',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            // Gym Name
            const Center(
              child: Text(
                'Atlantis gym',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Placeholder for list of names
            Container(
              height: 150,
              width: double.infinity,
              color: Colors.grey.shade300,
              child: Center(
                child: _isLoading
                    ? const CircularProgressIndicator() // Show loading spinner
                    : _names.isEmpty
                        ? const Text(
                            'No names found.',
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          )
                        : ListView.builder(
                            itemCount: _names.length,
                            itemBuilder: (context, index) {
                              return Text(
                                _names[index],
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.black),
                              );
                            },
                          ),
              ),
            ),
            const SizedBox(height: 40),
            // Oui and Non Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _showSuccessPopup(context); // Show success popup
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade200,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 20),
                  ),
                  child: const Text('oui'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AreYouSurePage()),
                    ); // Navigate to the "Are you sure" page
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade200,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 20),
                  ),
                  child: const Text('non'),
                ),
              ],
            ),
            const Spacer(),
            // Footer Information
            const Center(
              child: Text(
                'info sur la personne/workout.',
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
