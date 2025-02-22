import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_flex/shop_flex_vendor/vendor/views/auth/vendors_registration_screen.dart';
import 'package:shop_flex/views/screens/auths/customer_register_screen.dart';
import 'package:shop_flex/views/screens/auths/welcome_screens.dart/welcome_login_screen.dart';

class WelcomeRegisterScreen extends StatefulWidget {
  const WelcomeRegisterScreen({super.key});

  @override
  State<WelcomeRegisterScreen> createState() => _WelcomeRegisterScreenState();
}

class _WelcomeRegisterScreenState extends State<WelcomeRegisterScreen> {
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
            top: screenHeight * 0.151,
            left: screenHeight * 0.024,
            child: Image.asset('assets/images/Illustration.png'),
          ),
          Positioned(
            top: screenHeight * 0.641,
            left: screenWidth * 0.07,
            child: GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return CustomerRegisterScreen();
                }));
              },
              child: Container(
                height: screenHeight * 0.085,
                width: screenWidth * 0.85,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Center(
                  child: Text(
                    'Register As Customer',
                    style: TextStyle(
                      color: Colors.black45,
                      fontSize: 18,
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
                Get.to(VendorsRegistrationScreen());
              },
              child: Container(
                height: screenHeight * 0.085,
                width: screenWidth * 0.85,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Center(
                  child: Text(
                    'Register As Seller',
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
                  Get.to(WelcomeLoginScreen());
                },
                child: Row(
                  children: [
                    Text(
                      'Already have an account?',
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
                      'Login',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: screenHeight * 0.022,
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
