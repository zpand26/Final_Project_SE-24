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
  List<Job> displayedJobs = [];
  String errorMessage = "";
  bool isLoading = true;

  // Track selected filters
  String selectedWorkSetting = "All";
  String selectedEmploymentType = "All";
  String selectedSalarySortOption = "None";
  String selectedCompanySize = "All";
  String searchQuery = "";

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.presenter.view = this;
    widget.presenter.loadJobs();
  }

  @override
  void showJobs(List<Job> newJobs) {
    setState(() {
      jobs = newJobs;
      displayedJobs = newJobs;
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

      // Filter jobs based on work setting, employment type, and company size
      List<Job> filteredJobs = widget.presenter.repository.filterJobs(
        workSetting: selectedWorkSetting,
        employmentType: selectedEmploymentType,
        companySize: selectedCompanySize,
      );

      // Apply salary sorting
      if (selectedSalarySortOption == "Salary: Low to High") {
        filteredJobs.sort((a, b) => a.salaryInUsd.compareTo(b.salaryInUsd));
      } else if (selectedSalarySortOption == "Salary: High to Low") {
        filteredJobs.sort((a, b) => b.salaryInUsd.compareTo(a.salaryInUsd));
      }

      // Apply search query
      if (searchQuery.isNotEmpty) {
        filteredJobs = filteredJobs
            .where((job) => job.jobTitle.toLowerCase().contains(searchQuery.toLowerCase()))
            .toList();
      }

      setState(() {
        displayedJobs = filteredJobs;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        widget.presenter.view?.showError("Error filtering jobs: $e");
      });
    }
  }

  // Show filter dialog
  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Apply Filters'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Work Setting
                  DropdownButton<String>(
                    value: selectedWorkSetting,
                    items: ["All", "In-person", "Remote", "Hybrid"]
                        .map((setting) => DropdownMenuItem(
                      value: setting,
                      child: Text(setting),
                    ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedWorkSetting = value!;
                      });
                    },
                  ),

                  // Employment Type
                  DropdownButton<String>(
                    value: selectedEmploymentType,
                    items: ["All", "Full-time", "Part-time"]
                        .map((type) => DropdownMenuItem(
                      value: type,
                      child: Text(type),
                    ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedEmploymentType = value!;
                      });
                    },
                  ),

                  // Company Size
                  DropdownButton<String>(
                    value: selectedCompanySize,
                    items: ["All", "S", "M", "L"]
                        .map((size) => DropdownMenuItem(
                      value: size,
                      child: Text(size),
                    ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCompanySize = value!;
                      });
                    },
                  ),

                  // Salary Sort Option
                  DropdownButton<String>(
                    value: selectedSalarySortOption,
                    items: ["None", "Salary: Low to High", "Salary: High to Low"]
                        .map((option) => DropdownMenuItem(
                      value: option,
                      child: Text(option),
                    ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedSalarySortOption = value!;
                      });
                    },
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    applyFilters();
                    Navigator.pop(context);
                  },
                  child: Text('Apply'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Job Search'),
        actions: [
          // Filter Button
          IconButton(
            icon: Icon(Icons.filter_alt),
            onPressed: _showFilterDialog,
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'search_view') {
                widget.onNavigate(0);
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
                        Text('Company Size: ${job.companySize.toUpperCase()}'),
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
