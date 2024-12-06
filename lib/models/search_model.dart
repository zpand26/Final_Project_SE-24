import 'dart:convert';
import 'package:flutter/services.dart'; // For loading assets
import 'package:csv/csv.dart'; // CSV parser

class SearchModel {
  List<Map<String, dynamic>> jobList = [];

  // Load CSV data from assets
  Future<void> loadJobsFromCsv(String assetPath) async {
    final csvString = await rootBundle.loadString(assetPath);
    final List<List<dynamic>> csvRows = const CsvToListConverter().convert(csvString);

    // Skip the header row and map each row into a job structure
    jobList = csvRows.skip(1).map((row) {
      return {
        'workYear': row[0],
        'jobTitle': row[1],
        'jobCategory': row[2],
        'salaryCurrency': row[3],
        'salary': row[4],
        'salaryInUsd': row[5],
        'employeeResidence': row[6],
        'experienceLevel': row[7],
        'employmentType': row[8],
        'workSetting': row[9],
        'companyLocation': row[10],
        'companySize': row[11],
      };
    }).toList();
  }
}
