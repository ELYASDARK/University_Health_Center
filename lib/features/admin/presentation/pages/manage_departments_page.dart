import 'package:flutter/material.dart';

/// Page for managing departments
class ManageDepartmentsPage extends StatelessWidget {
  const ManageDepartmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Departments'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/admin/add-department');
            },
          ),
        ],
      ),
      body: const Center(child: Text('Department management coming soon')),
    );
  }
}



