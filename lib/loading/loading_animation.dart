import 'package:flutter/material.dart';

class LoadingDots extends StatefulWidget {
  const LoadingDots({super.key});

  @override
  State<LoadingDots> createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<LoadingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late List<Animation<double>> _scales;
  late List<Animation<double>> _opacities;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), 
    )..repeat(); 

    _scales = List.generate(3, (i) {
      final start = i * 0.2;
      final end = start + 0.6;
      return Tween(begin: 0.4, end: 1.2).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(start, end, curve: Curves.easeInExpo),
        ),
      );
    });

    _opacities = List.generate(3, (i) {
      final start = i * 0.2;
      final end = start + 0.6;
      return Tween(begin: 0.1, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(start, end, curve: Curves.easeInExpo),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (i) {
            return AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Opacity(
                  opacity: _opacities[i].value,
                  child: Transform.scale(scale: _scales[i].value, child: child),
                );
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 1),
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: Colors.blueAccent,
                  shape: BoxShape.circle,
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
