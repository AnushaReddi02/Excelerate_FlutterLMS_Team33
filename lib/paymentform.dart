import 'package:flutter/material.dart';
import 'package:nextlearn/models.dart';

class PaymentFormPage extends StatelessWidget {
  final Course course;

  const PaymentFormPage({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Your Purchase'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('You are enrolling in:', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(course.title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            // Add your payment form fields here (e.g., credit card input).
            const Center(child: Text('Payment form will be here.')),
          ],
        ),
      ),
    );
  }
}
