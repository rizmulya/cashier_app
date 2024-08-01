import 'package:cashier_app/Provider/provider_db.dart';
import 'package:cashier_app/View/splash_screens.dart';
import 'package:cashier_app/View/product_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => ProviderDB()..init(),
      child: const MaterialApp(
          debugShowCheckedModeBanner: false,
          // home: ProductView(),
          home: SplashScreen(), // use intro screen
        )
    );
  }
}
