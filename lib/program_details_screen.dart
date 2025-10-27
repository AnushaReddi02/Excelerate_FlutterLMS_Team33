import 'package:flutter/material.dart';
import 'package:nextlearn/models.dart';
import 'package:nextlearn/my_learning_page.dart';
import 'package:nextlearn/firestore_service.dart';

class CourseDetailsPage extends StatefulWidget {
  final Course course;
  final CourseStatus? learningStatus;

  const CourseDetailsPage({super.key, required this.course, this.learningStatus});

  @override
  State<CourseDetailsPage> createState() => _CourseDetailsPageState();
}

class _CourseDetailsPageState extends State<CourseDetailsPage> {
  final FirestoreService _firestoreService = FirestoreService();
  bool _isEnrolling = false;

  Future<void> _enrollNow() async {
    setState(() {
      _isEnrolling = true;
    });

    try {
      await _firestoreService.enrollInCourse(widget.course);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Successfully enrolled!')),
      );
      // Navigate to My Learning, but allow the user to go back
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MyLearningPage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Enrollment failed: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isEnrolling = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCourseImage(),
            const SizedBox(height: 20),
            _buildTitleAndPrice(),
            const SizedBox(height: 8),
            Text("Get your certificate with this course", style: TextStyle(fontSize: 16, color: Colors.grey[700])),
            const SizedBox(height: 30),
            const Text("Best seller", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'Inter')),
            const SizedBox(height: 12),
            _buildCourseInfo(),
            const SizedBox(height: 30),
            Text(widget.course.description, style: TextStyle(fontSize: 18, color: Colors.grey[600], height: 1.5, fontFamily: 'Roboto')),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(context),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black), onPressed: () => Navigator.pop(context)),
      backgroundColor: Colors.white,
      elevation: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.favorite_border, color: Colors.black54),
          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Added to your wishlist!'))),
        ),
      ],
    );
  }

  Widget _buildCourseImage() {
    return Hero(
      tag: widget.course.image, // Still using image for Hero animation
      child: Container(
        height: 220,
        width: double.infinity,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
        child: Image.asset(widget.course.image, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) {
          return const Center(child: Icon(Icons.school, color: Colors.grey, size: 80));
        }),
      ),
    );
  }

  Widget _buildTitleAndPrice() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: Text(widget.course.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'Inter'))),
        const SizedBox(width: 10),
        Text(widget.course.price, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.grey[800])),
      ],
    );
  }

  Widget _buildCourseInfo() {
    return Row(children: [
      const Icon(Icons.timer_outlined, color: Color(0xFF013461)),
      const SizedBox(width: 6),
      Text(widget.course.duration, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Color(0xFF013461))),
      const SizedBox(width: 25),
      const Icon(Icons.star, color: Colors.orange, size: 22),
      const SizedBox(width: 6),
      Text(widget.course.rating, style: TextStyle(fontSize: 18, color: Colors.grey[700])),
    ]);
  }

  Widget _buildBottomBar(BuildContext context) {
    final bool isCompleted = widget.learningStatus == CourseStatus.completed;
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
      ),
      child: isCompleted
          ? _buildFeedbackButton(context)
          : Row(children: [
              Expanded(flex: 2, child: _buildActionButton(context, text: "Add to cart", isOutlined: true, icon: Icons.add_shopping_cart, onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Added to cart!'))))),
              const SizedBox(width: 10),
              Expanded(flex: 3, child: _buildActionButton(context, text: "Enroll Now", onTap: _isEnrolling ? null : _enrollNow, showSpinner: _isEnrolling)),
            ]),
    );
  }

  Widget _buildFeedbackButton(BuildContext context) {
    return _buildActionButton(context, text: "Give Feedback", icon: Icons.rate_review, isOrange: true, onTap: () => _showFeedbackDialog(context));
  }

  Widget _buildActionButton(BuildContext context, {required String text, IconData? icon, bool isOutlined = false, bool isOrange = false, VoidCallback? onTap, bool showSpinner = false}) {
    final style = ElevatedButton.styleFrom(
      backgroundColor: isOrange ? Colors.orange[800] : isOutlined ? Colors.white : const Color(0xFF013461),
      foregroundColor: isOutlined ? const Color(0xFF013461) : Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 18),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      side: isOutlined ? const BorderSide(color: Color(0xFF013461), width: 2) : BorderSide.none,
    );
    return ElevatedButton(
      onPressed: onTap,
      style: style,
      child: showSpinner
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
            )
          : (icon != null ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(icon), const SizedBox(width: 10), Text(text, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))]) : Text(text, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
    );
  }

  void _showFeedbackDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Submit Feedback"),
        content: const TextField(decoration: InputDecoration(hintText: "Tell us what you thought..."), maxLines: 3),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(onPressed: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Thank you for your feedback!")));
          }, child: const Text("Submit")),
        ],
      ),
    );
  }
}
