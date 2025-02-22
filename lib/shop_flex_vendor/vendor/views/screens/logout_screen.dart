import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_flex/shop_flex_vendor/vendor/views/auth/vendors_auth_screen.dart';


class LogoutScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () {
          _auth.signOut();
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
            return VendorsAuthScreen();
          }));
        },
        child: Text('Sign out'),
      ),
    );
  }
}
