import 'package:bookstore/route/route_constants.dart';
import 'package:flutter/material.dart';


class OrderConfirmationPage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Confirmation'),
      ),
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
              ),
              const SizedBox(height: 16),

              // Order details
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                      Text(
                        "Title: $title",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Estimated Total
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Estimated Total:',
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
                            "\$${price + 10}", // Assuming $10 is the delivery fee
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
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, entryPointScreenRoute); // Replace with the actual route name
                },
                child: const Text('Done!'),
              ),

              const SizedBox(height: 16),

              // Delivery message
              const Text(
                'Your book will be delivered in 5 to 6 days.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
