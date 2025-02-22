import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop_flex/views/screens/account_screen.dart';
import 'package:shop_flex/views/screens/cart_screen.dart';
import 'package:shop_flex/views/screens/category_screen.dart';
import 'package:shop_flex/views/screens/favorite_screen.dart';
import 'package:shop_flex/views/screens/home_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int pageIndex = 0;
  List<Widget> _pages = [
    HomeScreen(),
    CategoryScreen(),
    CartScreen(),
    FavoriteScreen(),
    AccountScreen()
  ];
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _vendorChatStream = FirebaseFirestore.instance.collection('users').snapshots();
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          setState(() {
            pageIndex = value;
          });
        },
        selectedItemColor: Colors.yellow.shade900,
        currentIndex: pageIndex,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/store-1.png',
              width: 20,
            ),
            label: 'HOME',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/explore.svg',
            ),
            label: 'CATEGORIES',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/cart.svg',
            ),
            label: 'CART',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/favorite.svg',
            ),
            label: 'FAVORITES',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/account.svg',
            ),
            label: 'ACOUNT',
          ),
        ],
      ),
      body: _pages[pageIndex],
    );
  }
}
