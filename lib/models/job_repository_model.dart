import 'dart:convert';
import 'package:flutter/services.dart';
import 'job_model.dart';

class JobRepository {
  List<Job> _jobs = []; // Initialize as an empty list

  Future<void> loadJobsFromJson() async {
    if (_jobs.isEmpty) {
      final String response = await rootBundle.loadString('lib/assets/cleaned-data/cleaned_software_jobs.json');
      final List<dynamic> data = jsonDecode(response);
      _jobs = data.map((job) => Job.fromMap(job)).toList();
      print("Jobs loaded successfully: ${_jobs.length}");
    }
  }

  List<Job> getAllJobs() {
    print("Fetching all jobs: ${_jobs.length}");
    return List.from(_jobs); // Return a copy to prevent accidental modification
  }

  List<Job> getJobsByWorkSetting(String workSetting) {
    if (_jobs.isEmpty) {
      throw Exception("No jobs loaded. Please call loadJobsFromJson first.");
    }

    final setting = workSetting.toLowerCase();
    if (setting == "all") {
      return List.from(_jobs);
    }

    return _jobs.where((job) {
      final location = job.location.toLowerCase();
      final title = job.jobTitle.toLowerCase();
      return location.contains(setting) || title.contains(setting);
    }).toList();
  }
}
