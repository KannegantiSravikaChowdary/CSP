import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencySOS extends StatelessWidget {
  final String emergencyNumber = "108"; // You can customize this

  Future<void> _makeEmergencyCall() async {
    final Uri callUri = Uri(scheme: 'tel', path: emergencyNumber);
    if (await canLaunchUrl(callUri)) {
      await launchUrl(callUri);
    } else {
      throw 'Could not launch $emergencyNumber';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Emergency SOS')),
      body: Center(
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          ),
          icon: const Icon(Icons.call, size: 32),
          label: const Text('Call Emergency (108)', style: TextStyle(fontSize: 18)),
          onPressed: _makeEmergencyCall,
        ),
      ),
    );
  }
}
