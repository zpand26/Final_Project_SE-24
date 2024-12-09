import '/models/software_job_model.dart';

abstract class SearchViewContract {
  void showJobs(List<SearchModel> jobs);
  void showError(String error);
  void showLoading();
}
