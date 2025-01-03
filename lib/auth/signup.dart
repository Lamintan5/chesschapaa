import 'dart:convert';
import 'dart:io';

import 'package:ChessApp/auth/verify_email.dart';
import 'package:ChessApp/widgets/main_button.dart';
import 'package:country_picker/country_picker.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../api/api_service.dart';
import '../main.dart';
import '../model/users.dart';
import '../utils/colors.dart';
import '../widgets/text/emailTextFormWidget.dart';
import '../widgets/text/text_filed_input.dart';
import 'camera.dart';
import 'login.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  Country _country = CountryParser.parseCountryCode(deviceModel.country == null? 'US' : deviceModel.country.toString());

  late TextEditingController _first;
  late TextEditingController _second;
  late TextEditingController _username;
  late TextEditingController _email;
  late TextEditingController _pass;
  late TextEditingController _confirm;
  late TextEditingController _phone;

  final _key = GlobalKey<FormState>();

  File? _image;

  var pickedImage;

  final picker = ImagePicker();

  String _imageUrl = '';

  bool _loading = false;
  bool _isLoading = false;
  bool _obscure = true;
  bool _obscureConfirm = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _first = TextEditingController();
    _second = TextEditingController();
    _username = TextEditingController();
    _email = TextEditingController();
    _phone = TextEditingController();
    _pass = TextEditingController();
    _confirm = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _first.dispose();
    _second.dispose();
    _username.dispose();
    _email.dispose();
    _phone.dispose();
    _pass.dispose();
    _confirm.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final revers = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;
    final normal = Theme.of(context).brightness == Brightness.dark
        ? Colors.black
        : Colors.white;
    final color1 = Theme.of(context).brightness == Brightness.dark
        ? Colors.white10
        : Colors.black12;
    final color2 = Theme.of(context).brightness == Brightness.dark
        ? Colors.white24
        : Colors.black26;
    final inputBorder = OutlineInputBorder(
        borderSide: Divider.createBorderSide(context)
    );
    final bold = TextStyle(fontWeight: FontWeight.bold, color: revers, fontSize: 13);
    final boldBtn = TextStyle(color: CupertinoColors.activeBlue, fontWeight: FontWeight.bold, fontSize: 13);
    final style = TextStyle(color: revers, fontSize: 13);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Expanded(
                child: Form(
                  key: _key,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Container(
                    width: 500,
                    margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: 20,),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(),
                              Text(
                                "Hello, Welcome👋",
                                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
                              ),
                              Text(
                                "Lets get started by creating you an account.",
                                style: TextStyle(color: secondaryColor),
                              ),
                            ],
                          ),
                          SizedBox(height: 20,),
                          Row(
                            children: [
                              Icon(CupertinoIcons.person_fill ,size: 26),SizedBox(width: 10,),
                              Text('Profile', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),),
                            ],
                          ),
                          SizedBox(height: 20,),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Stack(
                                alignment: AlignmentDirectional.center,
                                children: [
                                  _image != null
                                      ? ClipOval(
                                    child: Image.file(_image!, width: 100, height: 100, fit: BoxFit.cover,),
                                  )
                                      : _imageUrl == ''? ClipOval(
                                    child: Image.asset("assets/add/default_profile.png", width: 100, height: 100,),
                                  ) : ClipOval(
                                    child: Image.network(_imageUrl, width: 100, height: 100, fit: BoxFit.cover,),
                                  ),
                                  _loading ? CircularProgressIndicator() : SizedBox(),
                                  Positioned(
                                    bottom: -10,
                                    left: 65,
                                    child: IconButton(
                                      onPressed: () {
                                        dialogPickProfile(context);
                                      },
                                      icon: const Icon(Icons.add_a_photo, color: Colors.blueAccent,),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: 20,),
                              Expanded(
                                child: Column(
                                  children: [
                                    TextFieldInput(
                                      textEditingController: _username,
                                      labelText: 'Username',
                                      textInputType: TextInputType.text,
                                      validator: (value){
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your Username';
                                        }
                                      },
                                    ),
                                    SizedBox(height: 10,),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: TextFieldInput(
                                            textEditingController: _first,
                                            labelText: 'First Name',
                                            textInputType: TextInputType.text,
                                            validator: (value){
                                              if (value == null || value.isEmpty) {
                                                return 'Please enter your First Name';
                                              }
                                            },
        
                                          ),
                                        ),
                                        SizedBox(width: 10,),
                                        Expanded(
                                          child: TextFieldInput(
                                            textEditingController: _second,
                                            labelText: 'Second Name',
                                            textInputType: TextInputType.text,
                                            validator: (value){
                                              if (value == null || value.isEmpty) {
                                                return 'Please enter your Second Name';
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
        
        
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20,),
                          Row(
                            children: [
                              Icon(CupertinoIcons.device_phone_portrait ,size: 26),SizedBox(width: 10,),
                              Text('Contact', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),),
                            ],
                          ),
                          SizedBox(height: 20,),
                          EmailTextFormWidget(
                            controller: _email,
                            action: 'no',
                          ),
                          SizedBox(height: 10,),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: _showPicker,
                                child: Container(
                                  width: 60, height: 48,
                                  decoration: BoxDecoration(
                                    color: color1,
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        width: 1, color: color1
                                    ),
                                  ),
                                  child: Center(
                                      child: Text("+${_country.phoneCode}")
                                  ),
                                ),
                              ),
                              SizedBox(width: 5,),
                              Expanded(
                                child: TextFieldInput(
                                  textEditingController: _phone,
                                  labelText: "Phone",
                                  maxLength: 9,
                                  textInputType: TextInputType.phone,
                                  validator: (value){
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter a phone number.';
                                    }
                                    if (RegExp(r'^[0-9+]+$').hasMatch(value)) {
                                      return null; // Valid input (contains only digits)
                                    } else {
                                      return 'Please enter a valid phone number';
                                    }
                                  },
                                ),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Icon(CupertinoIcons.lock ,size: 26),SizedBox(width: 10,),
                              Text('Security', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),),
                            ],
                          ),
                          SizedBox(height: 10,),
                          TextFieldInput(
                            textEditingController: _pass,
                            labelText: "Password",
                            textInputType: TextInputType.text,
                            isPass: _obscure,
                            srfIcon: IconButton(
                                onPressed: (){
                                  setState(() {
                                    _obscure =! _obscure;
                                  });
                                },
                                icon: Icon(_obscure?Icons.remove_red_eye_outlined : Icons.remove_red_eye)),
                            validator: (value){
                              if (value == null || value.isEmpty) {
                                return 'Please enter a password.';
                              }
                              if (value.length < 8) {
                                return 'Password must be at least 8 characters long.';
                              }
                              if (!value.contains(RegExp(r'[A-Z]'))) {
                                return 'Password must contain at least one uppercase letter.';
                              }
                              if (value.replaceAll(RegExp(r'[^0-9]'), '').length < 4) {
                                return 'Password must contain at least four digits.';
                              }
                              if (!value.contains(RegExp(r'[!@#\$%^&*()_+{}\[\]:;<>,.?~\\-]'))) {
                                return 'Password must contain at least one special character.';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10,),
                          TextFieldInput(
                            textEditingController: _confirm,
                            labelText: "Confirm Password",
                            textInputType: TextInputType.text,
                            isPass: _obscureConfirm,
                            validator: (value){
                              if(value != _pass.text.trim()){
                                return 'Passwords don\'t match. Please check your new password';
                              }
                            },
                          ),
                          SizedBox(height: 10,),
                          InkWell(
                            onTap: (){
                              final form = _key.currentState!;
                              if(form.validate()) {
                                if(_isLoading){
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("Please wait!", style: TextStyle(color: revers),),
                                        behavior: SnackBarBehavior.floating,
                                      )
                                  );
                                } else {
                                  _verifyEmail();
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
                                child: _isLoading
                                    ? SizedBox(width: 20, height: 20,child: CircularProgressIndicator(color: Colors.black,strokeWidth: 2,),)
                                    : Text(
                                      "Create Account",
                                      style: TextStyle(color: normal, fontWeight: FontWeight.w600),
                                    ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10,),
                          RichText(
                              text: TextSpan(
                                  children: [
                                    TextSpan(
                                        text: "Already have an account? ",
                                        style: TextStyle(color: secondaryColor, fontSize: 14)
                                    ),
                                    WidgetSpan(
                                        child: InkWell(
                                          onTap: (){
                                            Get.to(() => Login(), transition: Transition.rightToLeft);
                                          },
                                          splashColor: CupertinoColors.systemBlue,
                                          borderRadius: BorderRadius.circular(5),
                                          child: Text(
                                            "Login",
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
                                Text('  or register with ', style: TextStyle(color: secondaryColor),),
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
                                message: "Register with Facebook",
                                child: InkWell(
                                  onTap:(){},
                                  borderRadius: BorderRadius.circular(15),
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
                                message: "Register with Google",
                                child: InkWell(
                                  onTap:(){},
                                  borderRadius: BorderRadius.circular(15),
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
                                message: "Register with Apple",
                                child: InkWell(
                                  onTap: (){},
                                  borderRadius: BorderRadius.circular(15),
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
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                            children: [
                              TextSpan(
                                  text: 'By ',
                                  style: style
                              ),
                              TextSpan(
                                  text: 'creating an account, ',
                                  style: bold
                              ),
                              TextSpan(
                                  text: 'you agree to our ',
                                  style: style
                              ),
                              WidgetSpan(
                                child: InkWell(
                                  onTap: () {
                                    // Handle button press
                                  },
                                  child: Text('User Agreement ',style: boldBtn),
                                ),
                              ),
                              TextSpan(
                                  text: 'and acknowledge reading our ',
                                  style: style
                              ),
                              WidgetSpan(
                                child: InkWell(
                                  onTap: () {
                                    // Get.to(() => PrivacyPolicy(), transition: Transition.rightToLeft);
                                  },
                                  child: Text('User Privacy Notice.',style: boldBtn),
                                ),
                              ),
                            ]
                        )
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  void  _verifyEmail()async{
    final revers = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;
    final dilogbg = Theme.of(context).brightness ==  Brightness.dark
        ? Colors.grey[900]
        : Colors.white;
    const uuid = Uuid();
    String id = uuid.v1();
    setState(() {
      _isLoading = true;
    });
    UserModel userModel = UserModel(
      uid: id,
      username: _username.text.trim().toString(),
      firstname: _first.text.trim().toString(),
      lastname: _second.text.trim().toString(),
      email: _email.text.trim().toString(),
      phone: "+"+ _country.phoneCode+_phone.text.trim().toString(),
      password:  md5.convert(utf8.encode(_pass.text.trim().toString())).toString(),
      image: _image!=null?_image!.path:_imageUrl,
      status: "",
      token: deviceModel.token.toString(),
      time: DateTime.now().toString(),
      country: _country.countryCode,
    );
    APIService.otpLogin(_email.text.trim()).then((response)async{
      print(response.data);
      setState(() {
        _isLoading = false;
      });
      if(response.data != null){
        Get.to(()=>VerifyEmail(otpHash: response.data.toString(), userModel: userModel,), transition: Transition.rightToLeft);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("mhmm🤔 seems like something went wrong please try again", style: TextStyle(color: revers)),
              backgroundColor: dilogbg,
              behavior: SnackBarBehavior.floating,
            )
        );
      }
    });
  }

  void _showPicker(){
    final color1 = Theme.of(context).brightness == Brightness.dark
        ? Colors.white10
        : Colors.black12;
    final inputBorder = OutlineInputBorder(
        borderSide: Divider.createBorderSide(context, color: color1,)
    );
    final dilogbg = Theme.of(context).brightness == Brightness.dark
        ? Colors.grey[900]
        : Colors.white;
    showCountryPicker(
        context: context,
        countryListTheme: CountryListThemeData(
          backgroundColor: dilogbg,
            textStyle: TextStyle(fontWeight: FontWeight.w400),
            bottomSheetHeight: MediaQuery.of(context).size.height / 2,
            borderRadius: BorderRadius.circular(10),
            inputDecoration:  InputDecoration(
              hintText: "Search",
              hintStyle: TextStyle(color: secondaryColor),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide.none,
              ),
              filled: true,
              isDense: true,
              fillColor: color1,
              contentPadding: const EdgeInsets.all(10),
              prefixIcon: Icon(CupertinoIcons.search, size: 20,color: secondaryColor),
              prefixIconConstraints: BoxConstraints(
                  minWidth: 40,
                  minHeight: 30
              ),
            )
        ),
        onSelect: (country){
          setState(() {
            this._country = country;
          });
        });
  }
  void dialogPickProfile(BuildContext context){
    final dilogbg = Theme.of(context).brightness == Brightness.dark
        ? Colors.grey[900]
        : Colors.white;
    final color1 = Theme.of(context).brightness == Brightness.dark
        ? Colors.white10
        : Colors.black12;
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text('Choose an option'),
          children: [
            SimpleDialogOption(
              onPressed: (){
                Navigator.pop(context);
                choiceImage();
              },
              child: Row(
                children: [
                  Icon(CupertinoIcons.photo),
                  SizedBox(width: 10,),
                  Text("Gallery")
                ],
              ),
            ),
            Platform.isIOS || Platform.isAndroid ?  SimpleDialogOption(
              onPressed: (){
                Navigator.pop(context);
                Get.to(()=>CameraScreen(setPicture: _setPicture,), transition: Transition.downToUp);
              },
              child: Row(
                children: [
                  Icon(CupertinoIcons.camera),
                  SizedBox(width: 10,),
                  Text("Camera")
                ],
              ),
            ) : SizedBox(),
          ],
        );
      },
    );
  }
  Future choiceImage() async {
    setState(() {
      _loading = true;
    });
    pickedImage = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageUrl = '';
      _image = File(pickedImage!.path);
      _loading = false;
    });
  }
  _setPicture(File? image){
    setState(() {
      _image = image;
    });
  }
}
