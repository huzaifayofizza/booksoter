import 'package:bookstore/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:bookstore/constants.dart';
import 'package:bookstore/route/screen_export.dart';

class AddedToCartMessageScreen extends StatelessWidget {
  final ProductModel product;

  // Constructor to receive product data
  const AddedToCartMessageScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Column(
            children: [
              const Spacer(),
              Image.asset(
                Theme.of(context).brightness == Brightness.light
                    ? "assets/Illustration/success.png"
                    : "assets/Illustration/success_dark.png",
                height: MediaQuery.of(context).size.height * 0.3,
              ),
              const Spacer(flex: 2),
              Text(
                "Added to cart",
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: defaultPadding / 2),
              const Text(
                "Click the checkout button to complete the purchase process.",
                textAlign: TextAlign.center,
              ),
              const Spacer(flex: 2),
              OutlinedButton(
                onPressed: () {
                  Navigator.pushNamed(context, entryPointScreenRoute);
                },
                child: const Text("Continue shopping"),
              ),
              const SizedBox(height: defaultPadding),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, CheckoutScreenRoute,
                      arguments:
                          product // Pass the product to the CheckoutScreen
                      );
                },
                child: const Text("Checkout"),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
