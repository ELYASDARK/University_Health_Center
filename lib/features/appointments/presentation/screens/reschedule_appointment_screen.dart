import 'package:flutter/material.dart';
import '../../../../shared/models/appointment_model.dart';

/// Screen for rescheduling an appointment
class RescheduleAppointmentScreen extends StatefulWidget {
  final AppointmentModel appointment;

  const RescheduleAppointmentScreen({super.key, required this.appointment});

  @override
  State<RescheduleAppointmentScreen> createState() =>
      _RescheduleAppointmentScreenState();
}

class _RescheduleAppointmentScreenState
    extends State<RescheduleAppointmentScreen> {
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reschedule Appointment')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Appointment',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text('Status: ${widget.appointment.status}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (date != null) {
                  setState(() {
                    _selectedDate = date;
                  });
                }
              },
              child: Text(
                _selectedDate == null
                    ? 'Select Date'
                    : 'Date: ${_selectedDate!.toString().split(' ')[0]}',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _selectedDate == null
                  ? null
                  : () {
                      // TODO: Implement reschedule logic
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Reschedule functionality coming soon'),
                        ),
                      );
                    },
              child: const Text('Reschedule'),
            ),
          ],
        ),
      ),
    );
  }
}



