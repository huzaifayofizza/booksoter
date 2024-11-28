import 'package:bookstore/models/product_model.dart';
import 'package:bookstore/route/route_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class CheckoutPage extends StatefulWidget {
  final ProductModel product;

  // Constructor to accept product data
  const CheckoutPage({super.key, required this.product});

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipCodeController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _cvvController = TextEditingController();

  // Animation states
  bool _showPaymentFields = false;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      final googleSignIn = GoogleSignIn();
      final googleUser = await googleSignIn.signInSilently();

      if (user != null) {
        if (googleUser != null) {
          // Google user
          setState(() {
            _firstNameController.text =
                googleUser.displayName?.split(' ').first ?? '';
            _lastNameController.text =
                googleUser.displayName?.split(' ').last ?? '';
            _emailController.text = googleUser.email;
          });
        } else if (user.isAnonymous) {
          // Anonymous user
          setState(() {
            _firstNameController.text = 'Guest';
            _emailController.text = 'guest@example.com';
          });
        } else {
          // Firebase Auth user
          final userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();

          if (userDoc.exists) {
            final data = userDoc.data();
            setState(() {
              _firstNameController.text =
                  (data?['fullname'] ?? 'User').split(' ').first;
              _lastNameController.text =
                  (data?['fullname'] ?? 'User').split(' ').last;
              _emailController.text = data?['email'] ?? 'No Email';
            });
          }
        }
      }
    } catch (e) {
      debugPrint("Error fetching user data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Email Field
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email Address*'),
                onChanged: (value) {
                  _emailController.text = value.trim().toLowerCase();
                  _emailController.selection = TextSelection.fromPosition(
                    TextPosition(offset: _emailController.text.length),
                  );
                },
                validator: (value) {
                  value = value?.trim();
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email address';
                  }
                  if (!RegExp(
                          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                      .hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Name Fields
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _firstNameController,
                      decoration:
                          const InputDecoration(labelText: 'First Name*'),
                      onChanged: (value) {
                        _firstNameController.text = value.trim().replaceFirst(
                              value[0],
                              value[0].toUpperCase(),
                            );
                        _firstNameController.selection =
                            TextSelection.fromPosition(
                          TextPosition(
                              offset: _firstNameController.text.length),
                        );
                      },
                      validator: (value) {
                        value = value?.trim();
                        if (value == null || value.isEmpty) {
                          return 'Please enter your first name';
                        }
                        if (value.length < 3) {
                          return 'Name must be at least 3 characters long';
                        }
                        if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
                          return 'Name can only contain alphabets';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _lastNameController,
                      decoration:
                          const InputDecoration(labelText: 'Last Name*'),
                      onChanged: (value) {
                        _lastNameController.text = value.trim().replaceFirst(
                              value[0],
                              value[0].toUpperCase(),
                            );
                        _lastNameController.selection =
                            TextSelection.fromPosition(
                          TextPosition(offset: _lastNameController.text.length),
                        );
                      },
                      validator: (value) {
                        value = value?.trim();
                        if (value == null || value.isEmpty) {
                          return 'Please enter your last name';
                        }
                        if (value.length < 3) {
                          return 'Name must be at least 3 characters long';
                        }
                        if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
                          return 'Name can only contain alphabets';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Address Fields
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Address*'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _cityController,
                      decoration: const InputDecoration(labelText: 'City*'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your city';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _stateController,
                      decoration: const InputDecoration(labelText: 'State*'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your state';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _zipCodeController,
                decoration: const InputDecoration(labelText: 'ZIP Code*'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your ZIP code';
                  }
                  if (!RegExp(r'^\d{5}$').hasMatch(value)) {
                    return 'Please enter a valid 5-digit ZIP code';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Payment Section
              GestureDetector(
                onTap: () {
                  setState(() {
                    _showPaymentFields = !_showPaymentFields;
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Payment Details',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Icon(
                      _showPaymentFields
                          ? Icons.expand_less
                          : Icons.expand_more,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: _showPaymentFields ? 1.0 : 0.0,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  height: _showPaymentFields ? null : 0,
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _cardNumberController,
                        decoration:
                            const InputDecoration(labelText: 'Card Number*'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your card number';
                          }
                          if (!RegExp(r'^\d{16}$').hasMatch(value)) {
                            return 'Please enter a valid 16-digit card number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _expiryDateController,
                              decoration: const InputDecoration(
                                  labelText: 'Expiry Date (MM/YY)*'),
                              keyboardType: TextInputType.datetime,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the expiry date';
                                }
                                if (!RegExp(r'^(0[1-9]|1[0-2])\/\d{2}$')
                                    .hasMatch(value)) {
                                  return 'Please enter a valid date (MM/YY)';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _cvvController,
                              decoration:
                                  const InputDecoration(labelText: 'CVV*'),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the CVV';
                                }
                                if (!RegExp(r'^\d{3}$').hasMatch(value)) {
                                  return 'Please enter a valid 3-digit CVV';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  // CheckoutPage: Submit the form and pass product and form data to CartSummaryPage
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      // Navigate to CartSummaryPage with product data and form data
                      Navigator.pushNamed(
                        context,
                        OrderConfimScreenRoute, // Ensure this is properly defined in your route settings
                        arguments: {
                          'product': widget
                              .product, // product object from CheckoutPage
                          'formData': {
                            'email': _emailController.text,
                            'firstName': _firstNameController.text,
                            'lastName': _lastNameController.text,
                            'address': _addressController.text,
                            'city': _cityController.text,
                            'state': _stateController.text,
                            'zipCode': _zipCodeController.text,
                            'cardNumber': _cardNumberController.text,
                            'expiryDate': _expiryDateController.text,
                            'cvv': _cvvController.text,
                          },
                        },
                      );
                    }
                  },

                  child: const Text('Check Out Deatils'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
