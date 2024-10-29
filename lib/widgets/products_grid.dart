import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../screens/home_screen.dart';
import '../screens/product_detail_screen.dart';
import 'product_card.dart';

class ProductsGridView extends StatelessWidget {
  final int crossAxisCount;
  final double childAspectRatio;

  const ProductsGridView({
    super.key,
    this.crossAxisCount = 3,
    this.childAspectRatio = 1,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      // padding: const EdgeInsets.all(8.0),
      shrinkWrap: true,
      // physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return InkWell(
            onTap: () => Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (_) => ProductDetailScreen(
                          product: product,
                          isAvailable: stockAvailability[product.id]!,
                        ))),
            child: ProductCard(
              product: product,
              isAvailable: stockAvailability[product.id]!,
            ));
      },
    );
  }
}
