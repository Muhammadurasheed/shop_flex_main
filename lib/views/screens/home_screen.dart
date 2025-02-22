import 'package:flutter/material.dart';
import 'package:shop_flex/views/screens/widgets/banners_widget.dart';
import 'package:shop_flex/views/screens/widgets/category_text_widget.dart';
import 'package:shop_flex/views/screens/widgets/home_product.dart';
import 'package:shop_flex/views/screens/widgets/location_widget.dart';
import 'package:shop_flex/views/screens/widgets/men_products_widget.dart';
import 'package:shop_flex/views/screens/widgets/reusable_text.dart';
import 'package:shop_flex/views/screens/widgets/women_product_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LocationWidget(),
          SizedBox(
            height: 10,
          ),
          BannersWidget(),
          SizedBox(height: 10),
          CategoryTextWidget(),
          SizedBox(height: 10),
          HomeProduct(),
          SizedBox(height: 10),
          ReusableText(CategoryTitle: "Men's Products"),
          SizedBox(height: 10),
          MenProductsWidget(),
          SizedBox(height: 10),
          ReusableText(CategoryTitle: "Women's Products"),
          WomenProductWidget(),
        ],
      ),
    );
  }
}
