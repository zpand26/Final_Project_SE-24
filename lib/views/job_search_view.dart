import 'package:flutter/material.dart';
import '../presenters/job_search_presenter.dart';
import '../models/data_job_model.dart';
import 'job_search_view_contract.dart';

class JobSearchView extends StatefulWidget {
  final JobSearchPresenter presenter;
  final Function(int) onNavigate;

  const JobSearchView({
    Key? key,
    required this.presenter,
    required this.onNavigate,
  }) : super(key: key);

  @override
  _JobSearchViewState createState() => _JobSearchViewState();
}

class _JobSearchViewState extends State<JobSearchView> implements JobSearchViewContract {
  List<Job> jobs = [];
  List<Job> displayedJobs = []; // Jobs to display after filtering and searching
  String errorMessage = "";
  bool isLoading = true;

  // Track selected filters
  String selectedWorkSetting = "All";
  String selectedEmploymentType = "All";
  String selectedSortOption = "None";
  String searchQuery = ""; // Track search query

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.presenter.view = this; // Attach the view to the presenter
    widget.presenter.loadJobs(); // Load jobs initially
  }

  @override
  void showJobs(List<Job> newJobs) {
    setState(() {
      jobs = newJobs;
      displayedJobs = newJobs; // Display all jobs initially
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

  // Apply filters and search query
  Future<void> applyFilters() async {
    try {
      setState(() {
        isLoading = true;
      });

      // Filter jobs based on work setting and employment type
      List<Job> filteredJobs = widget.presenter.repository.filterJobs(
        workSetting: selectedWorkSetting,
        employmentType: selectedEmploymentType,
      );

      // Apply sorting
      if (selectedSortOption == "Salary: Low to High") {
        filteredJobs.sort((a, b) => a.salary.compareTo(b.salary));
      } else if (selectedSortOption == "Salary: High to Low") {
        filteredJobs.sort((a, b) => b.salary.compareTo(a.salary));
      }

      // Apply search query
      if (searchQuery.isNotEmpty) {
        filteredJobs = filteredJobs
            .where((job) => job.jobTitle.toLowerCase().contains(searchQuery.toLowerCase()))
            .toList();
      }

      setState(() {
        displayedJobs = filteredJobs; // Update displayed jobs
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        widget.presenter.view?.showError("Error filtering jobs: $e");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Job Search'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'search_view') {
                widget.onNavigate(0); // Navigate to the Search Tab
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'search_view',
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
          if (errorMessage.isNotEmpty)
            Text(
              errorMessage,
              style: const TextStyle(color: Colors.red),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Work Setting Filter
              DropdownButton<String>(
                value: selectedWorkSetting,
                items: ["All", "In-person", "Remote", "Hybrid"]
                    .map((setting) => DropdownMenuItem(
                  value: setting,
                  child: Text(setting),
                ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedWorkSetting = value;
                      isLoading = true;
                    });
                    applyFilters();
                  }
                },
              ),

              // Employment Type Filter
              DropdownButton<String>(
                value: selectedEmploymentType,
                items: ["All", "Full-time", "Part-time"]
                    .map((type) => DropdownMenuItem(
                  value: type,
                  child: Text(type),
                ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedEmploymentType = value;
                      isLoading = true;
                    });
                    applyFilters();
                  }
                },
              ),

              // Sorting Filter
              DropdownButton<String>(
                value: selectedSortOption,
                items: ["None", "Salary: Low to High", "Salary: High to Low"]
                    .map((sortOption) => DropdownMenuItem(
                  value: sortOption,
                  child: Text(sortOption),
                ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedSortOption = value;
                      isLoading = true;
                    });
                    applyFilters();
                  }
                },
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
                applyFilters();
              },
              style: const TextStyle(fontSize: 16),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: "Search jobs...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child: displayedJobs.isEmpty
                ? const Center(
              child: Text(
                'NOTHING FOUND',
                style: TextStyle(fontSize: 14),
              ),
            )
                : ListView.builder(
              itemCount: displayedJobs.length,
              itemBuilder: (context, index) {
                final job = displayedJobs[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 4),
                  child: ListTile(
                    title: Text(
                      '${job.jobTitle} (${job.experienceLevel.toUpperCase()})',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Work Setting: ${job.workSetting}'),
                        Text('Employment Type: ${job.employmentType}'),
                        Text('Category: ${job.jobCategory}'),
                        Text(
                            'Salary: ${job.salary} ${job.salaryCurrency} (\$${job.salaryInUsd.toStringAsFixed(2)} USD)'),
                        Text('Residence: ${job.employeeResidence}'),
                      ],
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
