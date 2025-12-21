import 'package:flutter/material.dart';

/// Admin dashboard page
class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Dashboard')),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildDashboardCard(
            context,
            'Manage Doctors',
            Icons.medical_services,
            () => Navigator.pushNamed(context, '/admin/manage-doctors'),
          ),
          _buildDashboardCard(
            context,
            'Manage Departments',
            Icons.business,
            () => Navigator.pushNamed(context, '/admin/manage-departments'),
          ),
          _buildDashboardCard(
            context,
            'Appointments',
            Icons.calendar_today,
            () => Navigator.pushNamed(context, '/admin/appointments'),
          ),
          _buildDashboardCard(
            context,
            'Analytics',
            Icons.analytics,
            () => Navigator.pushNamed(context, '/admin/analytics'),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardCard(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: Theme.of(context).primaryColor),
            const SizedBox(height: 8),
            Text(title, style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      ),
    );
  }
}



