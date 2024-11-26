import 'package:bookstore/screens/home/views/components/new_arrival.dart';
import 'package:bookstore/screens/home/views/components/offers_carousel.dart';
import 'package:flutter/material.dart';
import 'package:bookstore/components/Banner/S/banner_s_style_1.dart';
import 'package:bookstore/components/Banner/S/banner_s_style_5.dart';
import 'package:bookstore/constants.dart';


import 'components/best_sellers.dart';


import 'components/popular_products.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(child: OffersCarousel()),
            const SliverToBoxAdapter(child: BestSellers()),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  const SizedBox(height: defaultPadding * 1.5),
                  const SizedBox(height: defaultPadding / 4),
                  // While loading use 👇
                  // const BannerMSkelton(),‚
                  BannerSStyle1(
                    title: "New \narrival",
                    subtitle: "SPECIAL OFFER",
                    press: () {},
                  ),
                  const SizedBox(height: defaultPadding / 4),
                  // We have 4 banner styles, all in the pro version
                ],
              ),
            ),
            const SliverToBoxAdapter(child: new_arrival()),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  const SizedBox(height: defaultPadding * 1.5),

                  const SizedBox(height: defaultPadding / 4),
                  // While loading use 👇
                  // const BannerSSkelton(),
                  BannerSStyle5(
                    title: "We Have \nSpecial Books",
                    subtitle: "For You",
                    bottomText: "Collection".toUpperCase(),
                    press: () {},
                  ),
                  const SizedBox(height: defaultPadding / 4),
                ],
              ),
            ),
            const SliverToBoxAdapter(child: PopularProducts()),
          ],
        ),
      ),
    );
  }
}
