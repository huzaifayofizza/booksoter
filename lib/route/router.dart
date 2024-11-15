import 'package:bookstore/screens/product/views/orderPlaced.dart';
import 'package:bookstore/screens/admin_panel/Screen/BookInsertForm.dart';
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
        builder: (context) =>  PasswordRecoveryScreen(),
      );
    case productDetailsScreenRoute:
      return MaterialPageRoute(
        builder: (context) {
          bool isProductAvailable = settings.arguments as bool? ?? true;
          return ProductDetailsScreen(isProductAvailable: isProductAvailable);
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
    case entryPointScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const EntryPoint(),
      );
    case profileScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const ProfileScreen(),
      );
    case preferencesScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const PreferencesScreen(),
      );
    case OrderConfimScreenRoute:
      return MaterialPageRoute(
        builder: (context) => CartSummaryPage(),
      );
    case CheckoutScreenRoute:
      return MaterialPageRoute(
        builder: (context) => CheckoutPage(),
      );
    case orderPlacedScreenRoute:
      return MaterialPageRoute(
        builder: (context) => OrderConfirmationPage(),
      );
    case bookInsertFormScreenRoute:
      return MaterialPageRoute(
        builder: (context) => BookStoreAdmin(),
      );
    case bookViewScreenRoute:
      return MaterialPageRoute(
        builder: (context) => BookStoreView(),
      );
    case AdminUserAccountScreenRoute:
      return MaterialPageRoute(
        builder: (context) => AdminUserAccount(),
      );
    case AdminOrderManageSCreenRoute:
      return MaterialPageRoute(
        builder: (context) => AdminUserAccount(),
      );
    default:
      return MaterialPageRoute(
        builder: (context) => const OnBordingScreen(),
      );
  }
}
