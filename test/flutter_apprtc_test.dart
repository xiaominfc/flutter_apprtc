import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_apprtc/flutter_apprtc.dart';

void main() {
  const MethodChannel channel = MethodChannel('flutter_apprtc');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await FlutterApprtc.platformVersion, '42');
  });
}
