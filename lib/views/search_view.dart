import 'package:flutter/material.dart';
import 'package:search_app_bar_page/search_app_bar_page.dart';
import '../presenters/search_presenter.dart';
import 'job_search_view.dart';
import '../presenters/job_search_presenter.dart';

class SearchView extends StatefulWidget {
  final SearchPresenter searchPresenter;
  final JobSearchPresenter jobSearchPresenter;
  final Function(int) onNavigate; // Add the onNavigate callback

  const SearchView({
    super.key,
    required this.searchPresenter,
    required this.jobSearchPresenter,
    required this.onNavigate, // Include onNavigate in the constructor
  });

  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  @override
  void initState() {
    super.initState();
    widget.searchPresenter.loadJobs('assets/cleaned_data_jobs_test.csv').then((_) {
      setState(() {}); // Refresh the UI after loading jobs
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search View'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'Go to Job Search') {
                widget.onNavigate(2); // Navigate to Job Search Tab
              } else if (value == 'Go to Search View') {
                widget.onNavigate(0); // Navigate to Search Tab
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'Go to Job Search',
                child: Text('Go to Job Search'),
              ),
              const PopupMenuItem(
                value: 'Go to Search View',
                child: Text('Go to Search View'),
              ),
            ],
          ),
        ],
      ),
      body: SearchAppBarPage<Map<String, dynamic>>(
        listFull: widget.searchPresenter.peopleList,
        stringFilter: (job) => job['jobTitle'],
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
              final job = list[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        job['jobTitle'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Category: ${job['jobCategory']}',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      Text('Work Year: ${job['workYear']}', style: const TextStyle(fontSize: 14)),
                      Text(
                          'Salary: ${job['salary']} ${job['salaryCurrency']} (${job['salaryInUsd']} USD)',
                          style: const TextStyle(fontSize: 14)),
                      Text('Experience: ${job['experienceLevel']}',
                          style: const TextStyle(fontSize: 14)),
                      Text('Employment Type: ${job['employmentType']}',
                          style: const TextStyle(fontSize: 14)),
                      Text('Work Setting: ${job['workSetting']}',
                          style: const TextStyle(fontSize: 14)),
                      Text('Company Location: ${job['companyLocation']}',
                          style: const TextStyle(fontSize: 14)),
                      Text('Company Size: ${job['companySize']}',
                          style: const TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
