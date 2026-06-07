import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _AbkyLogo(size: 72, color: Colors.white),
            SizedBox(height: 24),
            SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: Colors.white54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AbkyLogo extends StatelessWidget {
  final double size;
  final Color color;
  const _AbkyLogo({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      'ABKY',
      style: TextStyle(
        fontSize: size * 0.55,
        fontWeight: FontWeight.w800,
        color: color,
        letterSpacing: -1,
      ),
    );
  }
}
