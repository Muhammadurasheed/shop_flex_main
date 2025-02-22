import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_flex/shop_flex_vendor/vendor/views/auth/vendors_auth_screen.dart';
import 'package:shop_flex/views/screens/auths/customer_login_screen.dart';
import 'package:shop_flex/views/screens/auths/welcome_screens.dart/welcome_register_screen.dart';

class WelcomeLoginScreen extends StatefulWidget {
  const WelcomeLoginScreen({super.key});

  @override
  State<WelcomeLoginScreen> createState() => _WelcomeLoginScreenState();
}

class _WelcomeLoginScreenState extends State<WelcomeLoginScreen> {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      width: screenWidth,
      height: screenHeight,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: Colors.yellow.shade900,
      ),
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Positioned(
            top: 0,
            left: -40,
            child: Image.asset(
              'assets/images/bg.png',
              width: screenWidth + 80,
              height: screenHeight + 100,
            ),
          ),
          Positioned(
            top: screenHeight * .151,
            left: screenWidth * 0.024,
            child: Image.asset('assets/images/Illustration.png'),
          ),
          Positioned(
            top: screenHeight * 0.641,
            left: screenWidth * 0.07,
            child: GestureDetector(
              onTap: () {
                 Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return CustomerLoginScreen();
                }));
              },
              child: Container(
                height: screenHeight * 0.085,
                width: screenWidth * 0.85,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(9),
                  color: Colors.white,
                ),
                child: Center(
                  child: Text(
                    'Login As Customer',
                    style: TextStyle(
                      color: Colors.black45,
                      fontSize: screenHeight * 0.022,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: screenHeight * 0.77,
            left: screenWidth * 0.07,
            child: GestureDetector(
              onTap: () {
                Get.to(VendorsAuthScreen());
              },
              child: Container(
                height: screenHeight * 0.085,
                width: screenWidth * 0.85,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(9),
                  color: Colors.white,
                ),
                child: Center(
                  child: Text(
                    'Login As Seller',
                    style: TextStyle(
                      color: Colors.black45,
                      fontSize: screenHeight * 0.022,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
              top: screenHeight * 0.88,
              left: screenWidth * 0.065,
              child: GestureDetector(
                onTap: () {
                  Get.to(WelcomeRegisterScreen());
                },
                child: Row(
                  children: [
                    Text(
                      'Need an account?',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: screenHeight * 0.022,
                      ),
                    ),
                    SizedBox(
                      width: screenHeight * 0.022,
                    ),
                    Text(
                      'Register',
                      style: TextStyle(
                        fontSize: screenHeight * 0.022,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
