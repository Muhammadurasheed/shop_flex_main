class CartModel {
  final String productName;
  final double productPrice;
  final String productId;
  final List productImages;
  final String vendorId;
  final String productSize;
  final String phoneNumber;
  int requestedQuantity;
  int availableQuantity;

  CartModel({
    required this.productName,
    required this.productPrice,
    required this.productId,
    required this.productImages,
    required this.vendorId,
    required this.productSize,
    required this.requestedQuantity,
    required this.availableQuantity,
    required this.phoneNumber,
  });
}
