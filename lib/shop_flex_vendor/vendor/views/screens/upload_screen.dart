import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:shop_flex/shop_flex_vendor/vendor/providers/product_provider.dart';
import 'package:shop_flex/shop_flex_vendor/vendor/views/screens/tab_bar_screens/attributes_screen.dart';
import 'package:shop_flex/shop_flex_vendor/vendor/views/screens/tab_bar_screens/general_screen.dart';
import 'package:shop_flex/shop_flex_vendor/vendor/views/screens/tab_bar_screens/image_screen.dart';
import 'package:shop_flex/shop_flex_vendor/vendor/views/screens/tab_bar_screens/shipping_screen.dart';

import 'package:uuid/uuid.dart';

class UploadScreen extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final ProductProvider _productProvider =
        Provider.of<ProductProvider>(context);
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(child: Text('General')),
              Tab(child: Text('Shipping')),
              Tab(child: Text('Attribute')),
              Tab(child: Text('Image')),
            ],
          ),
        ),
        body: Form(
          key: _formKey,
          child: TabBarView(
            children: [
              GeneralScreen(),
              ShippingScreen(),
              AttributesScreen(),
              ImageScreen(),
            ],
          ),
        ),
        bottomSheet: Padding(
          padding: const EdgeInsets.all(15.0),
          child: InkWell(
            onTap: () async {
              DocumentSnapshot userDoc = await _firestore
                  .collection('vendors')
                  .doc(_auth.currentUser!.uid)
                  .get();
              final productId = Uuid().v4();
              if (_formKey.currentState!.validate()) {
                EasyLoading.show(status: 'Uploading...');
                await _firestore.collection('products').doc(productId).set({
                  'productId': productId,
                  'productName': _productProvider.productData['productName'],
                  'productPrice': _productProvider.productData['productPrice'],
                  'productQuantity':
                      _productProvider.productData['productQuantity'],
                  'category': _productProvider.productData['category'],
                  'description': _productProvider.productData['description'],
                  'ShippingChargeFee':
                      _productProvider.productData['ShippingChargeFee'],
                  'chargeShipping':
                      _productProvider.productData['chargeShipping'],
                  'brandName': _productProvider.productData['brandName'],
                  'sizeList': _productProvider.productData['sizeList'],
                  'productImage': _productProvider.productData['imageUrl'],
                  'vendorId': _auth.currentUser!.uid,
                  'businessName':
                      (userDoc.data() as Map<String, dynamic>)['businessName'],
                  'vendorImage': (userDoc.data()
                      as Map<String, dynamic>)['vendorImageURL'],
                  'countryValue':
                      (userDoc.data() as Map<String, dynamic>)['countryValue'],
                  'cityValue':
                      (userDoc.data() as Map<String, dynamic>)['cityValue'],
                  'stateValue':
                      (userDoc.data() as Map<String, dynamic>)['stateValue'],
                }).whenComplete(() {
                  EasyLoading.showSuccess('Done!');
                  EasyLoading.dismiss();
                });
                _productProvider.clearData();
              } else {
                print('not validated');
              }
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.yellow.shade900,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  'Upload Product',
                  style: TextStyle(
                    letterSpacing: 5,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
