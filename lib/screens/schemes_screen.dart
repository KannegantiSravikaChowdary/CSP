import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health Schemes App',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const GovtSchemesScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class GovtSchemesScreen extends StatelessWidget {
  const GovtSchemesScreen({super.key});

  final List<Scheme> schemes = const [
    Scheme(
      title: 'Ayushman Bharat Yojana',
      description: 'Covers up to ₹5 lakh per family for hospitalization.',
      url: 'https://www.india.gov.in/spotlight/ayushman-bharat-pradhan-mantri-jan-arogya-yojanas',
      imageAsset: 'assets/images/logo1.png',
    ),
    Scheme(
      title: 'Janani Suraksha Yojana',
      description: 'Cash assistance for pregnant women under NHM.',
      url: 'https://www.mohfw.gov.in/?q=en/Organisation/departments-health-and-family-welfare/activities-health-and-family-welfare/janani-suraksha-yojana',
      imageAsset: 'assets/images/logo2.png',
    ),
    Scheme(
      title: 'Rashtriya Swasthya Bima Yojana',
      description: 'Health insurance for BPL families up to ₹30,000.',
      url: 'https://www.india.gov.in/spotlight/rashtriya-swasthya-bima-yojana',
      imageAsset: 'assets/images/logo3.png',
    ),
    Scheme(
      title: 'National Health Mission',
      description: 'Provides accessible, affordable healthcare services.',
      url: 'https://nhm.gov.in/',
      imageAsset: 'assets/images/logo4.png',
    ),
    Scheme(
      title: 'Deen Dayal Antyodaya Yojana – NRLM',
      description: 'Health awareness through women SHGs.',
      url: 'https://tractornews.in/articles/apply-online-deen-dayal-antyodaya-yojana-nrlm-registration-form-2022/',
      imageAsset: 'assets/images/logo5.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Government Health Schemes')),
      body: ListView.builder(
        itemCount: schemes.length,
        itemBuilder: (context, index) {
          final scheme = schemes[index];
          return Card(
            margin: const EdgeInsets.all(12),
            elevation: 4,
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: ClipOval(
                child: scheme.imageAsset != null
                    ? Image.asset(
                  scheme.imageAsset!,
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                )
                    : scheme.imageUrl != null
                    ? Image.network(
                  scheme.imageUrl!,
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image),
                )
                    : const Icon(Icons.image_not_supported),
              ),
              title: Text(scheme.title,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(scheme.description),
              trailing:
              const Icon(Icons.arrow_forward_ios, color: Colors.green),
              onTap: () => _handleTap(context, scheme.url),
            ),
          );
        },
      ),
    );
  }

  void _handleTap(BuildContext context, String url) async {
    try {
      final uri = Uri.parse(url);
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw 'Could not launch $url';
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch the URL: $url')),
        );
      }
    }
  }
}

class Scheme {
  final String title;
  final String description;
  final String url;
  final String? imageUrl;
  final String? imageAsset;

  const Scheme({
    required this.title,
    required this.description,
    required this.url,
    this.imageUrl,
    this.imageAsset,
  });
}
