import 'package:bookstore/components/Banner/S/banner_s_style_5.dart';
import 'package:bookstore/screens/home/views/components/categories.dart';
import 'package:flutter/material.dart';
import 'package:bookstore/components/product/product_card.dart';
import 'package:bookstore/models/product_model.dart';
import 'package:bookstore/route/route_constants.dart';

import '../../../constants.dart';

class BookCategory extends StatelessWidget {
  const BookCategory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(slivers: [
        SliverToBoxAdapter(child: Categories()),
        SliverPadding(
          padding: const EdgeInsets.symmetric(
            horizontal: defaultPadding,
            vertical: defaultPadding,
          ),
          // sliver: SliverGrid(
          //   gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          //     maxCrossAxisExtent: 230.0,
          //     mainAxisSpacing: defaultPadding,
          //     crossAxisSpacing: defaultPadding,
          //     childAspectRatio: 0.75,
          //   ),
          //   delegate: SliverChildBuilderDelegate(
          //     (BuildContext context, int index) {
          //       return ProductCard(
          //         image: demoPopularProducts[index].image,
          //         brandName: demoPopularProducts[index].brandName,
          //         title: demoPopularProducts[index].title,
          //         price: demoPopularProducts[index].price,
          //         priceAfetDiscount:
          //             demoPopularProducts[index].priceAfetDiscount,
          //         dicountpercent: demoPopularProducts[index].dicountpercent,
          //         press: () {
          //           Navigator.pushNamed(context, productDetailsScreenRoute);
          //         },
          //       );
          //     },
          //     childCount: demoPopularProducts.length,
        ),
      ]),
    );

    //     ],
    //   ),
    // );
  }
}
