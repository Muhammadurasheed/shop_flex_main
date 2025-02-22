class FavoriteModel {
  final String productName;
  final String productId;
  final String vendorId;
  final List productImages;
  final double productPrice;
  int requestedQuantity;
  int availableQuantity;

  FavoriteModel({
    required this.productName,
    required this.productId,
    required this.vendorId,
    required this.productImages,
    required this.productPrice,
    required this.requestedQuantity,
    required this.availableQuantity,
  });
}
