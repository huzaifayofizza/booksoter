import 'package:flutter/material.dart';
import 'package:bookstore/components/product/product_card.dart';
import 'package:bookstore/models/product_model.dart';
import 'package:bookstore/route/route_constants.dart';

import '../../../constants.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  _BookmarkScreenState createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  bool isLoading = true;
  List<ProductModel> bookmarkedProducts = [];

  @override
  void initState() {
    super.initState();
    _fetchBookmarkedProducts();
  }

  // Fetch bookmarked products
  Future<void> _fetchBookmarkedProducts() async {
    List<ProductModel> products = await fetchBookmarkedProducts();
    setState(() {
      bookmarkedProducts = products;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : bookmarkedProducts.isEmpty
              ? const Center(child: Text('No bookmarked products'))
              : CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: defaultPadding,
                        vertical: defaultPadding,
                      ),
                      sliver: SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 180.0,
                          mainAxisSpacing: defaultPadding,
                          crossAxisSpacing: defaultPadding,
                          childAspectRatio: 0.62,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            return ProductCard(
                              image: bookmarkedProducts[index].imageUrl,
                              brandName: bookmarkedProducts[index].author,
                              title: bookmarkedProducts[index].name,
                              price: bookmarkedProducts[index].price,
                              press: () {
                                Navigator.pushNamed(
                                  context,
                                  productDetailsScreenRoute,
                                  arguments: bookmarkedProducts[index],
                                );
                              },
                            );
                          },
                          childCount: bookmarkedProducts.length,
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}
