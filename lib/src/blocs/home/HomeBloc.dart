import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:freshit_flutter/HomePage.dart';
import 'package:freshit_flutter/NotificationsPage.dart';
import 'package:freshit_flutter/SettingsPage.dart';
import 'package:freshit_flutter/WastePage.dart';
import 'package:freshit_flutter/bloc_provider.dart';
import 'package:freshit_flutter/src/blocs/home/HomeRepository.dart';
import 'package:rxdart/subjects.dart';

class HomeBloc implements BlocBase {
  final _storedItemsSubject = BehaviorSubject<QuerySnapshot>();

  Stream<QuerySnapshot> get storedItems => _storedItemsSubject.stream;
  Sink<QuerySnapshot> get _inStoredItems => _storedItemsSubject.sink;

  final pageIndexSubject = StreamController<int>();
  Stream<int> get pageIndex => pageIndexSubject.stream;
  Sink<int> get _pageIndex => pageIndexSubject.sink;

  final selectedPageController = StreamController<Widget>();
  Stream<Widget> get selectedPage => selectedPageController.stream;
  Sink<Widget> get _selectedPage => selectedPageController.sink;
  HomeRepository homeRepository;
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

  void createNewItem(
      {File image,
      String name,
      DateTime expiryDate,
      String storedIn,
      String unit,
      int quantity,
      String tags,
      String notifyPeriod,
      String timeUnit}) {
    homeRepository.createNewItem(
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
    pageIndexSubject.close();
  }
}
