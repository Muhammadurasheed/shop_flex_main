import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shop_flex/shop_flex_vendor/vendor/views/screens/earning_screen.dart';
import 'package:shop_flex/shop_flex_vendor/vendor/views/screens/edit_screen.dart';
import 'package:shop_flex/shop_flex_vendor/vendor/views/screens/logout_screen.dart';
import 'package:shop_flex/shop_flex_vendor/vendor/views/screens/upload_screen.dart';
import 'package:shop_flex/shop_flex_vendor/vendor/views/screens/vendor_order_screen.dart';
import 'package:shop_flex/shop_flex_vendor/vendor/views/screens/vendor_recent_message.dart';


class MainVendorScreen extends StatefulWidget {
  const MainVendorScreen({super.key});

  @override
  State<MainVendorScreen> createState() => _MainVendorScreenState();
}

class _MainVendorScreenState extends State<MainVendorScreen> {
  int _pageIndex = 0;
  List<Widget> _pages = [
    EarningScreen(),
    UploadScreen(),
    VendorOrderScreen(),
    VendorRecentMessage(),
    EditProductScreen(),
    LogoutScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          setState(() {
            _pageIndex = value;
          });
        },
        currentIndex: _pageIndex,
        selectedItemColor: Colors.yellow.shade900,
        unselectedItemColor: Colors.black,
        items: [
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.money_dollar), label: 'Earnings'),
          BottomNavigationBarItem(icon: Icon(Icons.upload), label: 'Upload'),
          BottomNavigationBarItem(icon: Icon(Icons.shop), label: 'Orders'),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Messages'),
          BottomNavigationBarItem(
              icon: Icon(Icons.edit), label: 'Edit Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.logout), label: 'Logout'),
        ],
      ),
      body: _pages[_pageIndex],
    );
  }
}
