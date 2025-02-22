import 'package:flutter/material.dart';

class ProductProvider with ChangeNotifier {
  Map<String, dynamic> productData = {};
  getFormData({
    String? productName,
    double? productPrice,
    int? productQuantity,
    String? category,
    String? description,
    double? ShippingChargeFee,
    bool? chargeShipping,
    String? brandName,
    List<String>? sizeList,
    List<String>? imageUrlList,
  }) {
    if (productName != null) {
      productData['productName'] = productName;
    }
    if (productPrice != null) {
      productData['productPrice'] = productPrice;
    }
    if (productQuantity != null) {
      productData['productQuantity'] = productQuantity;
    }
    if (category != null) {
      productData['category'] = category;
    }
    if (description != null) {
      productData['description'] = description;
    }
    if (ShippingChargeFee != null) {
      productData['ShippingChargeFee'] = ShippingChargeFee;
    }
    if (chargeShipping != null) {
      productData['chargeShipping'] = chargeShipping;
    }
    if (brandName != null) {
      productData['brandName'] = brandName;
    }
    if (sizeList != null) {
      productData['sizeList'] = sizeList;
    }
    if (imageUrlList != null) {
      productData['imageUrl'] = imageUrlList;
    }
    notifyListeners();
  }

  clearData() {
    productData.clear();
    notifyListeners();
  }
}
