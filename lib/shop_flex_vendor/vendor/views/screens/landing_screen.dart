import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_flex/shop_flex_vendor/models/vendor_model.dart';
import 'package:shop_flex/shop_flex_vendor/vendor/views/auth/vendors_registration_screen.dart';
import 'package:shop_flex/shop_flex_vendor/vendor/views/screens/main_vendor_screen.dart';

class LandingScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _vendorStream =
      FirebaseFirestore.instance.collection('vendors');

  @override
  Widget build(BuildContext context) {
    final User currentUser = _auth.currentUser!;

    return StreamBuilder<DocumentSnapshot>(
      stream: _vendorStream.doc(currentUser.uid).snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Get.snackbar('Error', 'Something went wrong',
                backgroundColor: Colors.red, colorText: Colors.white);
          });
          return Scaffold(
            body: Center(child: Text('Something went wrong')),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return VendorsRegistrationScreen();
        }

        final data = snapshot.data!.data();
        if (data == null) {
          return Scaffold(
            body: Center(child: Text('Vendor data is null')),
          );
        }

        VendorOwnersModel _vendorOwnersModel =
            VendorOwnersModel.fromJson(data as Map<String, dynamic>);
        if (_vendorOwnersModel.approved) {
          return MainVendorScreen();
        }

        return Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    _vendorOwnersModel.vendorImageURL,
                    width: 90,
                  )),
              SizedBox(height: 15),
              Text(
                _vendorOwnersModel.businessName,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 15),
              Text(
                'Your application has been successfully sent to the Admin \n Admin will get back to you soon!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              TextButton(
                onPressed: () async {
                  await _auth.signOut();
                  Navigator.pop(context);
                },
                child: Text('Sign out'),
              )
            ],
          ),
        );
      },
    );
  }
}
