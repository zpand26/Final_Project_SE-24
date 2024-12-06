import 'dart:convert';
import 'package:flutter/services.dart';
import 'job_model.dart';

class JobRepository {
  late List<Job> _jobs;

  // Load jobs from a JSON file
  Future<void> loadJobsFromJson() async {
    final String response = await rootBundle.loadString('lib/assets/cleaned-data/cleaned_software_jobs.json');
    final List<dynamic> data = jsonDecode(response);
    _jobs = data.map((job) => Job.fromMap(job)).toList();
  }

  // Get all jobs
  List<Job> getAllJobs() {
    return _jobs;
  }

  // Get jobs filtered by work setting (e.g., "Remote", "Hybrid")
  List<Job> getJobsByWorkSetting(String workSetting) {
    if (workSetting.toLowerCase() == 'hybrid') {
      return _jobs.where((job) =>
      job.jobTitle.toLowerCase().contains('hybrid') ||
          (job.location.toLowerCase().contains(workSetting.toLowerCase()))
      ).toList();
    }
    return _jobs
        .where((job) => job.location.toLowerCase().contains(workSetting.toLowerCase()))
        .toList();
  }
}
