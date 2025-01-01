import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainButton extends StatelessWidget {
  final Color backgroundColor;
  final String title;
  final void Function() onTap;
  const MainButton({super.key, this.backgroundColor = CupertinoColors.activeBlue, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final normal = Theme.of(context).brightness == Brightness.dark
        ? Colors.black
        : Colors.white;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(5),
      splashColor: backgroundColor,
      hoverColor: CupertinoColors.systemBlue,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(5)
        ),
        child: Center(
          child: Text(
              title,
            style: TextStyle(color: normal, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
