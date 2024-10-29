import 'dart:convert';

import 'package:clinikally_project/models/product_model.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart';

import '../screens/home_screen.dart';

class Helpers {
  static Future<void> loadProducts() async {
    try {
      final csvData = await rootBundle.loadString('assets/csv/Products.csv');
      final List<List<dynamic>> csvTable =
          const CsvToListConverter().convert(csvData);

      products = csvTable
          .skip(1) // Skip header row
          .map((csvRow) => Product.fromCsv(csvRow))
          .toList();
    } catch (e) {
      print("Error loading CSV: $e");
    }
  }

  static Future<void> loadStockData() async {
    final data = await rootBundle.loadString('assets/csv/Stock.csv');
    final rows = const LineSplitter().convert(data);

    for (var row in rows) {
      final fields = row.split(',');
      final productId = fields[0];
      final isAvailable = fields[1].toLowerCase() == 'true';

      stockAvailability[productId] = isAvailable;
    }
  }

  // static List<Map<String, dynamic>> pinCodeData = [];

  static Future<void> loadPinCodeData() async {
    try {
      final csvData = await rootBundle.loadString('assets/csv/Pincodes.csv');
      final List<List<dynamic>> csvTable =
          const CsvToListConverter().convert(csvData);

      // Assuming first row contains headers
      final headers = csvTable.first.cast<String>();
      pinCodeData = csvTable
          .skip(1) // Skip header row
          .map((row) => Map<String, dynamic>.fromIterables(headers, row))
          .toList();
    } catch (e) {
      print("Error loading Pincode CSV: $e");
    }
  }

  static Map<String, dynamic> getPinCodeData(String userPincode) {
    return pinCodeData.firstWhere(
      (entry) => entry['Pincode'].toString() == userPincode,
      orElse: () => {},
    );
  }
}
