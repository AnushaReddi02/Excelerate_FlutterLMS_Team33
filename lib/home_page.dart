import 'package:flutter/material.dart';
import 'package:nextlearn/models.dart';
import 'package:nextlearn/program_details_screen.dart';
import 'package:nextlearn/search_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: _Header(),
                ),
                const SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: _SearchBar(),
                ),
                const SizedBox(height: 25),
                _buildSectionHeader("Top Courses"),
                const SizedBox(height: 15),
                _buildTopCoursesList(context),
                const SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: _buildSectionHeader("All Courses"),
                ),
                const SizedBox(height: 15),
                const _CategoryFilters(),
                const SizedBox(height: 20),
                _buildAllCoursesGrid(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildTopCoursesList(BuildContext context) {
    final topCourses = [
      const Course(
        title: 'Flutter Development Bootcamp',
        subtitle: 'Build Android & iOS Apps',
        rating: '4.9',
        image: 'assets/flutter.png',
        description: 'A complete guide to building beautiful, natively compiled applications for mobile, web, and desktop from a single codebase.',
        price: '\$9.99',
        duration: '6 hours',
      ),
      const Course(
        title: 'Python for Data Science',
        subtitle: 'Master AI & ML',
        rating: '4.8',
        image: 'assets/python.png',
        description: 'Learn Python for data analysis, machine learning, and data visualization. Hands-on projects included.',
        price: '\$3.99',
        duration: '8 hours',
      ),
      const Course(
        title: 'Full Stack Web Development',
        subtitle: 'React + Django + SQL',
        rating: '4.7',
        image: 'assets/course.png',
        description: 'Become a full-stack web developer by learning the most in-demand skills, from front-end to back-end.',
        price: '\$3.99',
        duration: '8 hours',
      ),
    ];

    return SizedBox(
      height: 220,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        scrollDirection: Axis.horizontal,
        itemCount: topCourses.length,
        separatorBuilder: (context, index) => const SizedBox(width: 15),
        itemBuilder: (context, index) {
          final course = topCourses[index];
          return _TopCourseCard(
            title: course.title,
            subtitle: course.subtitle,
            rating: course.rating,
            image: course.image,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CourseDetailsPage(course: course),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAllCoursesGrid(BuildContext context) {
    final allCourses = [
      const Course(title: 'JavaScript Mastery', subtitle: 'Front-end to Back-end', rating: '4.8', description: 'Master JavaScript with this in-depth course, covering everything from the basics to advanced concepts.', price: '\$49.99', duration: '6 hours', image: 'assets/java.png'),
      const Course(title: 'React Native for Beginners', subtitle: 'Cross-platform Apps', rating: '4.7', description: 'Learn to build native mobile apps for iOS and Android using React Native.', price: '\$39.99', duration: '8 hours', image: 'assets/react.png'),
      const Course(title: 'Kotlin Android Development', subtitle: 'Native App Mastery', rating: '4.6', description: 'The complete guide to building professional Android apps with Kotlin.', price: '\$39.99', duration: '8 hours', image: 'assets/course.png'),
      const Course(title: 'Machine Learning with Python', subtitle: 'AI & Deep Learning', rating: '4.9', description: 'An introduction to the fundamentals of machine learning and artificial intelligence.', price: '\$49.99', duration: '6 hours', image: 'assets/python.png'),
    ];

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        childAspectRatio: 0.75,
      ),
      itemCount: allCourses.length,
      itemBuilder: (context, index) {
        final course = allCourses[index];
        return _AllCourseCard(
          title: course.title,
          subtitle: course.subtitle,
          rating: course.rating,
          image: course.image,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CourseDetailsPage(course: course),
            ),
          ),
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  Future<void> _logout(BuildContext context) async {
    final shouldLogout = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (shouldLogout) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', false);
      if (context.mounted) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Hi User",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 4),
            Text(
              "Explore the popular courses",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey),
            ),
          ],
        ),
        GestureDetector(
          onTap: () => _logout(context),
          child: const CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage("assets/user_avatar.png"),
          ),
        ),
      ],
    );
  }
}

class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SearchPage()),
      ),
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: const [
            Icon(Icons.search, color: Colors.grey),
            SizedBox(width: 10),
            Text("Search", style: TextStyle(color: Colors.grey, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

class _CategoryFilters extends StatefulWidget {
  const _CategoryFilters();

  @override
  State<_CategoryFilters> createState() => _CategoryFiltersState();
}

class _CategoryFiltersState extends State<_CategoryFilters> {
  String _selectedCategory = "All";

  @override
  Widget build(BuildContext context) {
    final categories = ["All", "App Dev", "Web Dev", "AI", "Cloud"];
    return SizedBox(
      height: 50,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final category = categories[index];
          final bool isSelected = _selectedCategory == category;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = category),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xff003360) : const Color(0xfff3f4f6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  category,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _TopCourseCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String rating;
  final String image;
  final VoidCallback onTap;

  const _TopCourseCard({
    required this.title,
    required this.subtitle,
    required this.rating,
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: Image.asset(
                image,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) => const Center(
                  child: Icon(Icons.school, color: Colors.grey, size: 50),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(fontSize: 14, color: Colors.grey)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const SizedBox(width: 5),
                      Text(rating,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AllCourseCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String rating;
  final String image;
  final VoidCallback onTap;

  const _AllCourseCard({
    required this.title,
    required this.subtitle,
    required this.rating,
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              spreadRadius: 1,
              blurRadius: 10,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Center(
                  child: Image.asset(
                    image,
                    fit: BoxFit.contain,
                    errorBuilder: (c, e, s) =>
                    const Icon(Icons.school, color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              Text(subtitle,
                  style: const TextStyle(fontSize: 14, color: Colors.grey)),
              const SizedBox(height: 5),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 20),
                  const SizedBox(width: 5),
                  Text(rating,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
