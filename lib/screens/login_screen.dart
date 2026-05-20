import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/storage_service.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_input.dart';
import '../theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  bool isSignup = false;
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final nameCtrl = TextEditingController();
  bool isAdmin = false;
  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeIn);
    _animCtrl.forward();
  }

  @override
  void dispose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    nameCtrl.dispose();
    _animCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    final role = isAdmin ? 'admin' : 'user';
    await StorageService.setUserRole(role);
    await StorageService.setUserEmail(emailCtrl.text.trim());
    if (context.mounted) context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppTheme.primary, Color(0xFF2A3A54)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnim,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'HistoriX',
                    style: TextStyle(
                      color: AppTheme.accent,
                      fontSize: 36,
                      fontFamily: 'Playfair Display',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Discover History\'s Greatest Stories',
                    style: TextStyle(color: Colors.white.withOpacity(0.8)),
                  ),
                  const SizedBox(height: 40),
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Text(
                            isSignup ? 'Create Account' : 'Welcome Back',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 24),
                          if (isSignup)
                            CustomInput(
                              label: 'Full Name',
                              controller: nameCtrl,
                              placeholder: 'John Doe',
                            ),
                          CustomInput(
                            label: 'Email',
                            controller: emailCtrl,
                            placeholder: 'you@example.com',
                            keyboardType: TextInputType.emailAddress,
                          ),
                          CustomInput(
                            label: 'Password',
                            controller: passCtrl,
                            placeholder: '••••••••',
                            obscureText: true,
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Checkbox(
                                value: isAdmin,
                                onChanged: (v) => setState(() => isAdmin = v ?? false),
                              ),
                              const Text('Login as Administrator'),
                            ],
                          ),
                          const SizedBox(height: 24),
                          CustomButton(
                            label: isSignup ? 'Sign Up' : 'Sign In',
                            onPressed: _handleSubmit,
                            isFullWidth: true,
                          ),
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: () => setState(() => isSignup = !isSignup),
                            child: Text(
                              isSignup
                                  ? 'Already have an account? Sign in'
                                  : "Don't have an account? Sign up",
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ),
                          const SizedBox(height: 16),
                          OutlinedButton(
                            onPressed: () async {
                              await StorageService.setUserRole('guest');
                              if (context.mounted) context.go('/');
                            },
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.grey.shade400),
                              minimumSize: const Size(double.infinity, 50),
                            ),
                            child: const Text('Continue as Guest'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}