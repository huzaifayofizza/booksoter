import 'package:flutter/material.dart';
import 'package:bookstore/components/product/product_card.dart';
import 'package:bookstore/models/product_model.dart';
import 'package:bookstore/route/route_constants.dart';

import '../../../constants.dart';

class BookmarkScreen extends StatelessWidget {
  const BookmarkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        // slivers: [
        //   // While loading use 👇
        //   //  BookMarksSlelton(),
        //   SliverPadding(
        //     padding: const EdgeInsets.symmetric(
        //       horizontal: defaultPadding,
        //       vertical: defaultPadding,
        //     ),
        //     sliver: SliverGrid(
        //       gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        //         maxCrossAxisExtent: 210.0,
        //         mainAxisSpacing: defaultPadding,
        //         crossAxisSpacing: defaultPadding,
        //         childAspectRatio: 0.62,
        //       ),
        //       delegate: SliverChildBuilderDelegate(
        //         (BuildContext context, int index) {
        //           return ProductCard(
        //             image: demoPopularProducts[index].image,
        //             brandName: demoPopularProducts[index].brandName,
        //             title: demoPopularProducts[index].title,
        //             price: demoPopularProducts[index].price,
        //             priceAfetDiscount:
        //                 demoPopularProducts[index].priceAfetDiscount,
        //             dicountpercent: demoPopularProducts[index].dicountpercent,
        //             press: () {
        //               Navigator.pushNamed(context, productDetailsScreenRoute);
        //             },
        //           );
        //         },
        //         childCount: demoPopularProducts.length,
        //       ),
        //     ),
        //   ),
        // ],
      ),
    );
  }
}
