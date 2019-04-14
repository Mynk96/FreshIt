import 'dart:io';

import 'package:freshit_flutter/src/blocs/home/HomeBloc.dart';
import 'package:meta/meta.dart';

abstract class AddItemScreenEvent {}

class ImageUploadedEvent extends AddItemScreenEvent {
  final File image;
  ImageUploadedEvent({@required this.image});
}

class NameInputFilled extends AddItemScreenEvent {
  final String name;
  NameInputFilled({@required this.name});
}

class QuantityAndStoredInFilled extends AddItemScreenEvent {
  final int quantity;
  final String units;
  final DateTime expiryDate;
  final int notifyPeriod;
  final String timeUnit;
  final HomeBloc homeBloc;
  final String storedIn;

  QuantityAndStoredInFilled(
      {@required this.quantity,
      @required this.units,
      @required this.expiryDate,
      @required this.notifyPeriod,
      @required this.timeUnit,
      @required this.homeBloc,
      @required this.storedIn});
}
