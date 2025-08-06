import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        backgroundColor: Colors.green,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Welcome to Rural Health Access!",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              children: [
                _buildTile(
                  context,
                  icon: Icons.chat,
                  label: "Ask HealthBot",
                  onTap: () => Navigator.pushNamed(context, '/chatbot'),
                ),
                _buildTile(
                  context,
                  icon: Icons.description,
                  label: "Schemes & Benefits",
                  onTap: () => Navigator.pushNamed(context, '/schemes'),
                ),
                _buildTile(
                  context,
                  icon: Icons.event,
                  label: "Health Events",
                  onTap: () => Navigator.pushNamed(context, '/health-events'),
                ),

                _buildTile(
                  context,
                  icon: Icons.warning_amber_rounded,
                  label: "Emergency SOS",
                  onTap: () => Navigator.pushNamed(context, '/sos'),
                ),
                _buildTile(
                  context,
                  icon: Icons.logout,
                  label: "Logout",
                  onTap: () => Navigator.pushReplacementNamed(context, '/login'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTile(BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.green[50],
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.green, width: 1),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.green, size: 40),
            const SizedBox(height: 12),
            Text(label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                )),
          ],
        ),
      ),
    );
  }
}
