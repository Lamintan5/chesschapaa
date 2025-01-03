import 'package:flutter/material.dart';

class DeadPiece extends StatelessWidget {
  final String imagePath;
  final bool isWhite;
  const DeadPiece({super.key, required this.imagePath, required this.isWhite});

  @override
  Widget build(BuildContext context) {
    final reverse = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;
    return Image.asset(
      imagePath,
      color: isWhite? reverse : Colors.grey[700],

    );
  }
}
