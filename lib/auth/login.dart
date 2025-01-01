import 'package:chesschapaa/auth/signup.dart';
import 'package:chesschapaa/utils/colors.dart';
import 'package:chesschapaa/widgets/main_button.dart';
import 'package:chesschapaa/widgets/text/emailTextFormWidget.dart';
import 'package:chesschapaa/widgets/text/text_filed_input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late TextEditingController _email;
  late TextEditingController _pass;

  bool _obscure = true;

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
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Flexible(
            flex: 1,
            child: Container(
              width: 500,
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
          ),
          Flexible(
            flex: 2,
            child: Container(
              width: 500,
              margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: SingleChildScrollView(
                child: Column(
                  children: [
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
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: (){},
                            child: Text("Forgot Password?")
                        )
                      ],
                    ),
                    SizedBox(height: 10),
                    MainButton(title: "Login", onTap: (){}),
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
          Flexible(
            flex: 1,
            child: Container(),
          ),
        ],
      ),
    );
  }
}
