import 'package:flutter/material.dart';

class LmsLecturePage extends StatelessWidget {
  final String courseTitle;

  const LmsLecturePage({super.key, required this.courseTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(courseTitle),
      ),
      body: const Center(
        child: Text('Lecture content will be displayed here.'),
      ),
    );
  }
}
