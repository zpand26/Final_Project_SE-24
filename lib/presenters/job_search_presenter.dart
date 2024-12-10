import '../models/data_job_repository_model.dart';
import '../models/data_job_model.dart';
import '../views/job_search_view_contract.dart';
import '../presenters/search_presenter.dart';

class JobSearchPresenter {
  final JobRepository repository;
  final SearchPresenter searchPresenter;
  JobSearchViewContract? view;

  JobSearchPresenter(this.repository, this.searchPresenter);

  Future<void> loadJobs() async {
    try {
      view?.showLoading(); // Show loading spinner
      await repository.loadJobsFromJson(); // Load jobs from the JSON file
      final jobs = repository.getAllJobs(); // Get all jobs to display by default
      view?.showJobs(jobs); // Pass all jobs to the view
    } catch (e) {
      view?.showError("Failed to load jobs: $e"); // Show an error if something goes wrong
    }
  }

  Future<void> filterJobs({String workSetting = "all", String employmentType = "all"}) async {
    try {
      view?.showLoading();

      // Reload jobs if the main list is empty
      if (repository.getAllJobs().isEmpty) {
        await repository.loadJobsFromJson();
      }

      // Filter jobs using the new filterJobs method
      final jobs = repository.filterJobs(workSetting: workSetting, employmentType: employmentType);

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
