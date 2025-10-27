import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nextlearn/Course%20overview.dart';
import 'package:nextlearn/models.dart';
import 'package:nextlearn/firestore_service.dart';

class MyLearningPage extends StatefulWidget {
  const MyLearningPage({super.key});

  @override
  State<MyLearningPage> createState() => _MyLearningPageState();
}

class _MyLearningPageState extends State<MyLearningPage> {
  final FirestoreService _firestoreService = FirestoreService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Learning'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            tooltip: 'Sign Out',
            onPressed: () async {
              await _auth.signOut();
              // The StreamBuilder in main.dart will handle navigation
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Course>>(
        stream: _firestoreService.getEnrolledCourses(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('You have not enrolled in any courses yet.'));
          }

          final enrolledCourses = snapshot.data!;

          return ListView.separated(
            padding: const EdgeInsets.all(16.0),
            itemCount: enrolledCourses.length,
            separatorBuilder: (context, index) => const SizedBox(height: 15),
            itemBuilder: (context, index) {
              final course = enrolledCourses[index];
              final learningCourse = LearningCourse(title: course.title, imagePath: course.image);
              return _CourseListItem(course: learningCourse, courseId: course.id, firestoreService: _firestoreService);
            },
          );
        },
      ),
    );
  }
}

class _CourseListItem extends StatelessWidget {
  final LearningCourse course;
  final String courseId;
  final FirestoreService firestoreService;

  const _CourseListItem({required this.course, required this.courseId, required this.firestoreService});

  void _showUnenrollDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Unenrollment"),
          content: Text("Are you sure you want to unenroll from ${course.title}?"),
          actions: <Widget>[
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text("Cancel")),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Unenrolled from ${course.title}")));
              },
              child: const Text("Unenroll", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), spreadRadius: 1, blurRadius: 5)],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CourseOverviewScreen(courseId: courseId, courseTitle: course.title)),
          ),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(children: [
              _buildLeadingIcon(),
              const SizedBox(width: 15),
              Expanded(child: Text(course.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600))),
              Material(
                color: Colors.transparent,
                shape: const CircleBorder(),
                child: IconButton(
                  splashRadius: 24,
                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                  onPressed: () => _showUnenrollDialog(context),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _buildLeadingIcon() {
    Widget content;
    if (course.imagePath != null) {
      content = Image.asset(course.imagePath!, fit: BoxFit.cover, errorBuilder: (c, e, s) => const Icon(Icons.school, color: Colors.grey));
    } else {
      content = const Center(child: Icon(Icons.school, size: 40, color: Colors.black54));
    }
    return Container(
      width: 70,
      height: 70,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.grey[200]),
      child: content,
    );
  }
}
