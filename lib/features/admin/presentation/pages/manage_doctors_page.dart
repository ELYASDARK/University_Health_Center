import 'package:flutter/material.dart';

/// Page for managing doctors
class ManageDoctorsPage extends StatelessWidget {
  const ManageDoctorsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Doctors'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/admin/add-doctor');
            },
          ),
        ],
      ),
      body: const Center(child: Text('Doctor management coming soon')),
    );
  }
}



