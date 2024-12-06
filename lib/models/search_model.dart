import 'dart:convert';
import 'package:flutter/services.dart'; // For loading assets
import 'package:csv/csv.dart'; // CSV parser

class SearchModel {
  List<Map<String, dynamic>> peopleList = [];

  // Load CSV data from assets
  Future<void> loadJobsFromCsv(String assetPath) async {
    final csvString = await rootBundle.loadString(assetPath);
    final List<List<dynamic>> csvRows = const CsvToListConverter().convert(csvString);

    // Skip the header row and map each row into a job structure
    peopleList = csvRows.skip(1).map((row) {
      return {
        'company': row[0],
        'companyScore': double.tryParse(row[1].toString()) ?? 0.0,
        'jobTitle': row[2],
        'location': row[3],
        'date': row[4],
        'salary': row[5],
      };
    }).toList();
  }
}
