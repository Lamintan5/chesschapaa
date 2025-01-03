import 'dart:io';

import 'package:ChessApp/auth/reset.dart';
import 'package:ChessApp/auth/signup.dart';
import 'package:ChessApp/utils/colors.dart';
import 'package:ChessApp/widgets/main_button.dart';
import 'package:ChessApp/widgets/text/emailTextFormWidget.dart';
import 'package:ChessApp/widgets/text/text_filed_input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../home/home_screen.dart';
import '../home/web_home.dart';
import '../main.dart';
import '../model/users.dart';
import '../resources/services.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late TextEditingController _email;
  late TextEditingController _pass;

  List<UserModel> _user = [];
  List<UserModel> fltUsrs = [];

  List<String> tokens = [];

  late UserModel userModel;

  final _key = GlobalKey<FormState>();

  bool _obscure = true;
  bool _loading = false;

  String email = '';
  String id = '';
  String token = '';

  _getUser()async{
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      _loading = true;
    });
    _user = await Services().getUser(email==""?_email.text.trim().toString():email);
    userModel = _user.first;
    token = Platform.isAndroid || Platform.isIOS ? deviceModel.id! : "";
    tokens = userModel.token.toString().split(",");
    tokens.add(token);
    tokens.remove("");
    await Services.updateToken(userModel.uid, tokens.join(",")).then((value){
      print("Token : $token, ${value}");
    });
    await Services.updateToken(userModel.uid, token);
    sharedPreferences.setString('uid', userModel.uid.toString());
    sharedPreferences.setString('username', userModel.username.toString());
    sharedPreferences.setString('first', userModel.firstname.toString());
    sharedPreferences.setString('last', userModel.lastname.toString());
    sharedPreferences.setString('image', userModel.image.toString());
    sharedPreferences.setString('email', userModel.email.toString());
    sharedPreferences.setString('phone', userModel.phone.toString());
    sharedPreferences.setString('status', userModel.status.toString());
    sharedPreferences.setString('token', token);
    sharedPreferences.setString('password', userModel.password.toString());
    sharedPreferences.setString('country', userModel.country.toString());
    currentUser = UserModel(
        uid: userModel.uid.toString(),
        firstname: userModel.firstname,
        lastname: userModel.lastname,
        username: userModel.username,
        email: userModel.email.toString(),
        phone: userModel.phone.toString(),
        image: userModel.image.toString(),
        password: userModel.password.toString(),
        status: userModel.status,
        token:  token,
        country: userModel.country
    );
    // await SocketManager().getDetails();
    _loading = false;
    Get.snackbar(
        'Authentication',
        'User account logged in successfully',
        shouldIconPulse: true,
        icon: Icon(Icons.check, color: Colors.green),
        maxWidth: 500
    );
    Get.offAll(()=>Platform.isAndroid || Platform.isIOS
        ? HomeScreen()
        : WebHome(), transition: Transition.fadeIn);

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _email = TextEditingController();
    _pass = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _email.dispose();
    _pass.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color1 = Theme.of(context).brightness == Brightness.dark
        ? Colors.white10
        : Colors.black12;
    final color2 = Theme.of(context).brightness == Brightness.dark
        ? Colors.white24
        : Colors.black26;
    final normal = Theme.of(context).brightness == Brightness.dark
        ? Colors.black
        : Colors.white;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Form(
          key: _key,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Container(
            width: 500,
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: 500,
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Hello, Welcome Back👋",
                          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
                        ),
                        Text(
                          "Happy to see you again, please login here.",
                          style: TextStyle(color: secondaryColor),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  EmailTextFormWidget(controller: _email),
                  SizedBox(height: 20),
                  TextFieldInput(
                    textEditingController: _pass,
                    labelText: "Password",
                    textInputType: TextInputType.text,
                    isPass: _obscure,
                    srfIcon: IconButton(
                        onPressed: (){
                          setState(() {
                            _obscure = !_obscure;
                          });
                        },
                        icon: Icon(_obscure?CupertinoIcons.eye: CupertinoIcons.eye_slash)
                    ),
                    prxIcon:Icon(Icons.lock_outline),
                    validator: (value){
                      if (value == null || value.isEmpty) {
                        return 'Please enter your Username';
                      }
                    },
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: (){
                            Get.to(() => Reset(), transition: Transition.rightToLeft);
                          },
                          child: Text("Forgot Password?")
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  InkWell(
                    onTap: (){
                      final form = _key.currentState!;
                      email = "";
                      if(form.validate()) {
                        if(_loading){
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Please wait!",),
                                behavior: SnackBarBehavior.floating,
                              )
                          );
                        } else {
                          _loginUser();
                        }
                      }
                    },
                    borderRadius: BorderRadius.circular(5),
                    splashColor: CupertinoColors.activeBlue,
                    hoverColor: CupertinoColors.systemBlue,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                          color: CupertinoColors.activeBlue,
                          borderRadius: BorderRadius.circular(5)
                      ),
                      child: Center(
                        child: _loading
                            ? SizedBox(width: 20, height: 20,child: CircularProgressIndicator(color: Colors.black,strokeWidth: 2,),)
                            : Text(
                          "Login",
                          style: TextStyle(color: normal, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Dont\'t have an account? ",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: secondaryColor
                              ),
                            ),
                            WidgetSpan(
                                child: InkWell(
                                  onTap: (){
                                    Get.to(() => Signup(), transition: Transition.rightToLeft);
                                  },
                                  splashColor: CupertinoColors.systemBlue,
                                  borderRadius: BorderRadius.circular(5),
                                  child: Text(
                                    "Register",
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: CupertinoColors.systemBlue,
                                        fontWeight: FontWeight.w700
                                    ),
                                  ),
                                )
                            )
                          ]
                      )
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    margin: EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Divider(
                            color: Colors.grey,
                            thickness: 1,
                            height: 1,
                          ),
                        ),
                        Text('  or login with ', style: TextStyle(color: secondaryColor),),
                        Expanded(
                          child: Divider(
                            color: Colors.grey,
                            thickness: 1,
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Tooltip(
                        message: "Login with Facebook",
                        child: InkWell(
                          onTap:(){},
                          borderRadius: BorderRadius.circular(15),
                          splashColor: CupertinoColors.activeBlue,
                          child: Container(
                            width: 65, height: 65,
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                                color: CupertinoColors.activeBlue,
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                    width: 2, color: Colors.blue
                                )
                            ),
                            child: Image.asset(
                              'assets/add/fb.png',
                              height: 30,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10,),
                      Tooltip(
                        message: "Login with Google",
                        child: InkWell(
                          onTap:(){},
                          borderRadius: BorderRadius.circular(15),
                          splashColor: CupertinoColors.activeBlue,
                          child: Container(
                            width: 65, height: 65,
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                                color: color2,
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                    width: 2, color: color1
                                )
                            ),
                            child: Image.asset(
                              'assets/add/google_2.png',
                              height: 30,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10,),
                      Tooltip(
                        message: "Login with Apple",
                        child: InkWell(
                          onTap: (){},
                          borderRadius: BorderRadius.circular(15),
                          splashColor: CupertinoColors.activeBlue,
                          child: Container(
                            width: 65, height: 65,
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                                color: color2,
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                    width: 2, color: color1
                                )
                            ),
                            child: Image.asset(
                              Theme.of(context).brightness == Brightness.dark?'assets/add/apple_2.png' : 'assets/add/apple.png',
                              height: 30,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  _loginUser()async{

    setState(() {
      _loading = true;
    });
    var response;
    if (email == "") {
      response = await Services.loginUsers(_email.text.trim().toString(), _pass.text.trim().toString());
    } else {
      response = await Services.loginUserWithEmail(email);
    }
    print("Response $response");
    if(response.contains('Success')){
      _getUser();
    }
    else if(response.contains('Error')){
      Get.snackbar(
          'Authentication',
          'Invalid credentials. Please check you email or password',
          shouldIconPulse: true,
          icon: Icon(Icons.close, color: Colors.red),
          maxWidth: 500
      );
      setState(() {
        _loading = false;
      });
    }
    else {
      Get.snackbar(
        'Authentication',
        'mmhmm, 🤔 seems like something went wrong. Please try again.',
        shouldIconPulse: true,
        maxWidth: 500,
        icon: Icon(Icons.close, color: Colors.red),
      );
      setState(() {
        _loading = false;
      });
    }
  }
}
