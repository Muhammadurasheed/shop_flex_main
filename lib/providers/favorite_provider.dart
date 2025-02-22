import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_flex/models/favorite_model.dart';

final favoriteProvider =
    StateNotifierProvider<FavoriteNotifier, Map<String, FavoriteModel>>(
        (ref) => FavoriteNotifier());

class FavoriteNotifier extends StateNotifier<Map<String, FavoriteModel>> {
  FavoriteNotifier() : super({});

  void addToFavorite({
    required String productName,
    required String productId,
    required String vendorId,
    required List productImages,
    required double productPrice,
    required int requestedQuantity,
    required int availableQuantity,
  }) {
    state = {
      ...state,
      productId: FavoriteModel(
        productName: productName,
        productId: productId,
        vendorId: vendorId,
        productImages: productImages,
        productPrice: productPrice,
        requestedQuantity: requestedQuantity,
        availableQuantity: availableQuantity,
      )
    };
  }

  void clearAllFavorites() {
    state.clear();
    state = {...state};
  }

  void removeIndividualFavoriteItem(String productId) {
    state.remove(productId);
    state = {...state};
  }
  Map<String, FavoriteModel> get getFavoriteItem => state;
}
