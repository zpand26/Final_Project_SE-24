import 'dart:convert';
import 'package:flutter/services.dart';
import 'data_job_model.dart';

class JobRepository {
  List<Job> _jobs = []; // Initialize as an empty list

  Future<void> loadJobsFromJson() async {
    if (_jobs.isEmpty) {
      final String response = await rootBundle.loadString('lib/assets/cleaned-data/cleaned_data_jobs.json');
      final List<dynamic> data = jsonDecode(response);
      _jobs = data.map((job) => Job.fromMap(job)).toList();
      print("Jobs loaded successfully: ${_jobs.length}");
    }
  }

  List<Job> getAllJobs() {
    print("Fetching all jobs: ${_jobs.length}");
    return List.from(_jobs); // Return a copy to prevent accidental modification
  }

  List<Job> filterJobs({
    String workSetting = "all",
    String employmentType = "all",
    String companySize = "all"
  }) {
    if (_jobs.isEmpty) {
      throw Exception("No jobs loaded. Please call loadJobsFromJson first.");
    }

    return _jobs.where((job) {
      final matchesWorkSetting = workSetting.toLowerCase() == "all" ||
          job.workSetting.toLowerCase() == workSetting.toLowerCase();

      final matchesEmploymentType = employmentType.toLowerCase() == "all" ||
          job.employmentType.toLowerCase() == employmentType.toLowerCase();

      final matchesCompanySize = companySize.toLowerCase() == "all" ||
          job.companySize.toLowerCase() == companySize.toLowerCase(); // Apply company size filter

      return matchesWorkSetting && matchesEmploymentType && matchesCompanySize;
    }).toList();
  }
}
