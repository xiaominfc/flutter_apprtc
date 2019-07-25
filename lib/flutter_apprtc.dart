import 'dart:async';

import 'package:flutter/services.dart';

class FlutterApprtc {
  static const MethodChannel _channel =
      const MethodChannel('flutter_apprtc');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static startRoom(String room)async {
    await _channel.invokeMethod('startRoom',{"room":room});
  }

  static configSetting()async{
    await _channel.invokeMethod('configSetting');
  }
}
