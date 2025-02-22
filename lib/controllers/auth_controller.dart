import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future uploadImageToStorage(Uint8List? image) async {
    Reference ref = _firebaseStorage
        .ref()
        .child('profileImage')
        .child(_auth.currentUser!.uid);
    UploadTask uploadTask = ref.putData(image!);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future pickProfileImage(ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();
    XFile? _file = await _imagePicker.pickImage(source: source);
    if (_file != null) {
      return await _file.readAsBytes();
    } else {
      print('no image selected or captured');
    }
  }

  Future<String> createUser(String email, String fullName, String password,
      String confirmPassword, Uint8List? image) async {
    String result = 'some errors occured';
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      String profileImageUrl = await uploadImageToStorage(image);

      await _firestore.collection('buyers').doc(userCredential.user!.uid).set({
        'fullName': fullName,
        'email': email,
        'buyerId': userCredential.user!.uid,
        'profileImageUrl': profileImageUrl,
      });
      result = 'success';
    } catch (e) {
      result = e.toString();
    }

    return result;
  }

  /// Function to login Users

  Future loginUser(String email, String password) async {
    String result = 'some error occured';
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      result = 'success';
    } catch (e) {
      result = e.toString();
    }
    return result;
  }
}
