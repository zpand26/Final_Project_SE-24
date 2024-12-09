import '../models/search_model.dart';

class SearchPresenter {
  final SearchModel _model;

  SearchPresenter(this._model);

  List<Map<String, dynamic>> get jobList => _model.jobList;

  // Load jobs from the model using JSON
  Future<void> loadJobs(String assetPath) async {
    await _model.loadJobsFromJson(assetPath);
  }
}
