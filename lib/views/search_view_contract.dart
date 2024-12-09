import '/models/search_model.dart';

abstract class SearchViewContract {
  void showJobs(List<SearchModel> jobs);
  void showError(String error);
  void showLoading();
}
