import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nextlearn/models.dart';
import 'package:nextlearn/course_data.dart'; // This will be used one last time for the upload

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get _userId => _auth.currentUser?.uid;

  // --- User Management ---
  Future<void> createUserDocument(User user, String username) async {
    final userRef = _db.collection('users').doc(user.uid);
    await userRef.set({
      'username': username,
      'email': user.email,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // --- Data Upload (To be used one last time) ---
  Future<void> uploadCoursesAndLessonsWithQualities() async {
    final coursesCollection = _db.collection('courses');
    final WriteBatch batch = _db.batch();

    for (final course in allCourses) {
      final courseId = course.title.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_');
      final courseRef = coursesCollection.doc(courseId);

      batch.set(courseRef, {
        'title': course.title,
        'subtitle': course.subtitle,
        'description': course.description,
        'price': course.price,
        'duration': course.duration,
        'rating': course.rating,
        'image': course.image,
      });

      final lessons = courseVideoData[course.title];
      if (lessons != null) {
        for (final lessonEntry in lessons.entries) {
          final lessonRef = courseRef.collection('lessons').doc(); // Auto-generate lesson ID

          // Create a qualities map. For now, we only have one URL, so we'll assign it to 480p.
          final qualities = {
            '480p': lessonEntry.value,
            // In the future, you would add other quality URLs here, e.g.:
            // '720p': '..._720p.mp4',
            // '1080p': '..._1080p.mp4',
          };

          batch.set(lessonRef, {'title': lessonEntry.key, 'qualities': qualities});
        }
      }
    }
    await batch.commit();
    print("Successfully uploaded all courses and lessons with qualities!");
  }

  // --- Data Fetching ---
  Future<List<Course>> getAllCourses() async {
    final snapshot = await _db.collection('courses').get();
    return snapshot.docs.map((doc) => Course.fromFirestore(doc.data(), doc.id)).toList();
  }

  Future<List<Lesson>> getLessonsForCourse(String courseId) async {
    final snapshot = await _db.collection('courses').doc(courseId).collection('lessons').get();
    // Correctly use the fromFirestore factory constructor
    return snapshot.docs.map((doc) => Lesson.fromFirestore(doc.data())).toList();
  }

  // --- User Enrollment ---
  Future<void> enrollInCourse(Course course) async {
    final userId = _userId;
    if (userId == null) throw Exception("User not logged in");

    final courseId = course.title.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_');
    final courseRef = _db.collection('users').doc(userId).collection('enrolled_courses').doc(courseId);
    await courseRef.set({
      'id': courseId,
      'title': course.title,
      'image': course.image,
      'enrollment_date': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<Course>> getEnrolledCourses() {
    final userId = _userId;
    if (userId == null) return Stream.value([]); // Return an empty stream if the user is not logged in

    return _db
        .collection('users')
        .doc(userId)
        .collection('enrolled_courses')
        .snapshots()
        .asyncMap((snapshot) async {
      List<Course> enrolledCourses = [];
      for (var doc in snapshot.docs) {
        final courseId = doc.data()['id'] as String?;
        if (courseId != null) {
          final courseSnapshot = await _db.collection('courses').doc(courseId).get();
          if (courseSnapshot.exists) {
            enrolledCourses.add(Course.fromFirestore(courseSnapshot.data()!, courseSnapshot.id));
          }
        }
      }
      return enrolledCourses;
    });
  }
}
