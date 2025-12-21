import 'package:flutter/material.dart';
import '../../../../shared/models/doctor_model.dart';

/// Doctor reviews page
class DoctorReviewsPage extends StatelessWidget {
  final DoctorModel doctor;

  const DoctorReviewsPage({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${doctor.name} - Reviews')),
      body: const Center(child: Text('Doctor reviews coming soon')),
    );
  }
}



