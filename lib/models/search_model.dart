import 'dart:convert';
import 'package:flutter/services.dart'; // For loading assets

class SearchModel {
  List<Map<String, dynamic>> jobList = [];

  // Load JSON data from assets
  Future<void> loadJobsFromJson(String assetPath) async {
    final jsonString = await rootBundle.loadString(assetPath);
    final List<dynamic> jsonData = jsonDecode(jsonString);

    jobList = jsonData.map((job) {
      return {
        'Company': job['Company'],
        'Company Score': job['Company Score'],
        'Job Title': job['Job Title'],
        'Location': job['Location'],
        'Date': job['Date'],
        'Salary': job['Salary'],
      };
    }).toList();
  }
}
