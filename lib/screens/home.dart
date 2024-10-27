import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String currentQuote = "Click the button to generate a quote";
  bool isLoading = false;

  // Function to fetch a random quote from the API
  Future<void> fetchQuoteFromApi() async {
    setState(() {
      isLoading = true;
    });

    const String apiKey =
        'ENrEwSAaoO0yqJwsTNsHVw==Jseo79VavthjCk8O'; // Replace with your actual key
    final List listOfCategory = [
      'love',
      'dreams',
      'friendship',
      'happiness',
      'inspirational',
      'courage',
      'intelligence',
      'leadership'
    ];
    // Category variable
    String category = listOfCategory[Random().nextInt(listOfCategory.length)];
    final response = await http.get(
      Uri.parse('https://api.api-ninjas.com/v1/quotes?category=$category'),
      headers: {
        'Content-Type': 'application/json',
        'X-Api-Key': apiKey,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        currentQuote =
            data[0]['quote']; // Assuming API returns a list of quotes
        isLoading = false;
      });
    } else {
      setState(() {
        currentQuote = "Failed to fetch a quote.";
        print("Error code: ${response.statusCode}, ${response.body}");
        isLoading = false;
      });
    }
  }

  // Function to open a share dialog
  void openShareDialog() {
    if (currentQuote == "Click the button to generate a quote") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please generate a quote first!')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Sbhare Quote"),
          content: const Text("Choose a platform to share the quote."),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.facebook, color: Colors.blue),
              onPressed: () {
                shareToPlatform('facebook');
                Navigator.pop(context);
              },
            ),
            IconButton(
              icon: Image.asset(
                "assets/images/twitter.png",
                color: const Color.fromARGB(115, 184, 64, 64),
                height: 20,
                width: 20,
              ), //const Icon(Icons.share, color: Colors.lightBlue),
              onPressed: () {
                shareToPlatform('twitter');
                Navigator.pop(context);
              },
            ),
            IconButton(
              icon: Image.asset(
                "assets/images/linkedin.png",
                color: Colors.blue,
                height: 20,
                width: 20,
              ),
              onPressed: () {
                shareToPlatform('linkedin');
                Navigator.pop(context);
              },
            ),
            IconButton(
              icon: Image.asset(
                "assets/images/whatsapp.png",
                color: Colors.green,
                height: 20,
                width: 20,
              ),
              onPressed: () {
                shareToPlatform('whatsapp');
                Navigator.pop(context);
              },
            ),
            IconButton(
              icon: Image.asset(
                "assets/images/envelope.png",
                color: Colors.lightBlue,
                height: 20,
                width: 20,
              ),
              onPressed: () {
                shareToPlatform('email');
                Navigator.pop(context);
              },
            ),
            IconButton(
              icon: const Icon(Icons.share, color: Colors.purple),
              onPressed: () {
                Share.share(currentQuote);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  // Function to share to specific platforms
  void shareToPlatform(String platform) {
    final quote = Uri.encodeComponent(currentQuote);

    String url;
    switch (platform) {
      case 'facebook':
        url = 'https://www.facebook.com/sharer/sharer.php?u=$quote';
        break;
      case 'twitter':
        url = 'https://twitter.com/intent/tweet?text=$quote';
        break;
      case 'linkedin':
        url = 'https://www.linkedin.com/shareArticle?mini=true&url=$quote';
        break;
      case 'whatsapp':
        url = 'https://wa.me/?text=$quote';
        break;
      case 'email':
        url = 'mailto:?subject=Inspiring Quote&body=$quote';
        break;
      default:
        return;
    }
    launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            "assets/images/quote.jpg",
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          Container(
            margin: const EdgeInsets.only(top: 48),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Center(
                  child: Text(
                    "Random Quotes",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 29,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      currentQuote,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: fetchQuoteFromApi,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow,
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text('Generate Quote'),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: openShareDialog,
                  icon: const Icon(Icons.share),
                  label: const Text('Share Quote'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
