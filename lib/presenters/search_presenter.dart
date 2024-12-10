import '/models/software_job_repository_model.dart';
import '/models/software_job_model.dart';
import '/views/search_view_contract.dart';
import 'package:northstars_final/models/citySalaryStats.dart';

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

  Future<void> filterJobs(
      {String location = "all", String jobTitle = "all"}) async {
    try {
      view?.showLoading();
      final jobs = repository.filterJobs(
          location: location, jobTitle: jobTitle);
      if (jobs.isEmpty) {
        view?.showError("No jobs found for the selected filters.");
      } else {
        view?.showJobs(jobs);
      }
    } catch (e) {
      view?.showError("Error occurred while filtering jobs: $e");
    }
  }

  List<CitySalaryStats> sortCities(List<SearchModel> jobs) {
    List<SearchModel> unsortedJobs = jobs;
    List<List<SearchModel>> cityJobs = repository.sortSalaries(unsortedJobs);
    List<CitySalaryStats> citySalaryStats = [];

    for (var cityJobList in cityJobs) {
      double minSalary = double.infinity;
      double maxSalary = -double.infinity;
      double totalSalary = 0;
      int jobCount = 0;

      for (var job in cityJobList) {
        double salary = _parseSalary(job.salary);

        minSalary = salary < minSalary ? salary : minSalary;
        maxSalary = salary > maxSalary ? salary : maxSalary;
        totalSalary += salary;
        jobCount++;
      }

      double averageSalary = jobCount > 0 ? totalSalary / jobCount : 0.0;

      citySalaryStats.add(
        CitySalaryStats(
          city: cityJobList.first.location,
          minSalary: minSalary,
          maxSalary: maxSalary,
          averageSalary: averageSalary,
        ),
      );
    }
    citySalaryStats.sort((a, b) => b.averageSalary.compareTo(a.averageSalary));

    return citySalaryStats;
  }

  double _parseSalary(String salary) {
    final rangeRegex = RegExp(r'\$(\d+)([kK])\s*-\s*\$(\d+)([kK])');

    final match = rangeRegex.firstMatch(salary);
    if (match != null) {
      final minSalary = double.tryParse(match.group(1) ?? '') ?? 0.0;
      final maxSalary = double.tryParse(match.group(3) ?? '') ?? 0.0;
      return (minSalary * 1000 + maxSalary * 1000) / 2.0;
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