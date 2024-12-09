import 'package:flutter/material.dart';
import 'package:search_app_bar_page/search_app_bar_page.dart';
import '../presenters/search_presenter.dart';
import '../presenters/job_search_presenter.dart';

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

class _SearchViewState extends State<SearchView> {
  String selectedLocationFilter = "All";
  String selectedTitleFilter = "All";
  String searchQuery = ""; // State for the search bar
  List<Map<String, dynamic>> filteredJobs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadJobs();
  }

  Future<void> _loadJobs() async {
    setState(() {
      isLoading = true;
    });
    await widget.searchPresenter.loadJobs('lib/assets/cleaned-data/cleaned_software_jobs.json');
    setState(() {
      filteredJobs = widget.searchPresenter.jobList;
      isLoading = false;
    });
  }

  Future<void> applyFilters() async {
    setState(() {
      isLoading = true;
    });
    try {
      final filtered = await Future.delayed(const Duration(milliseconds: 100), () {
        return widget.searchPresenter.filterJobs(
          locationFilter: selectedLocationFilter,
          titleFilter: selectedTitleFilter,
          searchQuery: searchQuery,
        );
      });
      setState(() {
        filteredJobs = filtered;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error applying filters: $e");
    }
  }

  void onSearch(String query) {
    setState(() {
      searchQuery = query;
    });
    applyFilters();
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
                widget.onNavigate(2); // Navigate to Software Job Search Tab
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
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
          Expanded(
            child: SearchAppBarPage<Map<String, dynamic>>(
              listFull: filteredJobs,
              stringFilter: (job) => job['Job Title'] ?? '',
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
                              job['Job Title'] ?? "N/A",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text('Company: ${job['Company'] ?? "N/A"}',
                                style: const TextStyle(fontSize: 16)),
                            Text('Score: ${job['Company Score'] ?? "N/A"}',
                                style: const TextStyle(fontSize: 16)),
                            Text('Location: ${job['Location'] ?? "N/A"}',
                                style: const TextStyle(fontSize: 16)),
                            Text('Date Posted: ${job['Date'] ?? "N/A"}',
                                style: const TextStyle(fontSize: 16)),
                            Text('Salary: ${job['Salary'] ?? "N/A"}',
                                style: const TextStyle(fontSize: 16)),
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
