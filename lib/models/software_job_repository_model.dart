import 'dart:convert';
import 'package:flutter/services.dart';
import 'software_job_model.dart';

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
      final matchesHybridInTitle = location.toLowerCase() == "hybrid" &&
          job.jobTitle.toLowerCase().contains("hybrid");
      return (matchesLocation || matchesHybridInTitle) && matchesJobTitle;
    }).toList();
  }

  List<List<SearchModel>> sortSalaries(List<SearchModel> unsortedJobs) {
    // Step 1: Group jobs by company
    Map<String, List<SearchModel>> cityGroups = {};

    for (var job in unsortedJobs) {
      String city = job.location.toLowerCase() == "remote" ? "Remote" : job.location;
      if (!cityGroups.containsKey(city)) {
        cityGroups[city] = [];
      }

      cityGroups[city]?.add(job);
    }

    List<List<SearchModel>> sortedSalaries = [];

    cityGroups.forEach((city, jobs) {
      jobs.sort((a, b) => _compareSalaries(a.salary, b.salary));
      sortedSalaries.add(jobs);
    });

    return sortedSalaries;
  }

  int _compareSalaries(String salaryA, String salaryB) {

    double salaryValueA = _parseSalary(salaryA);
    double salaryValueB = _parseSalary(salaryB);

    return salaryValueA.compareTo(salaryValueB);
  }

  double _parseSalary(String salary) {
    final rangeRegex = RegExp(r'\$(\d+)([kK])\s*-\s*\$(\d+)([kK])');

    final match = rangeRegex.firstMatch(salary);
    if (match != null) {
      final minSalary = double.tryParse(match.group(1) ?? '') ?? 0.0;
      final maxSalary = double.tryParse(match.group(3) ?? '') ?? 0.0;
      double minSalaryValue = minSalary * 1000;
      double maxSalaryValue = maxSalary * 1000;

      return (minSalaryValue + maxSalaryValue) / 2.0;
    }

    final singleSalaryRegex = RegExp(r'\$(\d+)([kK])');
    final singleMatch = singleSalaryRegex.firstMatch(salary);
    if (singleMatch != null) {
      final salaryValue = double.tryParse(singleMatch.group(1) ?? '') ?? 0.0;

      return salaryValue * 1000;
    }
    return 0.0;
  }
}
