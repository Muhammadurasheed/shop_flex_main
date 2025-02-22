import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'package:get/get.dart';
import 'package:provider/provider.dart' as provider;
import 'package:shop_flex/controllers/category_controller.dart';
import 'package:shop_flex/shop_flex_vendor/vendor/providers/product_provider.dart';
import 'package:shop_flex/views/screens/auths/welcome_screens.dart/welcome_register_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    provider.MultiProvider(
      providers: [
        provider.ChangeNotifierProvider(create: (_) {
          return ProductProvider();
        })
      ],
      child: riverpod.ProviderScope(child: const MyApp()),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shop Flex',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.yellow.shade900,
        ),
        useMaterial3: true,
      ),
      home: WelcomeRegisterScreen(),
      builder: EasyLoading.init(),
      initialBinding: BindingsBuilder(() {
        Get.put<CategoryController>(CategoryController());
      }),
    );
  }
}
