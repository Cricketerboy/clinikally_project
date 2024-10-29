import 'package:clinikally_project/models/product_model.dart';
import 'package:flutter/material.dart';

import '../providers/helpers.dart';
import '../providers/responsive.dart';
import '../widgets/main_drawer.dart';
import '../widgets/products_grid.dart';

String pinCode = '';
List<Product> products = [];
Map<String, bool> stockAvailability = {};
List<Map<String, dynamic>> pinCodeData = [];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  Future<void> _loadAllData() async {
    try {
      await Helpers.loadProducts();
      await Helpers.loadStockData();
      await Helpers.loadPinCodeData();
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print("Error loading data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Clinikally',
          style: TextStyle(
            letterSpacing: 1,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      drawer: const MainDrawer(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : const Responsive(
              mobile: ProductsGridView(crossAxisCount: 2),
              mobileMedium: ProductsGridView(crossAxisCount: 3),
              mobileLarge: ProductsGridView(crossAxisCount: 4),
              tablet: ProductsGridView(crossAxisCount: 5),
              desktop: ProductsGridView(crossAxisCount: 7),
            ),
    );
  }
}

// Future<void> loadProducts() async {
//   try {
//     print("Loading CSV file...");
//     final csvData = await rootBundle.loadString('assets/csv/Products.csv');
//     print("CSV file loaded successfully.");
//
//     final List<List<dynamic>> csvTable = CsvToListConverter().convert(csvData);
//
//     // Check each row content for debugging
//     for (var row in csvTable) {
//       print("Row data: $row");
//     }
//
//     setState(() {
//       // Skip the header row explicitly if it's being counted
//       products = csvTable
//           .skip(1) // Skip header row
//           .where((row) => row.length >= 3) // Ensure each row has at least 3 columns
//           .map((csvRow) => Product.fromCsv(csvRow))
//           .toList();
//     });
//
//     print("Products loaded: ${products.length}");
//   } catch (e) {
//     print("Error loading CSV: $e");
//   }
// }