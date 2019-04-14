import 'dart:io';

import 'package:meta/meta.dart';

abstract class AddItemScreenState {}

class InitialState extends AddItemScreenState {
  @override
  String toString() => "Initial State";
}

class ShowImageAndPredictions extends AddItemScreenState {
  final File image;
  final List<String> labels;
  ShowImageAndPredictions({@required this.image, @required this.labels});
}

class ShowQuantityAndStoredInFields extends AddItemScreenState {}

class ShowExpiryAndNotificationsFields extends AddItemScreenState {}

class SuccessAndPop extends AddItemScreenState {}
