// add_event_screen.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddHealthEventScreen extends StatefulWidget {
  const AddHealthEventScreen({super.key});

  @override
  State<AddHealthEventScreen> createState() => _AddHealthEventScreenState();
}

class _AddHealthEventScreenState extends State<AddHealthEventScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _typeController = TextEditingController();
  final _mapLinkController = TextEditingController();
  DateTime? _selectedDate;

  void _submitEvent() async {
    if (_titleController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields")),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('health_events').add({
        'title': _titleController.text,
        'description': _descriptionController.text,
        'location': _locationController.text,
        'type': _typeController.text,
        'mapLink': _mapLinkController.text,
        'Date': Timestamp.fromDate(_selectedDate!),
        'createdAt': Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Event submitted successfully!")),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Health Event")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: "Title *"),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: "Description *"),
            ),
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(labelText: "Location"),
            ),
            TextField(
              controller: _typeController,
              decoration: const InputDecoration(labelText: "Event Type"),
            ),
            TextField(
              controller: _mapLinkController,
              decoration: const InputDecoration(labelText: "Map Link (optional)"),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text(
                  _selectedDate == null
                      ? "No Date Chosen"
                      : "Date: ${_selectedDate!.toLocal()}".split(' ')[0],
                ),
                const SizedBox(width: 16),
                ElevatedButton(onPressed: _pickDate, child: const Text("Pick Date")),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submitEvent,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text("Submit Event"),
            )
          ],
        ),
      ),
    );
  }
}
