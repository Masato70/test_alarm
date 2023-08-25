import 'dart:async';
import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

class AlarmManager {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  AudioPlayer audioPlayer = AudioPlayer();
  String alarmFilePath = "assets/ringtone-126505.mp3";
  Timer? vibrationTimer;

  Future<void> checkAndTriggerAlarms() async {
    print("トリガー");
    playAlarm();
  }

  AlarmManager() {
    _initializeNotifications();
  }

  void _initializeNotifications() {
    final AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('huhuhuhu');

    final DarwinInitializationSettings darwinInitializationSettings =
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: androidInitializationSettings,
            iOS: darwinInitializationSettings);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: _handleNotificationAction);
  }

  Future<void> requestPermissions() async {
    print("通知のパーミッションを要求する直後");

    if (Platform.isIOS || Platform.isMacOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    } else if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      await androidImplementation?.requestPermission();
    }
  }

  Future<void> _showNotification() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      icon: "huhuhuhu",
      fullScreenIntent: true,
      enableVibration: true,
      ticker: 'ticker',
    );

    const String darwinNotificationCategoryPlain = 'plainCategory';
    const DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails(
      presentAlert: true,
      categoryIdentifier: darwinNotificationCategoryPlain,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: iosNotificationDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      'アラーム',
      'ストップ',
      notificationDetails,
      payload: 'stop_action:',
    );
  }

  Future<void> playAlarm() async {
    try {
      _showNotification();
      print("アラームを実行開始");
      play();
    } catch (e) {
      print("アラーム音の再生中にエラーが発生しました $e");
    }
  }

  void play() {
    startSound();
    startVib();
  }

  void startSound() async {
    audioPlayer.play(AssetSource("ringtone-126505.mp3"));
    audioPlayer.setReleaseMode(ReleaseMode.loop);
    print("アラームスタート");
  }

  void startVib() async {
    vibrationTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      Vibration.vibrate(duration: 500);
      print("バイブレーション開始");

      if (!timer.isActive) {
        vibrationTimer?.cancel();
        Vibration.cancel();
        print("バイブレーション停止");
      }
    });
  }

  void stop() {
    stopSound();
    stopVib();
  }

  void stopSound() async {
    await audioPlayer.stop();
    print("アラームを停止");
  }

  void stopVib() async {
    vibrationTimer?.cancel();
    await Vibration.cancel();
    print("バイブレーションを停止");
  }

  Future<void> _handleNotificationAction(NotificationResponse? payload) async {
    print("ストップ実行開始");
    stop();
  }
}
