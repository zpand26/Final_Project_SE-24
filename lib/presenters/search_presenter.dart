import '../models/search_model.dart';

class SearchPresenter {
  final SearchModel _model;

  SearchPresenter(this._model);

  List<Map<String, dynamic>> get peopleList => _model.peopleList;

  Future<void> loadJobs(String assetPath) async {
    await _model.loadJobsFromCsv(assetPath);
  }
}
