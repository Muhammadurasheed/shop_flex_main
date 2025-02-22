import 'dart:typed_data';

import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shop_flex/shop_flex_vendor/vendor/controllers/vendors_controllers.dart';


class VendorsRegistrationScreen extends StatefulWidget {
  @override
  State<VendorsRegistrationScreen> createState() =>
      _VendorsRegistrationScreenState();
}

class _VendorsRegistrationScreenState extends State<VendorsRegistrationScreen> {
  final VendorsControllers _vendorsControllers = VendorsControllers();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? countryValue;
  String? stateValue;
  String? cityValue;
  String? businessName;
  String? phoneNumber;
  String? emailAddress;
  Uint8List? _image;

  selectFromGallery() async {
    Uint8List _img = await _vendorsControllers.pickImage(ImageSource.gallery);
    setState(() {
      _image = _img;
    });
  }

  Widget textFormField({
    String? labelText,
    String? hintText,
    TextInputType? keyboardType,
    required void Function(String?) onChanged,
  }) {
    return TextFormField(
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return '$labelText is required';
          } else {
            return null;
          }
        },
        onChanged: onChanged);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.pinkAccent,
            toolbarHeight: 200,
            flexibleSpace: LayoutBuilder(
              builder: (context, constraints) {
                return FlexibleSpaceBar(
                  background: Container(
                    alignment: Alignment.center,
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white),
                      ),
                      child: _image != null
                          ? CircleAvatar(
                              backgroundImage: MemoryImage(_image!),
                              radius: 50,
                            )
                          : IconButton(
                              onPressed: () {
                                selectFromGallery();
                              },
                              icon: Icon(
                                CupertinoIcons.photo,
                                color: Colors.white,
                                size: 65,
                              ),
                            ),
                    ),
                  ),
                );
              },
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    textFormField(
                      keyboardType: TextInputType.name,
                      labelText: 'Business Name',
                      hintText: 'Business Name',
                      onChanged: (value) {
                        businessName = value;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    textFormField(
                      keyboardType: TextInputType.emailAddress,
                      labelText: 'Email Address',
                      hintText: 'Email Address',
                      onChanged: (value) {
                        emailAddress = value;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    textFormField(
                      keyboardType: TextInputType.phone,
                      labelText: 'Phone Number',
                      hintText: 'Phone Number',
                      onChanged: (value) {
                        phoneNumber = value;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CSCPicker(
                      onCountryChanged: (value) {
                        setState(() {
                          countryValue = value;
                        });
                      },
                      onStateChanged: (value) {
                        setState(() {
                          stateValue = value;
                        });
                      },
                      onCityChanged: (value) {
                        setState(() {
                          cityValue = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () async {
            if (_formKey.currentState!.validate() && _image != null) {
              bool vendorStatus = await _vendorsControllers
                  .checkIfUserEmailAlreadyExist(emailAddress!);
              if (!vendorStatus) {
                Get.snackbar('Registration Declined', 'Vendor already exist!',
                    backgroundColor: Colors.red, colorText: Colors.white);
              } else {
                EasyLoading.show(status: 'saving...');
                _vendorsControllers
                    .saveVendorsInfoToCloud(
                  vendorImage: _image!,
                  businessName: businessName!,
                  emailAddress: emailAddress!,
                  phoneNumber: phoneNumber!,
                  countryValue: countryValue!,
                  stateValue: stateValue!,
                  cityValue: cityValue!,
                )
                    .whenComplete(() {
                  EasyLoading.dismiss();
                  EasyLoading.showSuccess('uploaded🤗');
                  _formKey.currentState!.reset();
                  setState(() {
                    _image = null;
                  });
                });
              }
            } else {
              Get.snackbar(
                'Error',
                'Vendor image is required',
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
            }
          },
          child: Container(
            height: 50,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Colors.pinkAccent,
                borderRadius: BorderRadius.circular(8)),
            child: Center(
              child: Text(
                'Save',
                style: TextStyle(
                    color: Colors.white,
                    letterSpacing: 4,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
