import 'package:flutter/material.dart';
import 'package:search_app_bar_page/search_app_bar_page.dart';
import '../presenters/search_presenter.dart';
import '../models/search_model.dart';

class SearchView extends StatefulWidget {
  final SearchPresenter searchPresenter;

  const SearchView({super.key, required this.searchPresenter});

  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  @override
  Widget build(BuildContext context) {
    return SearchAppBarPage<Job>(
      listFull: widget.searchPresenter.peopleList,
      stringFilter: (Job job) => job.jobName,
      obxListBuilder: (context, list, isModSearch) {
        if (list.isEmpty) {
          return const Center(
            child: Text(
              'NOTHING FOUND',
              style: TextStyle(fontSize: 14),
            ),
          );
        }
        return ListView.builder(
          itemCount: list.length,
          itemBuilder: (_, index) {
            final person = list[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Job Title: ${person.jobName}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Date Published: ${person.publishedDate}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
