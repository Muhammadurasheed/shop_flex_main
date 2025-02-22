import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:shop_flex/views/screens/inner_screen/checkout_screen.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool isPayOnDelivery = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Payment Options',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black45,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Select Payment Method',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black87,
                letterSpacing: 4,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Pay on delivery',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Switch(
                  value: isPayOnDelivery,
                  onChanged: (value) {
                    setState(() {
                      isPayOnDelivery = value;
                    });
                    if(isPayOnDelivery) {
                      Get.to(CheckoutScreen());
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
