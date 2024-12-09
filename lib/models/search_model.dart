import 'dart:convert';
import 'package:flutter/services.dart';

class SearchModel {
  List<Map<String, dynamic>> jobList = [];

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

  List<Map<String, dynamic>> filterJobs({
    String locationFilter = "All",
    String titleFilter = "All",
    String searchQuery = "",
  }) {
    return jobList.where((job) {
      final matchesLocation = locationFilter == "All" ||
          job['Location']?.toString().toLowerCase() == locationFilter.toLowerCase() ||
          (locationFilter.toLowerCase() == "remote" &&
              job['Job Title']?.toLowerCase().contains("remote")) ||
          (locationFilter.toLowerCase() == "hybrid" &&
              job['Job Title']?.toLowerCase().contains("hybrid"));

      final matchesTitle = titleFilter == "All" ||
          job['Job Title']?.toLowerCase().contains(titleFilter.toLowerCase());

      final matchesSearch = searchQuery.isEmpty ||
          job['Job Title']?.toLowerCase().contains(searchQuery.toLowerCase());

      return matchesLocation && matchesTitle && matchesSearch;
    }).toList();
  }
}
