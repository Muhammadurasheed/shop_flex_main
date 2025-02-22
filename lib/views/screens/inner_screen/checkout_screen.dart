import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_flex/providers/cart_provider.dart';
import 'package:uuid/uuid.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final cartData = ref.watch(cartProvider);
    final _cartFavoriteProvider = ref.read(cartProvider.notifier);
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final _totalPrice = ref.read(cartProvider.notifier).calculateTotalPrice();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Checkout',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 4,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: ListView.builder(
          itemCount: cartData.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final cartItem = cartData.values.toList()[index];
            return Padding(
              padding: const EdgeInsets.all(5.0),
              child: Card(
                child: SizedBox(
                  height: 150,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 100,
                          width: 100,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Image.network(
                              cartItem.productImages[0],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                cartItem.productName,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 3,
                                ),
                              ),
                              Text(
                                '\$' + cartItem.productPrice.toStringAsFixed(2),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.yellow.shade900,
                                  letterSpacing: 3,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      bottomSheet: InkWell(
        onTap: () async {
           setState(() {
              _isLoading = true;
            });
          DocumentSnapshot _userDoc = await _firestore
              .collection('buyers')
              .doc(_auth.currentUser!.uid)
              .get();
          _cartFavoriteProvider.getCartItems.forEach((key, item) async {
            final orderId = Uuid().v4();
            await _firestore.collection('orders').doc(orderId).set(
              {
                'orderId': orderId,
                'productId': item.productId,
                'price': item.requestedQuantity * item.productPrice,
                'productName': item.productName,
                'requestedQuantity': item.requestedQuantity,
                'fullName':
                    (_userDoc.data() as Map<String, dynamic>)['fullName'],
                'email': (_userDoc.data() as Map<String, dynamic>)['email'],
                'profileImageUrl': (_userDoc.data()
                    as Map<String, dynamic>)['profileImageUrl'],
                'vendorId': item.vendorId,
                'buyerId': _auth.currentUser!.uid,
                'availableQuantity': item.availableQuantity,
                'productImage': item.productImages,
                'productSize': item.productSize,
                'accepted': false,
                'dateTime': DateTime.now(),
              },
            ).whenComplete(() {
               setState(() {
              _isLoading = false;
            });
            });
          });
        },
        child: Container(
          height: 50,
          width: MediaQuery.of(context).size.width - 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.yellow.shade900,
          ),
          child: _isLoading
              ? CircularProgressIndicator(
                  color: Colors.white,
                )
              : Center(
                  child: Text(
                    'Place Order \$$_totalPrice',
                    style: TextStyle( 
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 4),
                  ),
                ),
        ),
      ),
    );
  }
}
