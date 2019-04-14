import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:freshit_flutter/HomePage.dart';
import 'package:freshit_flutter/Repositories/HomeRepository.dart';
import 'package:freshit_flutter/SettingsPage.dart';
import 'package:freshit_flutter/bloc_provider.dart';
import 'package:rxdart/subjects.dart';

class HomeBloc implements BlocBase {
  final _storedItemsSubject = BehaviorSubject<QuerySnapshot>();

  Stream<QuerySnapshot> get storedItems => _storedItemsSubject.stream;
  Sink<QuerySnapshot> get _inStoredItems => _storedItemsSubject.sink;

  final pageIndexSubject = StreamController<int>();
  Stream<int> get pageIndex => pageIndexSubject.stream;

  final selectedPageController = StreamController<Widget>();
  Stream<Widget> get selectedPage => selectedPageController.stream;
  Sink<Widget> get _selectedPage => selectedPageController.sink;
  HomeRepository homeRepository;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  HomeBloc(HomeRepository h) {
    homeRepository = h;
    h.init().listen((onData) => _inStoredItems.add(onData));

    pageIndex.listen((onData) {
      switch (onData) {
        case 0:
          {
            _selectedPage.add(HomePage());
            break;
          }
        case 1:
          {
            _selectedPage.add(SettingsPage());
            break;
          }
        default:
          break;
      }
    });
  }

  void initializeNotificationsPlugin() {
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future<bool> createNewItem(
      {File image,
      String name,
      DateTime expiryDate,
      String storedIn,
      String unit,
      int quantity,
      String tags,
      int notifyPeriod,
      String timeUnit}) async {
    return await homeRepository.createNewItem(
        image: image,
        name: name,
        expiryDate: expiryDate,
        storedIn: storedIn,
        unit: unit,
        quantity: quantity,
        tags: tags,
        notifyPeriod: notifyPeriod,
        timeUnit: timeUnit);
  }

  void useItem(String id) {
    homeRepository.useItem(id);
  }

  @override
  void dispose() {
    _storedItemsSubject.close();
    selectedPageController.close();
    pageIndexSubject.close();
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    await Future.delayed(Duration(seconds: 3));
  }

  Future scheduleNotifications(DocumentSnapshot item, int index) async {
    var scheduledNotificationDateTime = calculateSchedulingDateTime(
        item.data["expiryDate"],
        item.data["notifyPeriod"],
        item.data["timeUnit"]);
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your other channel id',
        'your other channel name',
        'your other channel description');
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    NotificationDetails platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
        index,
        item.data["name"],
        "stored in ${item.data["storedIn"]} will expire in ${item.data["notifyPeriod"]} ${item.data["timeUnit"]}",
        scheduledNotificationDateTime,
        platformChannelSpecifics);
    print("hello");
  }

  DateTime calculateSchedulingDateTime(
      Timestamp t, int notifyPeriod, String units) {
    int millis = 0;
    if (units == "days")
      millis = (notifyPeriod) * 86400000;
    else if (units == "hours")
      millis = (notifyPeriod) * 3600000;
    else
      millis = (notifyPeriod) * 60000;
    int expiryTime = t.toDate().millisecondsSinceEpoch;
    print(expiryTime - millis);
    print(DateTime.now().millisecondsSinceEpoch);
    if ((expiryTime - millis) < DateTime.now().millisecondsSinceEpoch)
      return DateTime.fromMillisecondsSinceEpoch(expiryTime - 3600000);
    return DateTime.fromMillisecondsSinceEpoch(expiryTime - millis);
  }

  void cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
    print("hello");
  }
}
