import 'dart:io';

import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;


import '../api/api_service.dart';
import '../main.dart';

class SocketManager extends GetxController {
  late IO.Socket _socket;

  SocketManager._();

  static final SocketManager _instance = SocketManager._();

  factory SocketManager() {
    return _instance;
  }

  IO.Socket get socket => _socket;
  bool isConnected = false;


  void connect(){
    _socket = IO.io("http://$domain:3000", <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
    });
    _socket.connect();
    _socket.on("connect", (data) {
      print("Connected");
      _socket.emit("signin", currentUser.uid);
    });

    _socket.on("disconnect", (_) {
      if(currentUser.uid!=""){
        print("Disconnected. Reconnecting : ${DateTime.now().toString().substring(10, 16)}");
        Future.delayed(Duration(seconds: 1), () {
          _socket.connect();
        });
      }
    });
    _socket.on("connect_error", (err) {
      print("Connection error: $err");
    });
    print('${_socket.connected}: ${DateTime.now().toString().substring(10, 16)}');
  }

  Future<void> initPlatform()async{
    if(Platform.isAndroid || Platform.isIOS){
      await OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
      await OneSignal.Debug.setAlertLevel(OSLogLevel.none);
      OneSignal.initialize("091a8f82-7499-4bcf-b3e8-1b9367d7450c");
      await OneSignal.Notifications.requestPermission(true);
      await OneSignal.User.getOnesignalId().then((value){
        APIService().getUserData(value!);
      });
    }
  }
}