import 'package:bookstore/constants.dart';
import 'package:bookstore/models/product_model.dart';
import 'package:bookstore/route/route_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CartSummaryPage extends StatefulWidget {
  final ProductModel product;
  final Map<String, String> formData;

  const CartSummaryPage({
    super.key,
    required this.product,
    required this.formData,
  });

  @override
  _CartSummaryPageState createState() => _CartSummaryPageState();
}

class _CartSummaryPageState extends State<CartSummaryPage> {
  bool _isLoading = false; // Variable to track loading state

  Future<void> _submitOrder() async {
    setState(() {
      _isLoading = true; // Show the loader when order submission starts
    });

    try {
      // Get the current user's ID
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("User not logged in!"),
        ));
        setState(() {
          _isLoading = false; // Hide the loader
        });
        return;
      }
      String userId = user.uid;

      // Prepare the order data
      Map<String, dynamic> orderData = {
        'uid': userId,
        'productId': widget.product.id,
        'email': widget.formData['email'],
        'firstName': widget.formData['firstName'],
        'lastName': widget.formData['lastName'],
        'address': widget.formData['address'],
        'city': widget.formData['city'],
        'state': widget.formData['state'],
        'zipCode': widget.formData['zipCode'],
        'cardNumber': widget.formData['cardNumber'],
        'expiryDate': widget.formData['expiryDate'],
        'cvv': widget.formData['cvv'],
        'orderDate': Timestamp.now(),
      };

      // Save the order to Firestore
      FirebaseFirestore.instance.collection('orderData').add(orderData);

      // Increment the salesCount for the product
      await FirebaseFirestore.instance
          .collection('products')
          .doc(
              widget.product.id) // Assuming 'id' is the product ID in Firestore
          .update({
        'salesCount': FieldValue.increment(1), // Increment salesCount by 1
      });

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Order placed successfully!"),
      ));
      dynamic product = widget.product;
      Navigator.pushReplacementNamed(context, orderPlacedScreenRoute,
          arguments: product);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Failed to place order: $e"),
      ));
    } finally {
      // Hide the loader after the order process is complete
      setState(() {
        _isLoading = false;
      });

      // Optionally, clear form data here (e.g., reset form fields)
      widget.formData.clear(); // This clears the form data map
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart Summary'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_isLoading)
              const Center(
                  child:
                      CircularProgressIndicator()), // Show loader while processing
            if (!_isLoading) ...[
              // Cart Items
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Title: ${widget.product.name}",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Genre: ${widget.product.genre}",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Author: ${widget.product.author}",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Image.network(
                              widget.product.imageUrl,
                              fit: BoxFit.cover,
                              height: 120,
                              width: 80,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: defaultPadding),

              // Subtotal and Taxes
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Subtotal (1):'),
                          Text("\$${widget.product.price}"),
                        ],
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Estimated Tax:'),
                          Text('\$10'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: defaultPadding),

              // Estimated Total
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Estimated Total:'),
                          Text("\$${widget.product.price + 10}"),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: defaultPadding),

              // 100-Day Home Trial Details
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Details'),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.check_circle),
                          const SizedBox(width: 8),
                          Text('First Name: ${widget.formData['firstName']}'),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.check_circle),
                          const SizedBox(width: 8),
                          Text('Email: ${widget.formData['email']}'),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.check_circle),
                          const SizedBox(width: 8),
                          Text('Address: ${widget.formData['address']}'),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.check_circle),
                          const SizedBox(width: 8),
                          Text('Card Number: ${widget.formData['cardNumber']}'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: defaultPadding),

              // Checkout Button
              ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : _submitOrder, // Disable button while loading
                child: const Text('Submit Order'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
