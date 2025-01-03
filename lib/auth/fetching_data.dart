import 'package:ChessApp/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FetchingData extends StatefulWidget {
  const FetchingData({super.key});

  @override
  State<FetchingData> createState() => _FetchingDataState();
}

class _FetchingDataState extends State<FetchingData> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Icon(
            FontAwesomeIcons.chessKnight,
            color: secondaryColor,
          )
      ),
    );
  }
}
