import '/models/search_repository_model.dart';
import '/models/search_model.dart';
import '/views/search_view_contract.dart';

class SearchPresenter {
  final SearchRepositoryModel repository;
  SearchViewContract? view;

  SearchPresenter(this.repository);

  Future<void> loadJobs() async {
    try {
      view?.showLoading();
      await repository.loadJobsFromJson();
      final jobs = repository.getAllJobs();
      view?.showJobs(jobs);
    } catch (e) {
      view?.showError("Failed to load jobs: $e");
    }
  }

  Future<void> filterJobs({String location = "all", String jobTitle = "all"}) async {
    try {
      view?.showLoading();
      final jobs = repository.filterJobs(location: location, jobTitle: jobTitle);
      if (jobs.isEmpty) {
        view?.showError("No jobs found for the selected filters.");
      } else {
        view?.showJobs(jobs);
      }
    } catch (e) {
      view?.showError("Error occurred while filtering jobs: $e");
    }
  }
}
