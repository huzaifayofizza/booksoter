import 'package:flutter/material.dart';
import 'package:bookstore/components/product/product_card.dart';
import 'package:bookstore/models/product_model.dart';
import 'package:bookstore/route/route_constants.dart';

import '../../../constants.dart';

class BookCategory extends StatefulWidget {
  const BookCategory({super.key});

  @override
  _BookCategoryState createState() => _BookCategoryState();
}

class _BookCategoryState extends State<BookCategory> {
  bool isLoading = true;
  List<ProductModel> bookmarkedProducts = [];

  @override
  void initState() {
    super.initState();
    _fetchBookCategoryProducts();
  }

  // Fetch bookmarked products
  Future<void> _fetchBookCategoryProducts() async {
    List<ProductModel> products = await fetchBookCategory();
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
                          maxCrossAxisExtent: 240.0,
                          mainAxisSpacing: defaultPadding,
                          crossAxisSpacing: defaultPadding,
                          childAspectRatio: 0.72,
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
