import 'dart:async';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'alarm_manager.dart';


void backgroundAlarmCallback() async {
  print("_backgroundAlarmCallbackよばれた");
  AlarmManager alarmManager = AlarmManager();
  alarmManager.checkAndTriggerAlarms();
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());

  const alarmId = 0;
  const duration = Duration(seconds: 10);
  AndroidAlarmManager.periodic(
    duration,
    alarmId,
    backgroundAlarmCallback,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    AlarmManager alarmManager = AlarmManager();
    alarmManager.requestPermissions();

    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  AlarmManager alarmManager = AlarmManager();

  @override
  void initState() {
    super.initState();
    AndroidAlarmManager.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("アラームアプリ"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed:alarmManager.play,
              child: Text("Aボタン - アラーム再生"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: alarmManager.stop,
              child: Text("Bボタン - アラーム停止"),
            ),
          ],
        ),
      ),
    );
  }
}
