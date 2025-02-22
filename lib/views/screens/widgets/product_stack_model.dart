import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:shop_flex/providers/favorite_provider.dart';
import 'package:shop_flex/views/screens/inner_screen/product_details_screen.dart';

class ProductStackModel extends ConsumerStatefulWidget {
  const ProductStackModel({
    super.key,
    required this.productData,
  });

  final QueryDocumentSnapshot<Object?> productData;

  @override
  _ProductStackModelState createState() => _ProductStackModelState();
}

class _ProductStackModelState extends ConsumerState<ProductStackModel> {
  @override
  Widget build(BuildContext context) {
    final _favoriteProvider = ref.read(favoriteProvider.notifier);
    ref.watch(favoriteProvider);
    return GestureDetector(
      onTap: () {
        Get.to(ProductDetailsScreen(
          productData: widget.productData,
        ));
      },
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              height: 90,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xfffffff),
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x0f000000),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          widget.productData['productImage'][0],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          widget.productData['productName'],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                            color: Color(0xff000000),
                          ),
                          softWrap: false,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          '\$' +
                              ' ' +
                              widget.productData['productPrice']
                                  .toStringAsFixed(2),
                          style: TextStyle(
                            color: Colors.yellow.shade900,
                            fontSize: 18,
                            letterSpacing: 4,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 15,
            top: 27,
            child: IconButton(
              onPressed: () {
                _favoriteProvider.addToFavorite(
                  productName: widget.productData['productName'],
                  productId: widget.productData['productId'],
                  vendorId: widget.productData['vendorId'],
                  productImages: widget.productData['productImage'],
                  productPrice: widget.productData['productPrice'],
                  requestedQuantity: 1,
                  availableQuantity: widget.productData['productQuantity'],
                );
              },
              icon: _favoriteProvider.getFavoriteItem.containsKey(widget.productData['productId'])? Icon(
                Icons.favorite,
                color: Colors.red,
              ) : Icon(
                Icons.favorite_border,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
