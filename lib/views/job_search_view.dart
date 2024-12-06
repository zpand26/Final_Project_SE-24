import 'package:flutter/material.dart';
import '../presenters/job_search_presenter.dart';
import '../models/job_model.dart';
import 'job_search_view_contract.dart';

class JobSearchView extends StatefulWidget {
  final JobSearchPresenter presenter;

  const JobSearchView({required this.presenter, Key? key}) : super(key: key);

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
        title: const Text('Job Search'),
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
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedFilter = value; // Track the selected filter
                });
                widget.presenter.filterJobsByWorkSetting(value);
              }
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: jobs.length,
              itemBuilder: (context, index) {
                final job = jobs[index];
                return ListTile(
                  title: Text(job.jobTitle),
                  subtitle: Text('${job.location} • ${job.salaryRange}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
