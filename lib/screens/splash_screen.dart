import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  double _progress = 0.0;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.5, curve: Curves.easeIn)),
    );

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.5, curve: Curves.easeOutBack)),
    );

    _controller.forward();
    _startLoading();
  }

  void _startLoading() {
    Timer.periodic(const Duration(milliseconds: 30), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        if (_progress < 1.0) {
          _progress += 0.01;
        } else {
          timer.cancel();
          _navigateToNext();
        }
      });
    });
  }

  void _navigateToNext() {
    if (!mounted) return;
    
    final authProvider = context.read<AuthProvider>();
    
    context.go('/');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F4),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Opacity(
                  opacity: _fadeAnimation.value,
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    child: child,
                  ),
                );
              },
              child: Column(
                children: [
                  const Text(
                    'Satin & Stone',
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1F1B16),
                      letterSpacing: -2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'CURATED ELEGANCE',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4,
                      color: const Color(0xFF7A5136).withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 60),
            Container(
              width: 200,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFEBE1D8),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Stack(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    width: 200 * _progress,
                    height: 4,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF7A5136), Color(0xFFD5C3B9)],
                      ),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF7A5136).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
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
