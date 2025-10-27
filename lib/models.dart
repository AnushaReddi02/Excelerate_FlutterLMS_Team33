import 'package:flutter/material.dart';

class Course {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final String price;
  final String duration;
  final String rating;
  final String image;

  const Course({
    this.id = '',
    required this.title,
    required this.subtitle,
    required this.description,
    required this.price,
    required this.duration,
    required this.rating,
    required this.image,
  });

  factory Course.fromFirestore(Map<String, dynamic> data, String documentId) {
    return Course(
      id: documentId,
      title: data['title'] ?? '',
      subtitle: data['subtitle'] ?? '',
      description: data['description'] ?? '',
      price: data['price'] ?? '',
      duration: data['duration'] ?? '',
      rating: data['rating'] ?? '',
      image: data['image'] ?? '',
    );
  }
}

class Lesson {
  final String title;
  // Changed from a single URL to a map of qualities
  final Map<String, String> qualities;

  const Lesson({required this.title, required this.qualities});

  factory Lesson.fromFirestore(Map<String, dynamic> data) {
    // Safely cast the qualities map
    final qualitiesData = data['qualities'] as Map<String, dynamic>?;
    final qualities = qualitiesData?.map((key, value) => MapEntry(key, value as String)) ?? {};
    return Lesson(
      title: data['title'] ?? '',
      qualities: qualities,
    );
  }
}

enum CourseStatus {
  inProgress,
  completed,
}

class LearningCourse {
  final String title;
  final String? imagePath;
  final String? iconText;
  final IconData? icon;
  final Color? backgroundColor;

  const LearningCourse({
    required this.title,
    this.imagePath,
    this.iconText,
    this.icon,
    this.backgroundColor,
  });
}
