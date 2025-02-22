import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:shop_flex/providers/cart_provider.dart';
import 'package:shop_flex/views/screens/inner_screen/checkout_screen.dart';
import 'package:shop_flex/views/screens/inner_screen/payment_screen.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final cartData = ref.watch(cartProvider);
    final _cartFavoriteProvider = ref.read(cartProvider.notifier);
    final _totalPrice = ref.read(cartProvider.notifier).calculateTotalPrice();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cart',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            letterSpacing: 4,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _cartFavoriteProvider.clearAllCart();
            },
            icon: Icon(CupertinoIcons.delete),
          ),
        ],
      ),
      body: cartData.isNotEmpty
          ? Padding(
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
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
                                      '\$' +
                                          cartItem.productPrice
                                              .toStringAsFixed(2),
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.yellow.shade900,
                                        letterSpacing: 3,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: 40,
                                          width: 120,
                                          decoration: BoxDecoration(
                                            color: Colors.yellow.shade900,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              IconButton(
                                                onPressed: () => _cartFavoriteProvider
                                                    .decrementCartItem(
                                                        cartItem.productId),
                                                icon: Icon(
                                                  CupertinoIcons.minus,
                                                ),
                                                color: Colors.white,
                                              ),
                                              Text(
                                                cartItem.requestedQuantity
                                                    .toString(),
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: () => _cartFavoriteProvider
                                                    .incrementCartItem(
                                                        cartItem.productId),
                                                icon: Icon(
                                                  CupertinoIcons.add,
                                                ),
                                                color: Colors.white,
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            _cartFavoriteProvider.removeIndividualCart(
                                                cartItem.productId);
                                          },
                                          icon: Icon(CupertinoIcons.delete),
                                        )
                                      ],
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
            )
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 300,
                      width: MediaQuery.of(context).size.width,
                      child: Image.asset('assets/images/empty_cart.png'),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      textAlign: TextAlign.center,
                      "You don't have any item on cart yet!",
                      style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 4),
                    )
                  ],
                ),
              ),
            ),
      bottomNavigationBar: cartData.isNotEmpty
          ? Container(
              height: 80,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text(
                          'Total Price',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 4,
                          ),
                        ),
                        Text(
                          '\$' + _totalPrice.toString(),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 4,
                            color: Colors.yellow.shade900,
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Get.to(PaymentScreen());
                        },
                        child: Text(
                          'Checkout',
                          style: TextStyle(
                            letterSpacing: 4,
                            fontSize: 16,
                          ),
                        ))
                  ],
                ),
              ),
            )
          : null,
    );
  }
}
