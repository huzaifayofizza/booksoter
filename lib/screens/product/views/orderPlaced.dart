import 'package:bookstore/constants.dart';
import 'package:bookstore/route/route_constants.dart';
import 'package:flutter/material.dart';

class OrderConfirmationPage extends StatelessWidget {
  const OrderConfirmationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Confirmation'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Checkmark icon
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 100,
            ),

            // Thank you message
            const Text(
              'Thank you!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: defaultPadding),

            // Order placed message
            const Text('Your order has been placed successfully.'),
            const SizedBox(height: defaultPadding),

            // Order details
            Card(
              margin: const EdgeInsets.symmetric(vertical: 16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // List of items
                    ListTile(
                      leading: Image.asset(
                          'assets/cake_image.png'), // Replace with your image path
                      title: const Text('Cake'),
                      trailing: const Text('\$39.00'),
                    ),
                    // ... Add more items as needed
                    const SizedBox(height: defaultPadding),
                    // Total
                    const ListTile(
                      title: Text('Total'),
                      trailing: Text('\$39.00'),
                    ),
                  ],
                ),
              ),
            ),

            // Action button (e.g., View Order Details)
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, entryPointScreenRoute);
              },
              child: const Text('THank You...'),
            ),
            const SizedBox(height: defaultPadding),
            const Text('Your Book Were Delevery At Your Home In 5 to 6 Days'),
            const SizedBox(height: defaultPadding),
            const Text('thanks you to touch this website...')
          ],
        ),
      ),
    );
  }
}
