import 'package:flutter/material.dart';
import 'models/job_repository_model.dart';
import 'presenters/job_search_presenter.dart';
import 'views/job_search_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final jobRepository = JobRepository();
    final jobSearchPresenter = JobSearchPresenter(jobRepository);
    final jobSearchView = JobSearchView(presenter: jobSearchPresenter);

    return MaterialApp(
      title: 'Job Search App',
      home: jobSearchView,
    );
  }
}
