import 'package:flutter/material.dart';

/// Waitlist page for viewing and managing appointment waitlist
class WaitlistPage extends StatefulWidget {
  const WaitlistPage({super.key});

  @override
  State<WaitlistPage> createState() => _WaitlistPageState();
}

class _WaitlistPageState extends State<WaitlistPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Waitlist')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.list_alt, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'No waitlist entries',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'You are not currently on any waitlists',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}



