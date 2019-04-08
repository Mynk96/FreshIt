import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:freshit_flutter/src/models/User.dart';
import 'package:meta/meta.dart';

class HomeRepository extends Equatable {
  final FirebaseUser user;
  final db = Firestore.instance;
  final storage = FirebaseStorage.instance;

  HomeRepository({List props = const [], @required this.user}) : super(props);

  Stream<QuerySnapshot> init() {
    return db
        .collection('Users')
        .document(user.email)
        .collection('StoredItems')
        .snapshots();
  }

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
    final StorageReference storageReference = storage.ref().child(image.path);
    final StorageUploadTask uploadTask = await storageReference.putFile(image);
    final StorageTaskSnapshot downloadUrl = await uploadTask.onComplete;
    String imageUrl = await downloadUrl.ref.getDownloadURL();
    print(downloadUrl.ref.getDownloadURL());
    DocumentReference d = await db
        .collection("Users")
        .document(user.email)
        .collection("StoredItems")
        .add({
      'name': name,
      'imageUrl': imageUrl,
      'expiryDate': expiryDate,
      'storedIn': storedIn,
      'unit': unit,
      'quantity': quantity,
      'tags': tags,
      'notifyPeriod': notifyPeriod,
      'timeUnit': timeUnit
    });
  }
}