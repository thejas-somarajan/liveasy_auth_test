import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';


class Clip extends StatelessWidget {
  const Clip({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Stack(
          children: [
            ClipPath(
              clipper: WaveClipperOne(reverse: true),
              child: Container(
                color: Colors.blue,
                height: 100,
              )
            ),
            ClipPath(
              clipper: WaveClipper(),
              child: Material(
                color: Colors.transparent,
                child: Container(
                  color: Color.fromARGB(78, 145, 159, 171),
                  height: 100,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0.0, size.height);
    path.quadraticBezierTo(size.width / 3, size.height * 0.5, size.width / 2, size.height * 0.75);
    path.quadraticBezierTo(2 * size.width / 3, size.height, size.width, size.height * 0.75);
    path.lineTo(size.width, 0.0);
    path.lineTo(0.0, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}