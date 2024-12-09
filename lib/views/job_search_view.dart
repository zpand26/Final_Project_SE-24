import 'package:flutter/material.dart';
import '../presenters/job_search_presenter.dart';
import '../models/job_model.dart';
import 'job_search_view_contract.dart';
import 'package:search_app_bar_page/search_app_bar_page.dart';
import 'search_view.dart';

class JobSearchView extends StatefulWidget {
  final JobSearchPresenter presenter;
  final Function(int) onNavigate; // Add the onNavigate parameter

  const JobSearchView({
    Key? key,
    required this.presenter,
    required this.onNavigate, // Include onNavigate in the constructor
  }) : super(key: key);

  @override
  _JobSearchViewState createState() => _JobSearchViewState();
}

class _JobSearchViewState extends State<JobSearchView> implements JobSearchViewContract {
  List<Job> jobs = [];
  String errorMessage = "";
  bool isLoading = true;

  // Track selected filters
  String selectedWorkSetting = "All";
  String selectedEmploymentType = "All";

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
      widget.presenter.view?.showLoading();

      final filteredJobs = widget.presenter.repository.filterJobs(
        workSetting: selectedWorkSetting,
        employmentType: selectedEmploymentType,
      );

      widget.presenter.view?.showJobs(filteredJobs);
    } catch (e) {
      widget.presenter.view?.showError("Error occurred while filtering jobs: $e");
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
              if (value == 'search_view') {
                widget.onNavigate(0); // Navigate to the Search Tab
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'search_view',
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
            ],
          ),
          Expanded(
            child: SearchAppBarPage<Job>(
              listFull: jobs,
              stringFilter: (job) => job.jobTitle, // Filter by job title
              obxListBuilder: (context, filteredJobs, isModSearch) {
                if (filteredJobs.isEmpty) {
                  return const Center(
                    child: Text(
                      'NOTHING FOUND',
                      style: TextStyle(fontSize: 14),
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: filteredJobs.length,
                  itemBuilder: (context, index) {
                    final job = filteredJobs[index];
                    return ListTile(
                      title: Text(
                        '${job.jobTitle} (${job.experienceLevel.toUpperCase()})',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Work Setting: ${job.workSetting}'),
                          Text('Employment Type: ${job.employmentType}'),
                          Text('Category: ${job.jobCategory}'),
                          Text('Salary: ${job.salary} ${job.salaryCurrency} (\$${job.salaryInUsd.toStringAsFixed(2)} USD)'),
                          Text('Residence: ${job.employeeResidence}'),
                        ],
                      ),
                      isThreeLine: true,
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
