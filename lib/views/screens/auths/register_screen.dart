import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shop_flex/controllers/auth_controller.dart';
import 'package:shop_flex/controllers/text_form_field_controller.dart';
import 'package:shop_flex/views/screens/auths/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late String email;

  late String username;

  late String password;

  late String confirmPassword;

  Uint8List? image;

  bool _isLoading = false;

  final AuthController _authController = AuthController();

  selectGalleryImage() async {
    Uint8List _image =
        await _authController.pickProfileImage(ImageSource.gallery);
    setState(() {
      image = _image;
    });
  }

  captureImage() async {
    Uint8List _image =
        await _authController.pickProfileImage(ImageSource.camera);
    setState(() {
      image = _image;
    });
  }

  registerUser() async {
    if (image != null) {
      if (_formKey.currentState!.validate()) {
        setState(() {
          _isLoading = true;
        });
        String result = await _authController.createUser(
            email, username, password, confirmPassword, image);
        if (result == 'success') {
          setState(() {
            _isLoading = false;
          });
          Get.to(LoginScreen());
          Get.snackbar('Success', 'Account created successfully',
              backgroundColor: Colors.green, colorText: Colors.white);
        } else {
          setState(() {
          _isLoading = false;
        });
          Get.snackbar('Error occured', result.toString(),
              backgroundColor: Colors.red, colorText: Colors.white);
        }
      } else {
        return 'no image selected';
      }
    } else {
      Get.snackbar('Error occured', 'Please select image',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Register Account',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Stack(
                    children: [
                      image == null
                          ? CircleAvatar(
                              radius: 60,
                              child: Icon(
                                Icons.person,
                                size: 70,
                              ),
                            )
                          : CircleAvatar(
                              radius: 60,
                              backgroundImage: MemoryImage(image!),
                            ),
                      Positioned(
                        right: 0,
                        child: IconButton(
                          onPressed: () {
                            selectGalleryImage();
                          },
                          icon: Icon(
                            CupertinoIcons.photo,
                            size: 30,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  CreateTextFormField(
                    validationWarning: 'Username field cannot be empty',
                    fieldIcon: Icon(
                      Icons.person,
                      color: Colors.pinkAccent,
                    ),
                    label: 'Username',
                    hintText: 'Enter your username...',
                    onChanged: (value) {
                      username = value;
                    },
                  ),
                  CreateTextFormField(
                    validationWarning: 'Email field cannot be empty',
                    fieldIcon: Icon(
                      Icons.email,
                      color: Colors.pinkAccent,
                    ),
                    label: 'Email',
                    hintText: 'Enter your eamil...',
                    onChanged: (value) {
                      email = value;
                    },
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  CreateTextFormField(
                    validationWarning: 'Enter a valid password',
                    fieldIcon: Icon(
                      Icons.lock,
                      color: Colors.pinkAccent,
                    ),
                    label: 'Password',
                    hintText: 'Enter your password...',
                    onChanged: (value) {
                      password = value;
                    },
                  ),
                  CreateTextFormField(
                    validationWarning: 'Enter valid password',
                    fieldIcon: Icon(
                      Icons.lock,
                      color: Colors.pinkAccent,
                    ),
                    label: 'Confirm Password',
                    hintText: 'Enter your password...',
                    onChanged: (value) {
                      confirmPassword = value;
                    },
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  InkWell(
                    onTap: () {
                      registerUser();
                    },
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width - 40,
                      decoration: BoxDecoration(
                          color: Colors.pinkAccent,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: _isLoading
                            ? CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                'Register',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 4),
                              ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return LoginScreen();
                        }));
                      },
                      child: Text('Already have an account?')),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
