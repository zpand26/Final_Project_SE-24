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
  String _selectedFilter = "All"; // Track the selected filter

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
          DropdownButton<String>(
            value: _selectedFilter,
            items: ["All", "Full-time", "Part-time", "Remote", "Hybrid"]
                .map((setting) => DropdownMenuItem(
              value: setting,
              child: Text(setting),
            ))
                .toList(),
            onChanged: (value) async {
              if (value != null) {
                setState(() {
                  _selectedFilter = value; // Update the selected filter
                  isLoading = true; // Show the loading spinner
                  jobs = []; // Clear the jobs list
                });

                // Ensure asynchronous completion of filtering logic
                 widget.presenter.filterJobsByWorkSetting(value);

                setState(() {
                  isLoading = false; // Hide loading spinner after filter application
                });
              }
            },
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
                      title: Text(job.jobTitle),
                      subtitle: Text('${job.location} • ${job.salaryRange}'),
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
