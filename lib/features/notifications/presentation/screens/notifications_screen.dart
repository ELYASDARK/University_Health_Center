import 'package:flutter/material.dart';

/// Notifications screen (placeholder for future implementation)
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.notifications_outlined,
                size: 80,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 24),
              Text(
                'No Notifications Yet',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'You\'ll receive notifications here for:',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 16),
              _buildNotificationItem(
                icon: Icons.event,
                text: 'Appointment reminders',
              ),
              const SizedBox(height: 8),
              _buildNotificationItem(
                icon: Icons.check_circle,
                text: 'Booking confirmations',
              ),
              const SizedBox(height: 8),
              _buildNotificationItem(
                icon: Icons.cancel,
                text: 'Cancellation alerts',
              ),
              const SizedBox(height: 8),
              _buildNotificationItem(
                icon: Icons.update,
                text: 'Schedule changes',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationItem({
    required IconData icon,
    required String text,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 20, color: Colors.blue),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }
}

