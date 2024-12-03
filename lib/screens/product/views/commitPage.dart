import 'package:bookstore/models/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BookReview extends StatefulWidget {
  final ProductModel product;

  const BookReview({super.key, required this.product});

  @override
  _BookReviewState createState() => _BookReviewState();
}

class _BookReviewState extends State<BookReview> {
  final _formKey = GlobalKey<FormState>();
  final _reviewController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<Review> _reviews = [];

  @override
  void initState() {
    super.initState();
    _fetchReviews();
  }

  Future<void> _fetchReviews() async {
    try {
      final querySnapshot = await _firestore
          .collection('products')
          .doc(widget.product.id)
          .collection('reviews')
          .orderBy('timestamp', descending: true)
          .get();

      final List<Review> fetchedReviews = [];
      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        final userDoc =
            await _firestore.collection('users').doc(data['uid']).get();

        fetchedReviews.add(Review(
          uid: data['uid'],
          review: data['review'],
          name: userDoc.data()?['fullname'] ?? 'Anonymous',
          imageUrl: userDoc.data()?['imageUrl'] ?? '',
        ));
      }

      setState(() {
        _reviews = fetchedReviews;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading reviews: $e')),
      );
    }
  }

  Future<void> _submitReview() async {
    if (_formKey.currentState!.validate()) {
      try {
        final user = _auth.currentUser;

        if (user == null) {
          throw Exception("User not logged in");
        }

        final review = {
          'uid': user.uid,
          'review': _reviewController.text,
          'timestamp': FieldValue.serverTimestamp(),
        };

        await _firestore
            .collection('products')
            .doc(widget.product.id)
            .collection('reviews')
            .add(review);

        setState(() {
          _reviews.add(Review(
            uid: user.uid,
            review: _reviewController.text,
            name: user.displayName ?? 'Anonymous', // Temporary until fetched
            imageUrl: '', // Temporary until fetched
          ));
        });

        _reviewController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error submitting review: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Book Reviews"),
      ),
      body: Column(
        children: [
          Expanded(
            child: _reviews.isEmpty
                ? const Center(child: Text("No reviews yet. Be the first!"))
                : ListView.builder(
                    itemCount: _reviews.length,
                    itemBuilder: (context, index) {
                      final review = _reviews[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.amber,
                          backgroundImage: review.imageUrl.isNotEmpty
                              ? NetworkImage(review.imageUrl)
                              : null,
                          child: review.imageUrl.isEmpty
                              ? Text(
                                  review.name.isNotEmpty
                                      ? review.name[0].toUpperCase()
                                      : "?",
                                  style: const TextStyle(color: Colors.white),
                                )
                              : null,
                        ),
                        title: Text(
                          review.name.isNotEmpty ? review.name : "Anonymous",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(review.review),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _reviewController,
                    decoration: const InputDecoration(labelText: 'Your Review'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your review';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _submitReview,
                    child: const Text('Submit Review'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Review {
  final String uid;
  final String review;
  final String name;
  final String imageUrl;

  Review({
    required this.uid,
    required this.review,
    this.name = '',
    this.imageUrl = '',
  });
}
