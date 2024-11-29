
import 'package:bookstore/models/product_model.dart';
import 'package:bookstore/screens/product/views/added_to_cart_message_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bookstore/route/route_constants.dart';
import 'package:bookstore/components/cart_button.dart';
import 'package:bookstore/components/custom_modal_bottom_sheet.dart';
import 'package:bookstore/constants.dart';
import 'package:bookstore/route/screen_export.dart';
import 'components/product_images.dart';
import 'components/product_info.dart';
import 'components/product_list_tile.dart';
import '../../../components/review_card.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductModel product;
  const ProductDetailsScreen({super.key, required this.product});

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  bool isInWishlist = false;

  @override
  void initState() {
    super.initState();
    _checkIfInWishlist();
  }

  // Check if the product is already in the user's wishlist
  Future<void> _checkIfInWishlist() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final wishlistRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('wishlist');

    final querySnapshot = await wishlistRef
        .where('productId', isEqualTo: widget.product.id) // Use productId
        .get();

    setState(() {
      isInWishlist = querySnapshot.docs.isNotEmpty;
    });
  }

  // Add or remove the product from the wishlist
  Future<void> _toggleWishlist() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final wishlistRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('wishlist');

    if (isInWishlist) {
      // Remove the product from the wishlist
      final querySnapshot = await wishlistRef
          .where('productId', isEqualTo: widget.product.id) // Use productId
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        await querySnapshot.docs.first.reference.delete();
    
          ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text("Product removed from wishlist."),
    duration: Duration(seconds: 2), // Customize the duration if needed
  ),
);;
      }
    } else {
      // Add the product to the wishlist
      await wishlistRef.add({
        'productId': widget.product.id, // Store only productId
      });
  ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text("Product added to wishlist."),
    duration: Duration(seconds: 2), // Customize the duration if needed
  ),
);

    }

    setState(() {
      isInWishlist = !isInWishlist;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CartButton(
        price: widget.product.price,
        press: () {
          customModalBottomSheet(
            context,
            height: MediaQuery.of(context).size.height * 0.92,
            child:  AddedToCartMessageScreen( product: widget.product,),
            
          );
        },
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              floating: true,
              actions: [
                IconButton(
                  onPressed: () async {
                    await _toggleWishlist(); // Add or remove from wishlist
                  },
                  icon: Icon(
                    isInWishlist
                        ? Icons.favorite // Filled heart icon
                        : Icons.favorite_border, // Empty heart icon
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                  ),
                ),
              ],
            ),
            ProductImages(
              images: [
                widget.product.imageUrl,
              ],
            ),
            ProductInfo(
              author: "Author: ${widget.product.author}",
              title: "Title: ${widget.product.name}",
              description: widget.product.description,
              rating: 4.4,
              numOfReviews: 126,
            ),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: ReviewCard(
                  rating: 4.3,
                  numOfReviews: 128,
                  numOfFiveStar: 80,
                  numOfFourStar: 30,
                  numOfThreeStar: 5,
                  numOfTwoStar: 4,
                  numOfOneStar: 1,
                ),
              ),
            ),
            ProductListTile(
              svgSrc: "assets/icons/Chat.svg",
              title: "Reviews",
              isShowBottomBorder: true,
              press: () {
                Navigator.pushNamed(context, commitPageScreenRoute);
              },
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: defaultPadding),
            ),
          ],
        ),
      ),
    );
  }
}
