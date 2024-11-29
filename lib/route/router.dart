import 'package:bookstore/models/product_model.dart';
import 'package:bookstore/screens/home/views/BookCategory_screen.dart';

import 'package:bookstore/screens/product/views/orderPlaced.dart';
import 'package:flutter/material.dart';
import 'package:bookstore/entry_point.dart';

import 'screen_export.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case logInScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      );
    case signUpScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const SignUpScreen(),
      );
    case passwordRecoveryScreenRoute:
      return MaterialPageRoute(
        builder: (context) => PasswordRecoveryScreen(),
      );
    case productDetailsScreenRoute:
      return MaterialPageRoute(
        builder: (context) {
          // Retrieve the product data passed as arguments
          final ProductModel product = settings.arguments as ProductModel;

          // Pass the product data to the ProductDetailsScreen
          return ProductDetailsScreen(product: product);
        },
      );
    case homeScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      );
    case bookmarkScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const BookmarkScreen(),
      );
    case commitPageScreenRoute:
      return MaterialPageRoute(
        builder: (context) => BookReview(),
      );
    case entryPointScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const EntryPoint(),
      );
    case profileScreenRoute:
      return MaterialPageRoute(
        builder: (context) => ProfileScreen(),
      );
    case preferencesScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const PreferencesScreen(),
      );
    case OrderConfimScreenRoute:
      final args = settings.arguments
          as Map<String, dynamic>; // Get the passed arguments
      final product = args['product'] as ProductModel; // Extract product
      final formData =
          args['formData'] as Map<String, String>; // Extract form data

      return MaterialPageRoute(
        builder: (context) => CartSummaryPage(
          product: product, // Pass the product to the next screen
          formData: formData, // Pass the form data to the next screen
        ),
      );

    case CheckoutScreenRoute:
      final ProductModel product = settings.arguments as ProductModel;
      return MaterialPageRoute(
        builder: (context) => CheckoutPage(product: product),
      );

    case orderPlacedScreenRoute:
      return MaterialPageRoute(
        builder: (context) =>  OrderConfirmationPage(),
      );
    case BookcategoryScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const BookCategory(),
      );
    // case bookInsertFormScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => BookStoreAdmin(),
    //   );
    // case bookViewScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => BookStoreView(),
    //   );
    // case AdminUserAccountScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => AdminUserAccount(),
    //   );
    // case AdminOrderManageSCreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => AdminUserAccount(),
    //   );
    default:
      return MaterialPageRoute(
        builder: (context) => const OnBordingScreen(),
      );
  }
}

class ErrorPage extends StatelessWidget {
  final String message;

  const ErrorPage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
      ),
      body: Center(
        child: Text(
          message,
          style: const TextStyle(fontSize: 18, color: Colors.red),
        ),
      ),
    );
  }
}
