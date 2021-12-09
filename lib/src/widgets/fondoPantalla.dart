import 'package:flutter/material.dart';

class FondoPantalla extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: CustomPaint(
        painter: _HeaderTriangularPainter(),
      ),
    );
  }
}

class _HeaderTriangularPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    //Propiedades
    paint.color = Color(0xff4983B9);
    paint.style = PaintingStyle.fill;
    paint.strokeWidth = 1;

    final path = new Path();

    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height * .5);
    path.lineTo(size.width, size.height * 0.50);
    path.lineTo(0, size.height);
    canvas.drawPath(path, paint);

    final linea2 = Paint();
    final newPath = new Path();
    linea2.color = Color(0xffF1F1F1);
    linea2.style = PaintingStyle.fill;
    linea2.strokeWidth = 1;
    newPath.moveTo(0, size.height * .05);
    newPath.lineTo(size.width * .90, size.height * .5);
    newPath.lineTo(0, size.height * .95);

    canvas.drawPath(newPath, linea2);

    final linea3 = Paint();
    final newPath3 = new Path();
    linea3.color = Color(0xffF1F1F1);
    linea3.style = PaintingStyle.fill;
    linea3.strokeWidth = 1;

    newPath3.moveTo(0, size.height);
    newPath3.lineTo(size.width, size.height * .5);
    newPath3.lineTo(size.width, size.height);

    canvas.drawPath(newPath3, linea3);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
