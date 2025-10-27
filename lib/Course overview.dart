import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:nextlearn/firestore_service.dart';
import 'package:nextlearn/models.dart';

class CourseOverviewScreen extends StatefulWidget {
  final String courseId;
  final String courseTitle;

  const CourseOverviewScreen({super.key, required this.courseId, required this.courseTitle});

  @override
  State<CourseOverviewScreen> createState() => _CourseOverviewScreenState();
}

class _CourseOverviewScreenState extends State<CourseOverviewScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  List<Lesson> _lessons = [];
  Lesson? _currentLesson;
  bool _isLoadingLessons = true;
  String _selectedQuality = '480p'; // Default quality

  @override
  void initState() {
    super.initState();
    _fetchLessons();
  }

  Future<void> _fetchLessons() async {
    try {
      final lessons = await _firestoreService.getLessonsForCourse(widget.courseId);
      if (mounted && lessons.isNotEmpty) {
        setState(() {
          _lessons = lessons;
          _isLoadingLessons = false;
        });
        _initializeVideo(lessons.first);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingLessons = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to load lessons: $e')));
      }
    }
  }

  Future<void> _initializeVideo(Lesson lesson, {Duration? startAt}) async {
    _videoController?.pause();
    setState(() {
      _chewieController = null; // Show loading indicator
      _currentLesson = lesson;
    });

    if (!lesson.qualities.containsKey(_selectedQuality)) {
      _selectedQuality = lesson.qualities.keys.first;
    }

    final videoUrl = lesson.qualities[_selectedQuality]!;

    try {
      final oldController = _videoController;
      final newVideoController = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
      await newVideoController.initialize();
      
      // Dispose the old controller after the new one is ready
      // No await here because dispose() is a void method
      oldController?.dispose();

      if (mounted) {
        _chewieController = ChewieController(
          videoPlayerController: newVideoController,
          autoPlay: true,
          looping: false,
          startAt: startAt,
          additionalOptions: (context) {
            return _currentLesson!.qualities.keys.map((quality) {
              return OptionItem(
                onTap: (_) {
                  Navigator.pop(context);
                  _changeVideoQuality(quality);
                },
                iconData: Icons.hd,
                title: quality,
              );
            }).toList();
          },
        );
        setState(() {
          _videoController = newVideoController;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to load video: $e')));
      }
    }
  }

  Future<void> _changeVideoQuality(String newQuality) async {
    if (_selectedQuality == newQuality || _currentLesson == null) return;

    final currentPosition = await _videoController?.position;
    setState(() {
      _selectedQuality = newQuality;
    });
    _initializeVideo(_currentLesson!, startAt: currentPosition);
  }

  @override
  void dispose() {
    // THIS IS THE FIX: Explicitly pause the video before disposing the controllers.
    _videoController?.pause();
    _videoController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(widget.courseTitle, style: const TextStyle(color: Color(0xFF00264D), fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Color(0xFF00264D)),
      ),
      body: SafeArea(
        child: _isLoadingLessons
            ? const Center(child: CircularProgressIndicator())
            : _lessons.isEmpty
                ? const Center(child: Text('No lessons available for this course.'))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildVideoPlayer(),
                      const SizedBox(height: 20),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text('Lessons', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF00264D))),
                      ),
                      const SizedBox(height: 8),
                      Expanded(child: _buildLessonsList()),
                    ],
                  ),
      ),
    );
  }

  Widget _buildVideoPlayer() {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        color: Colors.black,
        child: _chewieController != null && _chewieController!.videoPlayerController.value.isInitialized
            ? Chewie(controller: _chewieController!)
            : const Center(child: CircularProgressIndicator(color: Colors.white)),
      ),
    );
  }

  Widget _buildLessonsList() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      shrinkWrap: true,
      itemCount: _lessons.length,
      separatorBuilder: (_, __) => const Divider(height: 0),
      itemBuilder: (context, index) {
        final lesson = _lessons[index];
        final isPlaying = lesson.title == _currentLesson?.title;
        return ListTile(
          leading: Icon(isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill, color: const Color(0xFF00264D)),
          title: Text(lesson.title, style: TextStyle(fontWeight: isPlaying ? FontWeight.bold : FontWeight.normal)),
          onTap: () {
            if (!isPlaying) {
              _initializeVideo(lesson);
            }
          },
        );
      },
    );
  }
}
