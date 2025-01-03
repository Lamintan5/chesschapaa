import 'package:ChessApp/game/game_board.dart';
import 'package:ChessApp/main.dart';
import 'package:ChessApp/resources/services.dart';
import 'package:ChessApp/widgets/profile_images/current_profile.dart';
import 'package:ChessApp/widgets/profile_images/user_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../auth/login.dart';
import '../model/users.dart';

class WebHome extends StatefulWidget {
  const WebHome({super.key});

  @override
  State<WebHome> createState() => _WebHomeState();
}

class _WebHomeState extends State<WebHome> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final reverse = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;
    return Scaffold(
      appBar: AppBar(
        actions: [
          _loading
              ? Container(
                  width: 20,height: 20,
                  margin: EdgeInsets.only(right: 10),
                  child: CircularProgressIndicator(color: reverse, strokeWidth: 2,)
                )
              : IconButton(
              onPressed: logoutUser,
              icon: Icon(Icons.logout)
          )
        ],
      ),
      body: Center(
        child: MaterialButton(
            onPressed: (){
              Get.to(() => GameBoard(), transition: Transition.rightToLeft);
            },
            color: CupertinoColors.activeBlue,
            child: Text("Game Board", style: TextStyle(color: Colors.black),),
        ),
      ),
    );
  }
  Future logoutUser()async{
    final reverse = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;
    final dilogbg = Theme.of(context).brightness == Brightness.dark
        ? Colors.grey[900]
        : Colors.white;
    setState(() {
      _loading = true;
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();

    await Services.updateToken(currentUser.uid, "").then((response){
      if(response=="success"){
        setState(() {
          _loading = false;
        });
        preferences.remove('uid');
        preferences.remove('username');
        preferences.remove('first');
        preferences.remove('last');
        preferences.remove('image');
        preferences.remove('email');
        preferences.remove('phone');
        preferences.remove('status');
        preferences.remove('token');
        preferences.remove('password');
        preferences.remove('country');

        currentUser = UserModel(uid: "", email: "", phone: "", username: "", image: "", token: "", status: "", firstname: "", lastname: "", password: "", time: "", country: "");

        Get.snackbar(
          "User Account",
          "User logged out successfully",
          icon: Icon(Icons.logout),
          maxWidth: 500,
        );
        Get.offAll(()=>Login(), transition: Transition.leftToRight);
      }
      else if(response=="error"){
        setState(() {
          _loading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: dilogbg,
              content: Text("Login out failed", style: TextStyle(color: reverse),),
              action: SnackBarAction(
                label: "Try again",
                onPressed: (){
                  logoutUser();
                },
              ),
            )
        );
      }
      else {
        setState(() {
          _loading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: dilogbg,
              content: Text("mhmm 🤔 something went wrong", style: TextStyle(color: reverse),),
              action: SnackBarAction(
                label: "Try again",
                onPressed: (){
                  logoutUser();
                },
              ),
            )
        );
      }
    });
  }
}
