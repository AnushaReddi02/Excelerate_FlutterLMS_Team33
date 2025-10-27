import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nextlearn/forgot_password_page.dart';
import 'package:nextlearn/firestore_service.dart';

// --- Sign In Screen ---
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isSigningIn = false;

  Future<void> _signIn() async {
    if (!mounted) return;
    setState(() {
      _isSigningIn = true;
    });

    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/main');
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? "An unknown error occurred.")),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSigningIn = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 60.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(height: 40),
            Image.asset('assets/nexlearn_logo.png', height: 50, color: const Color(0xFF00264D)),
            const SizedBox(height: 40),
            const Text('Let’s sign you in.', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF00264D))),
            const SizedBox(height: 48),
            _buildTextField(label: 'Email', controller: _emailController, icon: Icons.email_outlined),
            const SizedBox(height: 20),
            _buildTextField(label: 'Password', controller: _passwordController, icon: Icons.lock_outline, isPassword: true),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgotPasswordPage())),
                child: const Text('Forgot Password?', style: TextStyle(color: Color(0xFF00264D))),
              ),
            ),
            const SizedBox(height: 20),
            _isSigningIn
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _signIn,
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00264D), padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    child: const Text('Sign In', style: TextStyle(fontSize: 18, color: Colors.white)),
                  ),
            const SizedBox(height: 30),
            _buildSocialLogin(),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [const Text("Don't have an account?"), TextButton(onPressed: () => Navigator.pushReplacementNamed(context, '/signup'), child: const Text('Sign Up', style: TextStyle(color: Color(0xFF00264D), fontWeight: FontWeight.bold)))],
            ),
          ],
        ),
      ),
    );
  }
}

// --- Sign Up Screen ---
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();
  bool _isSigningUp = false;

  Future<void> _signUp() async {
    if (!mounted) return;
    setState(() {
      _isSigningUp = true;
    });
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (userCredential.user != null) {
        await _firestoreService.createUserDocument(userCredential.user!, _usernameController.text.trim());
      }
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/main');
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? "An unknown error occurred.")),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSigningUp = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 60.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(height: 40),
            Image.asset('assets/nexlearn_logo.png', height: 150, color: const Color(0xFF00264D)),
            const SizedBox(height: 40),
            const Text('Getting Started', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF00264D))),
            const SizedBox(height: 10),
            Text('Create an account to continue!', style: TextStyle(fontSize: 24, color: Colors.grey[600])),
            const SizedBox(height: 48),
            _buildTextField(label: 'Username', controller: _usernameController, icon: Icons.person_outline),
            const SizedBox(height: 20),
            _buildTextField(label: 'Email', controller: _emailController, icon: Icons.email_outlined),
            const SizedBox(height: 20),
            _buildTextField(label: 'Password', controller: _passwordController, icon: Icons.lock_outline, isPassword: true),
            const SizedBox(height: 40),
            _isSigningUp
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _signUp,
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00264D), padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    child: const Text('Sign Up', style: TextStyle(fontSize: 18, color: Colors.white)),
                  ),
            const SizedBox(height: 30),
            _buildSocialLogin(),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [const Text("Already have an account?"), TextButton(onPressed: () => Navigator.pushReplacementNamed(context, '/login'), child: const Text('Sign In', style: TextStyle(color: Color(0xFF00264D), fontWeight: FontWeight.bold)))],
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildTextField({required String label, required TextEditingController controller, required IconData icon, bool isPassword = false}) {
  return TextField(
    controller: controller,
    obscureText: isPassword,
    decoration: InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.grey),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}

Widget _buildSocialLogin() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      _socialButton(FontAwesomeIcons.google, () {}), // Disabled for now
      const SizedBox(width: 20),
      _socialButton(FontAwesomeIcons.facebookF, () {}), // Disabled for now
      const SizedBox(width: 20),
      _socialButton(FontAwesomeIcons.apple, () {}), // Disabled for now
    ],
  );
}

Widget _socialButton(IconData icon, VoidCallback onPressed) {
  return OutlinedButton(
    onPressed: onPressed,
    style: OutlinedButton.styleFrom(
      shape: const CircleBorder(),
      padding: const EdgeInsets.all(16),
      side: BorderSide(color: Colors.grey[300]!),
    ),
    child: FaIcon(icon, color: Colors.grey[700], size: 20),
  );
}
