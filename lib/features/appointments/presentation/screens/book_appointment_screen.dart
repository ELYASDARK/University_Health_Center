import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/models/appointment_model.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/appointment_provider.dart';

/// Screen for booking a new appointment
class BookAppointmentScreen extends StatefulWidget {
  final String doctorId;
  final String departmentId;

  const BookAppointmentScreen({
    super.key,
    required this.doctorId,
    required this.departmentId,
  });

  @override
  State<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _reasonController = TextEditingController();
  
  DateTime _selectedDate = DateTime.now();
  DateTime _focusedDate = DateTime.now();
  TimeOfDay? _selectedTime;

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _selectTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time != null) {
      setState(() {
        _selectedTime = time;
      });
    }
  }

  Future<void> _bookAppointment() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a time'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final appointmentProvider =
        Provider.of<AppointmentProvider>(context, listen: false);

    if (authProvider.currentUser == null) return;

    // Combine date and time
    final appointmentDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    // Create appointment
    final appointment = AppointmentModel(
      id: '',
      userId: authProvider.currentUser!.uid,
      doctorId: widget.doctorId,
      departmentId: widget.departmentId,
      appointmentDate: appointmentDateTime,
      duration: AppConstants.defaultAppointmentDuration,
      status: AppConstants.statusScheduled,
      reason: _reasonController.text.trim(),
      remindersSent: [],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final success = await appointmentProvider.bookAppointment(appointment);

    if (!mounted) return;

    if (success) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 32),
              SizedBox(width: 12),
              Text('Success!'),
            ],
          ),
          content: const Text(
            'Your appointment has been booked successfully. '
            'You will receive a reminder before your appointment.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Go back to doctors
                Navigator.of(context).pop(); // Go back to departments
              },
              child: const Text('OK'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pushReplacementNamed('/appointments');
              },
              child: const Text('View Appointments'),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            appointmentProvider.errorMessage ?? 'Failed to book appointment',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Appointment'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Calendar
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Select Date',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TableCalendar(
                        firstDay: DateTime.now(),
                        lastDay: DateTime.now().add(const Duration(days: 90)),
                        focusedDay: _focusedDate,
                        selectedDayPredicate: (day) =>
                            isSameDay(_selectedDate, day),
                        onDaySelected: (selectedDay, focusedDay) {
                          setState(() {
                            _selectedDate = selectedDay;
                            _focusedDate = focusedDay;
                          });
                        },
                        calendarStyle: CalendarStyle(
                          selectedDecoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            shape: BoxShape.circle,
                          ),
                          todayDecoration: BoxDecoration(
                            color: Theme.of(context)
                                .primaryColor
                                .withOpacity(0.3),
                            shape: BoxShape.circle,
                          ),
                        ),
                        headerStyle: const HeaderStyle(
                          formatButtonVisible: false,
                          titleCentered: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Time selection
              Card(
                child: InkWell(
                  onTap: _selectTime,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Select Time',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _selectedTime != null
                                    ? _selectedTime!.format(context)
                                    : 'Tap to select time',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Reason for visit
              CustomTextField(
                label: 'Reason for Visit',
                hint: 'Describe your symptoms or reason for appointment',
                controller: _reasonController,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please provide a reason' : null,
                maxLines: 3,
                prefixIcon: const Icon(Icons.notes),
              ),
              const SizedBox(height: 32),

              // Book button
              Consumer<AppointmentProvider>(
                builder: (context, provider, child) {
                  return CustomButton(
                    text: 'Book Appointment',
                    onPressed: _bookAppointment,
                    isLoading: provider.isLoading,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

