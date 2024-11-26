import 'package:flutter/material.dart';
import 'package:bookstore/components/product/product_card.dart';
import 'package:bookstore/models/product_model.dart';
import 'package:bookstore/route/screen_export.dart';

import '../../../../constants.dart';

class PopularProducts extends StatelessWidget {
  const PopularProducts({super.key});

  Future<List<ProductModel>> fetchPopularProducts() async {
    return await fetchProducts(); // Use the fetchProducts function from your ProductModel file
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: defaultPadding / 2),
        Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Text(
            "Popular Products",
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        FutureBuilder<List<ProductModel>>(
          future: fetchPopularProducts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No products available'));
            }

            final products = snapshot.data!;
            return SizedBox(
              height: 230,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: products.length,
                itemBuilder: (context, index) => Padding(
                  padding: EdgeInsets.only(
                    left: defaultPadding,
                    right: index == products.length - 1 ? defaultPadding : 0,
                  ),
                  child: ProductCard(
                    image: products[index].imageUrl,
                    brandName: products[index]
                        .author, // Adjust this field as per your UI
                    title: products[index].name,
                    price: products[index].price,
                    press: () {
                      Navigator.pushNamed(
                        context,
                        productDetailsScreenRoute,
                          arguments: products[index], // Pass the product data
               
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
