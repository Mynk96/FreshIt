import 'dart:io';

import 'package:equatable/equatable.dart';

class FormData extends Equatable {
  File image;
  String name;
  int quantity;
  String units;
  String timeUnit;
  int notifyPeriod;
  DateTime expiryDate;
  String storedIn;
  String tags;
}
