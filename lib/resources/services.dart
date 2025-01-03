import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../main.dart';
import '../model/users.dart';

class Services{
  static String HOST = "http://${domain}/Chess/";

  static var _USERS = HOST + 'users.php';

  static const String _REGISTER  = 'REGISTER';
  static const String _LOGIN  = 'LOGIN';
  static const String _LOGIN_EMAIL  = 'LOGIN_EMAIL';
  static const String _GET  = 'GET';
  static const String _UPDATE_TOKEN  = 'UPDATE_TOKEN';
  static const String _UPDATE_PASS  = 'UPDATE_PASS';

  // Method to create the table Users.
  List<UserModel> userFromJson(String jsonString) {
    final data = json.decode(jsonString);
    return List<UserModel>.from(data.map((item)=>UserModel.fromJson(item)));
  }

  // GET LOGGED IN USER
  Future<List<UserModel>> getUser(String email)async{
    var map = new Map<String, dynamic>();
    map["action"] = _GET;
    map["email"] = email;
    final response = await http.post(Uri.parse(_USERS),body: map);
    if(response.statusCode==200) {
      List<UserModel> user = userFromJson(response.body);
      return user;
    } else {
      return <UserModel>[];
    }
  }

  // REGISTER USER
  static Future registerUsers(String uid, String username, String first, String last, String email, String phone, String password, File? image, String url,String status, String token, String country) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(_USERS));
      request.fields['action'] = _REGISTER;
      request.fields['uid'] = uid;
      request.fields['username'] = username;
      request.fields['first'] = first;
      request.fields['last'] = last;
      request.fields['email'] = email;
      request.fields['phone'] = phone;
      request.fields['password'] = password;
      request.fields['status'] = status;
      request.fields['token'] = token;
      request.fields['country'] = country;
      if (image != null) {
        var pic = await http.MultipartFile.fromPath("image", image.path);
        request.files.add(pic);
      } else {
        request.fields['image'] = url;
      }
      var response = await request.send();
      return response;
    } catch (e) {
      return 'error';
    }
  }

  // LOGIN USERS
  static Future<String> loginUsers(String email, String password) async {
    try {
      var map = new Map<String, dynamic>();
      map["action"] = _LOGIN;
      map["email"] = email;
      map["password"] = password;
      final response = await http.post(Uri.parse(_USERS), body: map);
      return response.body;
    } catch (e) {
      return 'error : ${e}';
    }
  }

  // LOGIN USERS WITH EMAIL
  static Future<String> loginUserWithEmail(String email) async {
    try {
      var map = new Map<String, dynamic>();
      map["action"] = _LOGIN_EMAIL;
      map["email"] = email;
      final response = await http.post(Uri.parse(_USERS), body: map);
      return response.body;
    } catch (e) {
      return 'error : ${e}';
    }
  }


  // UPDATE USER TOKEN
  static Future<String> updateToken(String uid,String token) async {
    try {
      var map = new Map<String, dynamic>();
      map["action"] = _UPDATE_TOKEN;
      map["uid"] = uid;
      map["token"] = token;
      final response = await http.post(Uri.parse(_USERS), body: map);
      return response.body;
    } catch (e) {
      return 'error';
    }
  }

  // UPDATE USER PASSWORD
  static Future<String> updatePassword(String uid,String password) async {
    try {
      var map = new Map<String, dynamic>();
      map["action"] = _UPDATE_PASS;
      map["uid"] = uid;
      map["password"] = password;
      final response = await http.post(Uri.parse(_USERS), body: map);
      return response.body;
    } catch (e) {
      return 'error';
    }
  }
}