import 'package:flutter/material.dart';
import 'package:search_app_bar_page/search_app_bar_page.dart';
import '../presenters/search_presenter.dart';
import '../presenters/job_search_presenter.dart';

class SearchView extends StatefulWidget {
  final SearchPresenter searchPresenter;
  final JobSearchPresenter jobSearchPresenter; // Keep JobSearchPresenter
  final Function(int) onNavigate;

  const SearchView({
    super.key,
    required this.searchPresenter,
    required this.jobSearchPresenter, // Include JobSearchPresenter
    required this.onNavigate,
  });

  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  @override
  void initState() {
    super.initState();
    widget.searchPresenter
        .loadJobs('lib/assets/cleaned-data/cleaned_software_jobs.json')
        .then((_) {
      setState(() {}); // Refresh the UI after loading jobs
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Job Search'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'Go to Job Search') {
                widget.onNavigate(2); // Navigate to Job Search Tab
              } else if (value == '') {
                widget.onNavigate(0); // Navigate to Search Tab
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'Go to Job Search',
                child: Text('Go to Software Job Search'),
              ),
            ],
          ),
        ],
      ),
      body: SearchAppBarPage<Map<String, dynamic>>(
        listFull: widget.searchPresenter.jobList,
        stringFilter: (job) => job['Job Title'],
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
                        job['Job Title'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text('Company: ${job['Company']}', style: const TextStyle(fontSize: 16)),
                      Text('Score: ${job['Company Score']}', style: const TextStyle(fontSize: 16)),
                      Text('Location: ${job['Location']}', style: const TextStyle(fontSize: 16)),
                      Text('Date Posted: ${job['Date']}', style: const TextStyle(fontSize: 16)),
                      Text('Salary: ${job['Salary']}', style: const TextStyle(fontSize: 16)),
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
