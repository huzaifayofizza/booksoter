import 'package:bookstore/constants.dart';
import 'package:bookstore/route/route_constants.dart';
import 'package:flutter/material.dart';

class CartSummaryPage extends StatefulWidget {
  @override
  _CartSummaryPageState createState() => _CartSummaryPageState();
}

class _CartSummaryPageState extends State<CartSummaryPage> {
  final _formKey = GlobalKey<FormState>();
  final _promoCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart Summary'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cart Items
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('1 Bike+ Basics Package', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('\$2,495.00'),
                      SizedBox(height: 8),
                      Text('12-Month Bike+ Limited Warranty'),
                      Text('1 Peloton Membership'),
                      Text('\$39/mo membership to unlimited Peloton content. Charges begin upon Peloton activation.'),
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
                          Text('Subtotal (2):'),
                          Text('\$2,495.00'),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Est. delivery and setup:'),
                          Text('Included'),
                        ],
                      ),
                      Row(
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
                          Text('Estimated Total:'),
                          Text('\$2,495.00'),
                        ],
                      ),
                      Text('As low as \$59/month* for 43 months at 0% APR.'),
                    ],
                  ),
                ),
              ),
               const SizedBox(height: defaultPadding),

              // 100-Day Home Trial
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('1 DAY HOME TRIAL'),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.check_circle),
                          SizedBox(width: 8),
                          Text('Try Peloton at home for 15 days.'),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.check_circle),
                          SizedBox(width: 8),
                          Text('Explore thousands of classes, live and on-demand.'),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.check_circle),
                          SizedBox(width: 8),
                          Text('Not for you? We\'ll refund your entire order.'),
                        ],
                      ),
                      Text('Limited-time offer. Terms apply.'),
                    ],
                  ),
                ),
              ),
               const SizedBox(height: defaultPadding),

              // Checkout Button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                  Navigator.pushNamed(context, orderPlacedScreenRoute);
                  }
                },
                child: Text('Your Order Is Done Now?'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}