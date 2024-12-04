class Job {
  final String jobName;
  final String publishedDate;
  // add more functions if needed like location and salary too
  //int or string for date?

  Job({required this.jobName, required this.publishedDate});
}

class SearchModel {
  final List<Job> peopleList = [
    Job(jobName: 'Software Engineering', publishedDate: '1/1/1'),
    Job(jobName: 'Software', publishedDate: '1/1/1'),

  ];
}
