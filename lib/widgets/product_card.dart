import 'package:clinikally_project/models/product_model.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final bool isAvailable;

  const ProductCard(
      {super.key, required this.product, required this.isAvailable});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Expanded(
            child: Icon(Icons.shopping_bag_rounded,
                size: 50), // Placeholder for image
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(product.name,
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('₹${product.price}',
                    style: const TextStyle(color: Colors.green)),
                Text(
                  isAvailable == true ? 'In Stock' : 'Out of Stock',
                  style: TextStyle(
                    fontSize: 10,
                    color: isAvailable == true ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
