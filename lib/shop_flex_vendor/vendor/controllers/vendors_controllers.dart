import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class VendorsControllers {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  pickImage(ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();

    XFile? _file = await _imagePicker.pickImage(source: source);
    if (_file != null) {
      return await _file.readAsBytes();
    } else {
      print('no image selected');
    }
  }

  Future<String> uploadVendorsImageToStorage(dynamic image) async {
    Reference ref =
        _storage.ref().child("venodor's image").child(_auth.currentUser!.uid);
    UploadTask uploadTask = ref.putData(image);
    TaskSnapshot snapshot = await uploadTask;
    String imageURL = await snapshot.ref.getDownloadURL();
    return imageURL;
  }

  Future <bool> checkIfUserEmailAlreadyExist(String email) async {
    final querySnapshot = await _firestore
        .collection('vendors')
        .where('emailAddress', isEqualTo: email)
        .get();
        return querySnapshot.docs.isEmpty;
  }

  Future<String> saveVendorsInfoToCloud({
    required Uint8List vendorImage,
    required String businessName,
    required String emailAddress,
    required String phoneNumber,
    required String countryValue,
    required String stateValue,
    required String cityValue,
    String? vendorId,
  }) async {
    String result = 'something went wrong';
    String imageURL = await uploadVendorsImageToStorage(vendorImage);
    try {
        await _firestore.collection('vendors').doc(_auth.currentUser!.uid).set(
        {
          'businessName': businessName,
          'emailAddress': emailAddress,
          'phoneNumber': phoneNumber,
          'countryValue': countryValue,
          'stateValue': stateValue,
          'cityValue': cityValue,
          'vendorId': _auth.currentUser!.uid,
          'vendorImageURL': imageURL,
          'approved': false,
        },
      );
      result = 'success';
      
    } catch (e) {
      result = e.toString();
    }
    return result;
  }
}
