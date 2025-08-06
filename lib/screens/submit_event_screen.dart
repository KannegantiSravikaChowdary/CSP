import 'package:flutter/material.dart';

class SubmitEventScreen extends StatelessWidget {
  const SubmitEventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Submit to Event")),
      body: const Center(
        child: Text("You can implement form here for event registration."),
      ),
    );
  }
}
