import 'package:flutter/material.dart';
import 'package:bookstore/models/product_model.dart';
import 'package:bookstore/route/route_constants.dart';

class OrderConfirmationPage extends StatefulWidget {
  final ProductModel product;

  const OrderConfirmationPage({super.key, required this.product});

  @override
  State<OrderConfirmationPage> createState() => _OrderConfirmationPageState();
}

class _OrderConfirmationPageState extends State<OrderConfirmationPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Disabling the back button
        return false;
      },
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Checkmark icon
                const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 100,
                ),
                const SizedBox(height: 16),

                // Thank you message
                const Text(
                  'Thank you!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // Order placed message
                const Text(
                  'Your order has been placed successfully.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),

                // Order details card
                Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product image
                        Center(
                          child: Image.network(
                            widget.product.imageUrl,
                            fit: BoxFit.cover,
                            height: 150,
                            width: 100,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Product title
                        Center(
                          child: Text(
                            widget.product.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Estimated Total
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Gross Total:',
                              style: TextStyle(fontSize: 14),
                            ),
                            Text(
                              "\$${widget.product.price + 10}", // Assuming $10 is the delivery fee
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Action button (e.g., Go to Home)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to the entry point screen
                      Navigator.pushReplacementNamed(
                          context, entryPointScreenRoute);
                    },
                    child: const Text('Done!'),
                  ),
                ),

                const SizedBox(height: 16),

                // Delivery message
                const Text(
                  'Your book will be delivered in 5 to 6 days.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
