import 'package:ChessApp/game/components/piece.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Square extends StatelessWidget {
  final ChessPiece? piece;
  final bool isWhite;
  final bool isSelected;
  final bool isValidMove;
  final void Function() onTap;

  const Square({super.key, required this.isWhite, required this.piece, required this.isSelected, required this.onTap, required this.isValidMove});

  @override
  Widget build(BuildContext context) {
    final normal = Theme.of(context).brightness == Brightness.dark
        ? Colors.black
        : Colors.white;
    final reverse = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;
    Color? squareColor;

    if(isSelected) {
      squareColor = CupertinoColors.activeBlue;
    }else if(isValidMove){
      squareColor = CupertinoColors.activeGreen.withOpacity(0.5);
    } else {
      squareColor = isWhite? normal : CupertinoColors.activeBlue.withOpacity(0.3);
    }
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: squareColor,
        margin: EdgeInsets.all(isValidMove ? 8 : 0),
        child: piece != null
            ? Image.asset(
                  piece!.imagePath,
                color: piece!.isWhite? reverse :  Colors.grey[700],
              )
            : null,
      ),
    );
  }
}
