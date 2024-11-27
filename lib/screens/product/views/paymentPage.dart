import 'package:flutter/material.dart';
import 'package:stripe_payment/stripe_payment.dart';

class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();

  bool _isLoading = false;
  bool _showSuccessIcon = false;

  @override
  void initState() {
    super.initState();

    // Initialize Stripe Payment
    StripePayment.setOptions(
      StripeOptions(
        publishableKey: "pk_test_your_publishable_key_here", // Replace with your Stripe key
        merchantId: "Test", // Optional
        androidPayMode: 'test',
      ),
    );
  }

  Future<void> _makePayment() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    double amount = double.parse(_amountController.text) * 100; // Convert to cents

    try {
      PaymentMethod paymentMethod = await StripePayment.paymentRequestWithCardForm(
        CardFormPaymentRequest(),
      );

      PaymentIntentResult paymentIntent = await _createPaymentIntent(amount.toString());

      if (paymentIntent.status == 'succeeded') {
        _showSuccessAndNavigate();
      } else {
        _showErrorDialog('Payment failed. Please try again.');
      }
    } catch (e) {
      _showErrorDialog('An error occurred: $e');
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<PaymentIntentResult> _createPaymentIntent(String amount) async {
    return await StripePayment.confirmPaymentIntent(
      PaymentIntent(
        clientSecret: "your_client_secret", // Get from your backend
        paymentMethodId: "pm_card_visa",
      ),
    );
  }

  void _showSuccessAndNavigate() {
    setState(() {
      _showSuccessIcon = true; // Show tick emoji
    });

    // Delay for 1 second to show success icon, then navigate
    Future.delayed(Duration(seconds: 1), () {
      Navigator.pushReplacementNamed(context, 'entryPointScreenRoute');
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Payment Failed'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stripe Payment'),
        backgroundColor: Color(0xFFb0baed),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_showSuccessIcon)
                Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 100,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Payment Successful!',
                        style: TextStyle(fontSize: 20, color: Colors.green),
                      ),
                    ],
                  ),
                ),
              if (!_showSuccessIcon)
                Column(
                  children: [
                    Text('Amount'),
                    TextFormField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Enter the amount',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an amount';
                        } else if (double.tryParse(value) == null || double.parse(value) <= 0) {
                          return 'Invalid amount';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    _isLoading
                        ? Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                            onPressed: _makePayment,
                            child: Text('Pay Now'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFb0baed),
                            ),
                          ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
