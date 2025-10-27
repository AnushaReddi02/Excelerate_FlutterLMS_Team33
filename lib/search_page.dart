import 'package:flutter/material.dart';
import 'package:nextlearn/program_details_screen.dart';
import 'package:nextlearn/main_nav_page.dart';
import 'package:nextlearn/firestore_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nextlearn/models.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();

  List<Course> _allCourses = [];
  List<Course> _filteredCourses = [];
  List<String> _recentSearches = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    await _loadRecentSearches();
    try {
      final courses = await _firestoreService.getAllCourses();
      setState(() {
        _allCourses = courses;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load courses: $e')),
      );
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _recentSearches = prefs.getStringList('recentSearches') ?? [];
    });
  }

  Future<void> _saveSearchQuery(String query) async {
    if (query.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    _recentSearches.remove(query);
    _recentSearches.insert(0, query);
    if (_recentSearches.length > 5) {
      _recentSearches = _recentSearches.sublist(0, 5);
    }
    await prefs.setStringList('recentSearches', _recentSearches);
    _loadRecentSearches();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredCourses = [];
      } else {
        _filteredCourses = _allCourses
            .where((course) => course.title.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  void _performSearch(String query) {
    _searchController.text = query;
    _saveSearchQuery(query);
  }

  @override
  Widget build(BuildContext context) {
    bool isSearching = _searchController.text.isNotEmpty;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.white,
        elevation: 0,
        title: _buildSearchBar(),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainNavPage()),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : isSearching
              ? _buildSearchResults()
              : _buildInitialView(),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      autofocus: true,
      onSubmitted: _saveSearchQuery,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search, color: Colors.grey),
        hintText: "Search for courses...",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        fillColor: Colors.grey[100],
        filled: true,
        suffixIcon: _searchController.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear, color: Colors.grey),
                onPressed: () => _searchController.clear(),
              )
            : null,
      ),
    );
  }

  Widget _buildInitialView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Top searches", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          Wrap(
            spacing: 10.0,
            runSpacing: 10.0,
            children: [
              "App Dev", "Web Dev", "Dot Net", "Graphic Design", "Digital Marketing", "UI/UX"
            ].map((topic) => ActionChip(
              label: Text(topic, style: const TextStyle(color: Colors.black54)),
              backgroundColor: Colors.grey[200],
              side: BorderSide.none,
              onPressed: () => _performSearch(topic),
            )).toList(),
          ),
          const SizedBox(height: 25),
          const Row(children: [Icon(Icons.history, color: Colors.black54, size: 20), SizedBox(width: 8), Text("Recent", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))]),
          const SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _recentSearches.length,
            itemBuilder: (context, index) {
              final search = _recentSearches[index];
              return ListTile(
                leading: const Icon(Icons.history),
                title: Text(search),
                onTap: () => _performSearch(search),
                trailing: IconButton(
                  icon: const Icon(Icons.clear, size: 20),
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    _recentSearches.remove(search);
                    await prefs.setStringList('recentSearches', _recentSearches);
                    setState(() {});
                  },
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_filteredCourses.isEmpty) {
      return const Center(child: Text("No courses found.", style: TextStyle(fontSize: 16, color: Colors.grey)));
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      itemCount: _filteredCourses.length,
      itemBuilder: (context, index) {
        final course = _filteredCourses[index];
        return InkWell(
          onTap: () {
            _saveSearchQuery(_searchController.text);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CourseDetailsPage(course: course)),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    course.image,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 60, height: 60, color: Colors.grey[200],
                      child: const Icon(Icons.school, color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(child: Text(course.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                const SizedBox(width: 10),
                const Icon(Icons.arrow_forward, color: Colors.black),
              ],
            ),
          ),
        );
      },
    );
  }
}
