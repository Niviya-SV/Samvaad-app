import 'package:flutter/material.dart';

class PastelDreamlandBackground extends StatelessWidget {
  final Widget child;

  const PastelDreamlandBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(
          child: _DreamlandBackground(),
        ),
        child,
      ],
    );
  }
}

class _DreamlandBackground extends StatelessWidget {
  const _DreamlandBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFF7FB),
            Color(0xFFF7F2FF),
            Color(0xFFF1F6FF),
            Color(0xFFFFF8EE),
          ],
          stops: [0.0, 0.35, 0.7, 1.0],
        ),
      ),
      child: Stack(
        children: [
          // Top purple cloud
          Positioned(
            top: -90,
            left: -70,
            child: _PastelBlob(
              width: 280,
              height: 220,
              color: const Color(0xFFDCD4FF).withOpacity(0.45),
            ),
          ),

          // Top right pink cloud
          Positioned(
            top: 80,
            right: -100,
            child: _PastelBlob(
              width: 300,
              height: 250,
              color: const Color(0xFFFFD9E8).withOpacity(0.40),
            ),
          ),

          // Center blue glow
          Positioned(
            top: 330,
            left: -100,
            child: _PastelBlob(
              width: 280,
              height: 260,
              color: const Color(0xFFD7ECFF).withOpacity(0.38),
            ),
          ),

          // Bottom lavender glow
          Positioned(
            bottom: 50,
            right: -120,
            child: _PastelBlob(
              width: 350,
              height: 280,
              color: const Color(0xFFE5D9FF).withOpacity(0.42),
            ),
          ),

          // Bottom peach glow
          Positioned(
            bottom: -100,
            left: -80,
            child: _PastelBlob(
              width: 300,
              height: 250,
              color: const Color(0xFFFFE3C7).withOpacity(0.42),
            ),
          ),

          // Decorative stars
          const Positioned(
            top: 170,
            left: 45,
            child: _DreamStar(
              size: 10,
              color: Color(0xFFB8A9E8),
            ),
          ),

          const Positioned(
            top: 280,
            right: 60,
            child: _DreamStar(
              size: 14,
              color: Color(0xFFFFB7D1),
            ),
          ),

          const Positioned(
            top: 570,
            left: 50,
            child: _DreamStar(
              size: 9,
              color: Color(0xFF9FC9EF),
            ),
          ),

          const Positioned(
            bottom: 170,
            right: 40,
            child: _DreamStar(
              size: 12,
              color: Color(0xFFC4B2F2),
            ),
          ),

          // Small floating circles
          Positioned(
            top: 430,
            right: 25,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFFD1A8).withOpacity(0.65),
              ),
            ),
          ),

          Positioned(
            bottom: 300,
            left: 28,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFC9B7F5).withOpacity(0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PastelBlob extends StatelessWidget {
  final double width;
  final double height;
  final Color color;

  const _PastelBlob({
    required this.width,
    required this.height,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(width),
        boxShadow: [
          BoxShadow(
            color: color,
            blurRadius: 70,
            spreadRadius: 20,
          ),
        ],
      ),
    );
  }
}

class _DreamStar extends StatelessWidget {
  final double size;
  final Color color;

  const _DreamStar({
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: 0.785,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color.withOpacity(0.7),
          borderRadius: BorderRadius.circular(2),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 8,
            ),
          ],
        ),
      ),
    );
  }
}