import 'package:flutter/material.dart';
import 'package:search_app_bar_page/search_app_bar_page.dart';
import '../presenters/search_presenter.dart';

class SearchView extends StatefulWidget {
  final SearchPresenter searchPresenter;

  const SearchView({super.key, required this.searchPresenter});

  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  @override
  void initState() {
    super.initState();
    // Load jobs from the CSV file
    widget.searchPresenter.loadJobs('assets/cleaned_software_jobs_test.csv').then((_) {
      setState(() {}); // Refresh the UI after loading jobs
    });
  }

  @override
  Widget build(BuildContext context) {
    return SearchAppBarPage<Map<String, dynamic>>(
      listFull: widget.searchPresenter.peopleList,
      stringFilter: (job) => job['jobTitle'], // Filter by job title
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
                    // Job Title (Bold and at the top)
                    Text(
                      job['jobTitle'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Company Name
                    Text(
                      'Company: ${job['company']}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Remaining fields
                    Text('Score: ${job['companyScore']}', style: const TextStyle(fontSize: 14)),
                    Text('Location: ${job['location']}', style: const TextStyle(fontSize: 14)),
                    Text('Date: ${job['date']}', style: const TextStyle(fontSize: 14)),
                    Text('Salary: ${job['salary']}', style: const TextStyle(fontSize: 14)),
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
