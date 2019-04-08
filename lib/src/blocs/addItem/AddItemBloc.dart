import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freshit_flutter/AddItemInputField.dart';
import 'package:freshit_flutter/AddItemInputOne.dart';
import 'package:freshit_flutter/bloc_provider.dart';
import 'package:freshit_flutter/src/blocs/addItem/InputEvent.dart';
//import 'package:freshit_flutter/src/blocs/addItem/OutputEvent.dart';
import 'package:freshit_flutter/src/blocs/addItem/OutputState.dart';
import 'package:freshit_flutter/src/blocs/home/HomeRepository.dart';

// class AddItemBloc extends Bloc<InputEvent, OutputState> {
//   @override
//   // TODO: implement initialState
//   OutputState get initialState => new OutputOne();

//   @override
//   Stream<OutputState> mapEventToState(InputEvent event) async* {
//     if (event is ImageInputEvent) {
//       yield OutputTwo();
//     }
//   }
class AddItemBloc extends BlocBase {
  final HomeRepository homeRepository;
  final _imageController = new StreamController<File>();
  Stream<File> get imageStream => _imageController.stream;
  Sink<File> get imageStreamSink => _imageController.sink;

  AddItemBloc(this.homeRepository) {}

  Future createNewItem(
      {File image,
      String name,
      DateTime expiryDate,
      String storedIn,
      String unit,
      int quantity,
      String tags,
      String notifyPeriod,
      String timeUnit}) async {
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

  @override
  void dispose() {
    _imageController.close();
  }
}
// final addItemScreenController = StreamController<Widget>();
// final inputController = StreamController<InputEvent>();
// String test = "a";

// AddItemBloc() {
//   inputController.stream.listen((onData) {
//     print(onData.input);
//     //print(onData.val);
//     if (onData.input == "0") {
//       print("hello");
//       //addItemScreenController.stream.drain();
//       test = "b";
//       print(test);
//       addItemScreenController.sink.add(new AddItemInputOne("1"));
//     } else if (onData.input == "1") {
//       addItemScreenController.sink
//           .add(Container(child: Text("Input Successful")));
//     }
//   });
// }

// @override
// void dispose() {
//   addItemScreenController.close();
//   inputController.close();
// }
