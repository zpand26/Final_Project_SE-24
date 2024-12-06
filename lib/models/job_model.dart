class Job {
  final String company;
  final double companyScore;
  final String jobTitle;
  final String location;
  final String date;
  final String salaryRange;
  //final String workSetting;

  Job({
    required this.company,
    required this.companyScore,
    required this.jobTitle,
    required this.location,
    required this.date,
    required this.salaryRange,
    //required this.workSetting,
  });

  factory Job.fromMap(Map<String, dynamic> map) {
    return Job(
      company: map['Company'],
      companyScore: map['Company Score']?.toDouble() ?? 0.0,
      jobTitle: map['Job Title'] ?? '',
      location: map['Location'] ?? '',
      date: map['Date'] ?? '',
      salaryRange: map['Salary'] ?? '',
      //workSetting: map['WorkSetting'] ?? map['Location'],
    );
  }
}
