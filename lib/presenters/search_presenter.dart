import '../models/search_model.dart';

class SearchPresenter {
  final SearchModel _model;

  SearchPresenter(this._model);

  List<Job> get peopleList => _model.peopleList;
}
