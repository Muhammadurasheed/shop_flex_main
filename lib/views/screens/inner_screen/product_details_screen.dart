import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:shop_flex/providers/cart_provider.dart';
import 'package:shop_flex/providers/selected_size_provider.dart';
import 'package:shop_flex/views/screens/inner_screen/customer_chat_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductDetailsScreen extends ConsumerStatefulWidget {
  final dynamic productData;

  const ProductDetailsScreen({super.key, required this.productData});

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends ConsumerState<ProductDetailsScreen> {
  int imageIndex = 0;

  void callVendor(String phoneNumber) async {
    String url = 'tel: $phoneNumber';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not lauch this phone number';
    }
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    final _cartNotifier = ref.read(cartProvider.notifier);
    final cartItem = ref.watch(cartProvider);
    final isInCart = cartItem.containsKey(widget.productData['productId']);
    final selectedSize = ref.watch(selectedSizeProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.productData['productName'].toUpperCase(),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 4,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 300,
                    width: MediaQuery.of(context).size.width,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.network(
                        widget.productData['productImage'][imageIndex],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 10,
                  right: 10,
                  child: Container(
                    height: 50,
                    child: ListView.builder(
                      itemCount: widget.productData['productImage'].length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                imageIndex = index;
                              });
                            },
                            child: Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.yellow.shade900),
                              ),
                              child: Image.network(
                                  widget.productData['productImage'][index]),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.productData['productName'],
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    '\$' +
                        widget.productData['productPrice'].toStringAsFixed(2),
                    style: TextStyle(
                      color: Colors.yellow.shade900,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ExpansionTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Product Description',
                    style: TextStyle(color: Colors.yellow.shade900),
                  ),
                  Text(
                    'View more',
                    style: TextStyle(color: Colors.yellow.shade900),
                  ),
                ],
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    textAlign: TextAlign.left,
                    widget.productData['description'],
                    style: TextStyle(
                        letterSpacing: 2, color: Colors.blueGrey, fontSize: 18),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            ExpansionTile(
              title: Text(
                'Variation available',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              children: [
                Container(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.productData['sizeList'].length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: OutlinedButton(
                          onPressed: () {
                            final newlySelected =
                                widget.productData['sizeList'][index];
                            ref
                                .read(selectedSizeProvider.notifier)
                                .setSelectedSize(newlySelected);
                          },
                          child: Text(
                            widget.productData['sizeList'][index].toUpperCase(),
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            ListTile(
              leading: CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(
                  widget.productData['vendorImage'],
                ),
              ),
              title: Text(
                widget.productData['businessName'],
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              subtitle: Text(
                'SEE PROFILE',
                style: TextStyle(
                  color: Colors.yellow.shade900,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 80,
            )
          ],
        ),
      ),
      bottomSheet: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: isInCart
                  ? null
                  : () {
                      _cartNotifier.addProductToCart(
                        widget.productData['productName'],
                        widget.productData['productPrice'],
                        widget.productData['productId'],
                        widget.productData['productImage'],
                        widget.productData['vendorId'],
                        selectedSize,
                         widget.productData['phoneNumber'],
                        1,
                        widget.productData['productQuantity'],
                       
                      );

                      print(
                          _cartNotifier.getCartItems.values.first.productName);
                    },
              child: Container(
                decoration: BoxDecoration(
                  color: isInCart ? Colors.grey : Colors.yellow.shade900,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(
                        CupertinoIcons.cart,
                        color: Colors.white,
                      ),
                      Text(
                        isInCart ? 'IN CART' : 'ADD TO CART',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 3,
                            fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                Get.to(
                  CustomerChatScreen(
                    vendorId: widget.productData['vendorId'],
                    buyerId: _auth.currentUser!.uid,
                    productId: widget.productData['productId'],
                    productName: widget.productData['productName'],
                  ),
                );
                print({'email address:', _auth.currentUser!.email});
              },
              icon: Icon(CupertinoIcons.chat_bubble_2_fill),
              color: Colors.yellow.shade900,
            ),
            IconButton(
              onPressed: () {
                callVendor(widget.productData['phoneNumber']);
              },
              icon: Icon(CupertinoIcons.phone),
              color: Colors.yellow.shade900,
            ),
          ],
        ),
      ),
    );
  }
}
