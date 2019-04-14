import 'package:bloc/bloc.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:freshit_flutter/src/blocs/addItemScreenBloc/addItemScreenEvent.dart';
import 'package:freshit_flutter/src/blocs/addItemScreenBloc/addItemScreenState.dart';
import 'package:freshit_flutter/src/blocs/home/HomeBloc.dart';
import 'package:freshit_flutter/src/models/FormData.dart';

class AddItemScreenBloc extends Bloc<AddItemScreenEvent, AddItemScreenState> {
  FormData formData;

  @override
  get initialState {
    formData = new FormData();
    return InitialState();
  }

  // List<String> labels = [
  //   "Watermelon",
  //   "Fruits",
  //   "mango",
  //   "strawberry",
  //   "banana",
  //   "pineapple"
  // ];
  @override
  Stream<AddItemScreenState> mapEventToState(AddItemScreenEvent event) async* {
    if (event is ImageUploadedEvent) {
      formData.image = event.image;
      final FirebaseVisionImage visionImage =
          FirebaseVisionImage.fromFile(event.image);
      final ImageLabeler labelDetector = FirebaseVision.instance.imageLabeler();
      final List<ImageLabel> labels =
          await labelDetector.processImage(visionImage);

      List<String> a = [];
      for (ImageLabel label in labels) {
        a.add(label.text);
        print(label.text);
      }
      yield ShowImageAndPredictions(image: event.image, labels: a);
    } else if (event is NameInputFilled) {
      formData.name = event.name;
      yield ShowQuantityAndStoredInFields();
    } else if (event is QuantityAndStoredInFilled) {
      formData.quantity = event.quantity;
      formData.notifyPeriod = event.notifyPeriod;
      formData.timeUnit = event.timeUnit;
      formData.units = event.units;
      formData.storedIn = event.storedIn;
      formData.expiryDate = event.expiryDate;
      HomeBloc h = event.homeBloc;
      bool isItemUploaded = await h.createNewItem(
          image: formData.image,
          expiryDate: formData.expiryDate,
          name: formData.name,
          notifyPeriod: formData.notifyPeriod,
          quantity: formData.quantity,
          storedIn: formData.storedIn,
          tags: "Fruits",
          timeUnit: formData.timeUnit,
          unit: formData.units);
      if (isItemUploaded)
        yield SuccessAndPop();
      else
        yield InitialState();
    } else {
      yield SuccessAndPop();
    }
  }
}
