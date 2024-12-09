import '../models/job_repository_model.dart';
import '../models/job_model.dart';
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

  Future<void> filterJobsByWorkSetting(String workSetting) async {
    try {
      view?.showLoading();

      // Reload jobs if the main list is empty
      if (repository.getAllJobs().isEmpty) {
        await repository.loadJobsFromJson();
      }

      List<Job> jobs = [];
      if (workSetting.toLowerCase() == "all") {
        jobs = repository.getAllJobs();
      } else {
        jobs = repository.getJobsByWorkSetting(workSetting);
      }

      if (jobs.isEmpty) {
        view?.showError("No jobs found for the selected filter.");
      } else {
        view?.showJobs(jobs);
      }
    } catch (e) {
      view?.showError("Error occurred while filtering jobs: $e");
    }
  }




}

