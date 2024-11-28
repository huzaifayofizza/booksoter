import 'package:bookstore/screens/product/views/added_to_cart_message_screen.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

Future<dynamic> customModalBottomSheet(
  BuildContext context, {
  bool isDismissible = true,
  double? height,
  required AddedToCartMessageScreen child, // Correctly declared child parameter
}) {
  return showModalBottomSheet(
    context: context,
    clipBehavior: Clip.hardEdge,
    isScrollControlled: true,
    isDismissible: isDismissible,
    enableDrag: isDismissible,
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(defaultBorderRadious * 2),
        topRight: Radius.circular(defaultBorderRadious * 2),
      ),
    ),
    builder: (context) => SizedBox(
      height: height ?? MediaQuery.of(context).size.height * 0.75,
      child: child, // Place the child here
    ),
  );
}
