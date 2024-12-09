import 'dart:convert';
import 'package:flutter/services.dart';
import 'search_model.dart';

class SearchRepositoryModel {
  List<SearchModel> _searchResults = [];

  Future<void> loadJobsFromJson() async {
    if (_searchResults.isEmpty) {
      final String response = await rootBundle.loadString('lib/assets/cleaned-data/cleaned_software_jobs.json');
      final List<dynamic> data = jsonDecode(response);
      _searchResults = data.map((job) => SearchModel.fromMap(job)).toList();
    }
  }

  List<SearchModel> getAllJobs() {
    return List.from(_searchResults);
  }

  List<SearchModel> filterJobs({String location = "all", String jobTitle = "all"}) {
    return _searchResults.where((job) {
      final matchesLocation = location.toLowerCase() == "all" || job.location.toLowerCase() == location.toLowerCase();
      final matchesJobTitle = jobTitle.toLowerCase() == "all" || job.jobTitle.toLowerCase() == jobTitle.toLowerCase();
      return matchesLocation && matchesJobTitle;
    }).toList();
  }
}
