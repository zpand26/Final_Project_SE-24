import '../models/search_model.dart';

class SearchPresenter {
  final SearchModel _model;

  SearchPresenter(this._model);

  // Expose the job list
  List<Map<String, dynamic>> get jobList => _model.jobList;

  // Method to load jobs from JSON
  Future<void> loadJobs(String assetPath) async {
    await _model.loadJobsFromJson(assetPath);
  }

  // Method to filter jobs
  Future<List<Map<String, dynamic>>> filterJobs({
    required String locationFilter,
    required String titleFilter,
    required String searchQuery,
  }) async {
    return _model.filterJobs(
      locationFilter: locationFilter,
      titleFilter: titleFilter,
      searchQuery: searchQuery,
    );
  }
}
