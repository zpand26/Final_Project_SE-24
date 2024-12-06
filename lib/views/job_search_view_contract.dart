import '../models/job_model.dart';

abstract class JobSearchViewContract {
  void showJobs(List<Job> jobs);
  void showError(String error);
  void showLoading();
}
