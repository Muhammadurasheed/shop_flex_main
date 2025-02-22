import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_flex/models/cart_model.dart';

final cartProvider =
    StateNotifierProvider<CartNotifier, Map<String, CartModel>>(
        (ref) => CartNotifier());

class CartNotifier extends StateNotifier<Map<String, CartModel>> {
  CartNotifier() : super({});

  void addProductToCart(
    String productName,
    String phoneNumber,
    double productPrice,
    String productId,
    List productImageUrl,
    String vendorId,
    String productSize,
    int requestedQuantity,
    int availableQuantity,
  ) {
    if (state.containsKey(productId)) {
      state = {
        ...state,
        productId: CartModel(
          productName: state[productId]!.productName,
          productPrice: state[productId]!.productPrice,
          productId: state[productId]!.productId,
          productImages: state[productId]!.productImages,
          vendorId: state[productId]!.vendorId,
          productSize: state[productId]!.productSize,
          requestedQuantity: state[productId]!.requestedQuantity + 1,
          availableQuantity: state[productId]!.availableQuantity,
          phoneNumber: state[productId]!.phoneNumber,
        ),
      };
    } else {
      state = {
        ...state,
        productId: CartModel(
          productName: productName,
          productPrice: productPrice,
          productId: productId,
          productImages: productImageUrl,
          vendorId: vendorId,
          productSize: productSize,
          requestedQuantity: requestedQuantity,
          availableQuantity: availableQuantity,
          phoneNumber: phoneNumber,
        ),
      };
    }
  }

  void clearAllCart() {
    state.clear();
    state = {...state};
  }

  void removeIndividualCart(String productId) {
    state.remove(productId);
    state = {...state};
  }

  void incrementCartItem(String productId) {
    if (state.containsKey(productId)) {
      state[productId]!.requestedQuantity++;

      state = {...state};
    }
  }

  void decrementCartItem(String productId) {
    if (state.containsKey(productId)) {
      if (state[productId]!.requestedQuantity != 0) {
        state[productId]!.requestedQuantity--;
      }

      state = {...state};
    }
  }

  double calculateTotalPrice() {
    double totalPrice = 0.0;

    state.forEach((productId, cartItem) {
      totalPrice += cartItem.requestedQuantity * cartItem.productPrice;
    });

    return totalPrice;
  }

  Map<String, CartModel> get getCartItems => state;
}
