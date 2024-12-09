import 'package:flutter/material.dart';
import 'package:search_app_bar_page/search_app_bar_page.dart';
import '/presenters/search_presenter.dart';
import '/presenters/job_search_presenter.dart';
import '/models/search_model.dart';
import 'search_view_contract.dart';

class SearchView extends StatefulWidget {
  final SearchPresenter searchPresenter;
  final JobSearchPresenter jobSearchPresenter;
  final Function(int) onNavigate;

  const SearchView({
    Key? key,
    required this.searchPresenter,
    required this.jobSearchPresenter,
    required this.onNavigate,
  }) : super(key: key);

  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> implements SearchViewContract {
  List<SearchModel> jobs = [];
  List<SearchModel> filteredJobs = [];
  String errorMessage = "";
  bool isLoading = true;

  String selectedLocationFilter = "All";
  String selectedTitleFilter = "All";

  @override
  void initState() {
    super.initState();
    widget.searchPresenter.view = this;
    widget.searchPresenter.loadJobs();
  }

  @override
  void showJobs(List<SearchModel> newJobs) {
    setState(() {
      jobs = newJobs;
      filteredJobs = newJobs;
      isLoading = false;
      errorMessage = "";
    });
  }

  @override
  void showError(String error) {
    setState(() {
      errorMessage = error;
      isLoading = false;
    });
  }

  @override
  void showLoading() {
    setState(() {
      isLoading = true;
    });
  }

  Future<void> applyFilters() async {
    try {
      widget.searchPresenter.view?.showLoading();

      final filteredJobs = widget.searchPresenter.repository.filterJobs(
        location: selectedLocationFilter,
        jobTitle: selectedTitleFilter,
      );

      widget.searchPresenter.view?.showJobs(filteredJobs);
    } catch (e) {
      widget.searchPresenter.view?.showError("Error occurred while filtering jobs: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Software Job Search'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'Go to Job Search') {
                widget.onNavigate(2); // Navigate to a specific view
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'Go to Job Search',
                child: Text('Go to Data Job Search'),
              ),
            ],
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          // Filters
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              DropdownButton<String>(
                value: selectedLocationFilter,
                items: ["All", "Remote", "Hybrid"]
                    .map((location) => DropdownMenuItem(
                  value: location,
                  child: Text(location),
                ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedLocationFilter = value;
                    });
                    applyFilters();
                  }
                },
              ),
              DropdownButton<String>(
                value: selectedTitleFilter,
                items: ["All", "Full-time", "Part-time"]
                    .map((title) => DropdownMenuItem(
                  value: title,
                  child: Text(title),
                ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedTitleFilter = value;
                    });
                    applyFilters();
                  }
                },
              ),
            ],
          ),
          // Results
          Expanded(
            child: filteredJobs.isEmpty
                ? const Center(
              child: Text(
                'No jobs found',
                style: TextStyle(fontSize: 16),
              ),
            )
                : SearchAppBarPage<SearchModel>(
              listFull: filteredJobs,
              stringFilter: (job) => job.jobTitle,
              obxListBuilder: (context, list, isModSearch) {
                return ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (_, index) {
                    final job = list[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: ListTile(
                        title: Text('${job.jobTitle} - ${job.company})',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                    subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Location: ${job.location}'),
                            Text('Salary: ${job.salary}'),
                            Text('Score: ${job.companyScore}'),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
