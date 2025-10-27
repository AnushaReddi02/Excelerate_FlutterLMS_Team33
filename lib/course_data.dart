import 'package:nextlearn/models.dart';

final List<Course> allCourses = [
  const Course(
    title: 'Flutter Development Bootcamp',
    subtitle: 'Learn Flutter from the ground up.',
    description: 'A comprehensive course for beginners to advanced Flutter development.',
    price: '\$49.99',
    duration: '6 hours',
    rating: '4.8',
    image: 'assets/course.png',
  ),
  const Course(
    title: 'Web Development Masterclass',
    subtitle: 'Become a full-stack web developer.',
    description: 'Master HTML, CSS, JavaScript, Node.js, and more.',
    price: '\$39.99',
    duration: '8 hours',
    rating: '4.7',
    image: 'assets/course.png',
  ),
  const Course(
    title: 'Python for Beginners',
    subtitle: 'A beginner-friendly introduction to Python.',
    description: 'Learn the fundamentals of Python programming.',
    price: '\$29.99',
    duration: '5 hours',
    rating: '4.9',
    image: 'assets/course.png',
  ),
  const Course(
    title: 'UI/UX Design Essentials',
    subtitle: 'Learn the principles of great UI/UX design.',
    description: 'A practical course on creating beautiful and user-friendly interfaces.',
    price: '\$34.99',
    duration: '7 hours',
    rating: '4.6',
    image: 'assets/course.png',
  ),
  const Course(
    title: 'Python for Data Science',
    subtitle: 'Learn how to use Python for data analysis.',
    description: 'Explore libraries like Pandas, NumPy, and Matplotlib.',
    price: '\$59.99',
    duration: '10 hours',
    rating: '4.9',
    image: 'assets/course.png',
  ),
  const Course(
    title: 'Full Stack Web Development',
    subtitle: 'Master both front-end and back-end development.',
    description: 'Build complete web applications from scratch.',
    price: '\$79.99',
    duration: '15 hours',
    rating: '4.8',
    image: 'assets/course.png',
  ),
];

const Map<String, Map<String, String>> courseVideoData = {
  'Flutter Development Bootcamp': {
    'Flutter Tutorial for Beginners 1 - Intro Setup':
        'https://res.cloudinary.com/des32xcyt/video/upload/v1761484555/Flutter_Tutorial_for_Beginners_1_-_Intro_Setup_-_Net_Ninja_1080p_h264_lh4cu6.mp4',
    'Flutter Tutorial for Beginners 2 - Flutter Overview':
        'https://res.cloudinary.com/des32xcyt/video/upload/v1761484399/Flutter_Tutorial_for_Beginners_2_-_Flutter_Overview_-_Net_Ninja_1080p_h264_wk1cj6.mp4',
  },
  'Python for Data Science': {
    'Intro to Python for Data Science': 'https://res.cloudinary.com/des32xcyt/video/upload/v1761484821/New_Flutter_Masterclass_Course_-_Net_Ninja_1080p_h264_cxknqd.mp4', // Placeholder
  },
  'Full Stack Web Development': {
    'HTML & CSS Basics': 'https://res.cloudinary.com/des32xcyt/video/upload/v1761484821/New_Flutter_Masterclass_Course_-_Net_Ninja_1080p_h264_cxknqd.mp4', // Placeholder
  },
  'Web Development Masterclass': {
    'HTML & CSS Basics': 'https://res.cloudinary.com/des32xcyt/video/upload/v1761484821/New_Flutter_Masterclass_Course_-_Net_Ninja_1080p_h264_cxknqd.mp4', // Placeholder
  },
  'Python for Beginners': {
    'Intro to Python': 'https://res.cloudinary.com/des32xcyt/video/upload/v1761484821/New_Flutter_Masterclass_Course_-_Net_Ninja_1080p_h264_cxknqd.mp4', // Placeholder
  },
  'UI/UX Design Essentials': {
    'Intro to UI/UX': 'https://res.cloudinary.com/des32xcyt/video/upload/v1761484821/New_Flutter_Masterclass_Course_-_Net_Ninja_1080p_h264_cxknqd.mp4', // Placeholder
  },
};
