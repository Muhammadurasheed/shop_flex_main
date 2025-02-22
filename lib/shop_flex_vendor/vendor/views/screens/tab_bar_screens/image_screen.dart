import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shop_flex/shop_flex_vendor/vendor/providers/product_provider.dart';
import 'package:uuid/uuid.dart';

class ImageScreen extends StatefulWidget {
  const ImageScreen({super.key});

  @override
  State<ImageScreen> createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen>
    with AutomaticKeepAliveClientMixin {
  bool get wantKeepAlive => true;
  final ImagePicker _imagePicker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;

  List<File> imageList = [];
  List<String> imageUrlList = [];

  chooseImage() async {
    final pickedImage =
        await _imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedImage == null) {
      print('No image picked');
    } else {
      setState(() {
        imageList.add(
          File(pickedImage.path),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final ProductProvider _productProvider =
        Provider.of<ProductProvider>(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            GridView.builder(
              shrinkWrap: true,
              itemCount: imageList.length + 1,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) {
                return index == 0
                    ? Center(
                        child: IconButton(
                          onPressed: () {
                            chooseImage();
                          },
                          icon: Icon(
                            Icons.add,
                            size: 50,
                          ),
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: FileImage(
                              imageList[index - 1],
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
              },
            ),
            if(imageList.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                onPressed: () async {
                  if(imageList.isEmpty) {
                    Get.snackbar('', 'Please select an image');
                  }
                  EasyLoading.show(status: 'PLEASE WAIT');
                  for (var image in imageList) {
                    Reference ref =
                        _storage.ref().child('productImage').child(Uuid().v4());
                    await ref.putFile(image).whenComplete(() async {
                      await ref.getDownloadURL().then((value) {
                        setState(() {
                          imageUrlList.add(value);
                        });
                      });
                    });
                    _productProvider.getFormData(imageUrlList: imageUrlList);
                    EasyLoading.dismiss();
                    EasyLoading.showSuccess('DONE');
                  }
                  ;
                },
                child: Text('Upload Image'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
