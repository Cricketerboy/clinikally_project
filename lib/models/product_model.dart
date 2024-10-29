class Product {
  final String id;
  final String name;
  final String price;

  Product({required this.id, required this.name, required this.price});

  factory Product.fromCsv(List<dynamic> csvRow) {
    return Product(
      id: csvRow[0].toString(),
      name: csvRow[1].toString(),
      price: csvRow[2].toString(),
    );
  }
}
