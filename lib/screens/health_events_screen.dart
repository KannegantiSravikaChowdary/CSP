import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'add_event_screen.dart'; // ✅ Ensure this path is correct

class HealthEventsScreen extends StatelessWidget {
  const HealthEventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final adminEmails = ['admin@gmail.com']; // ✅ Add all your admin emails
    final isAdmin = user != null && adminEmails.contains(user.email);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Upcoming Health Events"),
        backgroundColor: Colors.green,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('health_events')
            .where('Date', isGreaterThan: Timestamp.now())
            .orderBy('Date')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong."));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(child: Text("No upcoming events."));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final date = (data['Date'] as Timestamp?)?.toDate();
              final formattedDate = date != null
                  ? DateFormat.yMMMMd().format(date)
                  : 'Date not set';

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  title: Text(
                    data['title']?.toString() ?? 'Untitled Event',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      if (data['location'] != null)
                        Text("📍 ${data['location']}"),
                      Text("🗓️ $formattedDate"),
                      if (data['type'] != null)
                        Text("🩺 Type: ${data['type']}"),
                    ],
                  ),
                  trailing: (data['mapLink'] != null &&
                      data['mapLink'].toString().isNotEmpty)
                      ? IconButton(
                    icon: const Icon(Icons.map),
                    onPressed: () async {
                      final url = Uri.parse(data['mapLink']);
                      if (await canLaunchUrl(url)) {
                        await launchUrl(
                          url,
                          mode: LaunchMode.externalApplication,
                        );
                      }
                    },
                  )
                      : null,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text(data['title'] ?? 'Event'),
                        content: Text(
                          data['description'] ?? 'No description.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Close"),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: isAdmin
          ? FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddHealthEventScreen(),
            ),
          );
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
        tooltip: 'Add New Event',
      )
          : null,
    );
  }
}
