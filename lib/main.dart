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
  AudioPlayer audioPlayer = AudioPlayer();
  String alarmFilePath = "assets/ringtone-126505.mp3";
  Timer? vibrationTimer;

  @override
  void initState() {
    super.initState();
    AndroidAlarmManager.initialize();
  }

  void play() {
    startAlarm();
    startVib();
  }

  void stop() {
    stopAlarm();
    stopVib();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  void startAlarm() async {
    audioPlayer.play(AssetSource("ringtone-126505.mp3"));
    audioPlayer.setReleaseMode(ReleaseMode.loop);

    print("アラームを再生中");
  }

  void stopAlarm() async {
    await audioPlayer.stop();
    print("アラームを停止");
  }

  void startVib() async {
    vibrationTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      Vibration.vibrate(duration: 500);
      print("バイブレーションスタート");
    });
  }

  void stopVib() async {
    vibrationTimer?.cancel();
    await Vibration.cancel();
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
              onPressed: play,
              child: Text("Aボタン - アラーム再生"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: stop,
              child: Text("Bボタン - アラーム停止"),
            ),
          ],
        ),
      ),
    );
  }
}
