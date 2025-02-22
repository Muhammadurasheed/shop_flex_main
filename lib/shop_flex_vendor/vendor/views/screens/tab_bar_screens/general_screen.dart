import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_flex/shop_flex_vendor/vendor/providers/product_provider.dart';


class GeneralScreen extends StatefulWidget {
  const GeneralScreen({super.key});

  @override
  State<GeneralScreen> createState() => _GeneralScreenState();
}

class _GeneralScreenState extends State<GeneralScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<String> categoryList = [];

  _getCategories() {
    return _firestore
        .collection('categories')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          categoryList.add(doc['categoryName']);
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _getCategories();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final ProductProvider _productProvider =
        Provider.of<ProductProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            TextFormField(
              validator: (value) {
                if(value!.isEmpty) {
                  return 'The product name is required';
                } else {
                  return null;
                }
              },
              onChanged: (value) {
                _productProvider.getFormData(productName: value);
              },
              decoration: InputDecoration(
                  labelText: 'Enter the Product name',
                  labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4,
                      color: Colors.grey)),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
               validator: (value) {
                if(value!.isEmpty) {
                  return 'The product price is required';
                } else {
                  return null;
                }
              },
              onChanged: (value) {
                _productProvider.getFormData(productPrice: double.parse(value));
              },
              decoration: InputDecoration(
                  labelText: 'Enter the Product price',
                  labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4,
                      color: Colors.grey)),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
               validator: (value) {
                if(value!.isEmpty) {
                  return 'The product quantity is required';
                } else {
                  return null;
                }
              },
              onChanged: (value) {
                _productProvider.getFormData(productQuantity: int.parse(value));
              },
              decoration: InputDecoration(
                  labelText: 'Enter the Product quantity',
                  labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4,
                      color: Colors.grey)),
            ),
            SizedBox(
              height: 20,
            ),
            DropdownButtonFormField(
               validator: (value) {
                if(value!.isEmpty) {
                  return 'Select a category';
                } else {
                  return null;
                }
              },
              hint: Text(
                'Select Category',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                ),
              ),
              items:
                  categoryList.map<DropdownMenuItem<dynamic>>((categoryName) {
                return DropdownMenuItem(
                  child: Text(categoryName),
                  value: categoryName,
                );
              }).toList(),
              onChanged: (value) {
                _productProvider.getFormData(category: value);
              },
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              onChanged: (value) {
                _productProvider.getFormData(description: value);
              },
              maxLength: 800,
              maxLines: 10,
              minLines: 3,
              decoration: InputDecoration(
                  labelText: 'Product Description',
                  labelStyle: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.grey)),
            ),
          ],
        ),
      ),
    );
  }
}
