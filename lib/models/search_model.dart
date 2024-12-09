class SearchModel {
  final String company;
  final double companyScore;
  final String jobTitle;
  final String location;
  final String date;
  final String salary;

  SearchModel({
    required this.company,
    required this.companyScore,
    required this.jobTitle,
    required this.location,
    required this.date,
    required this.salary,
  });

  factory SearchModel.fromMap(Map<String, dynamic> map) {
    return SearchModel(
      company: map['Company'] ?? '',
      companyScore: (map['Company Score'] ?? 0).toDouble(),
      jobTitle: map['Job Title'] ?? '',
      location: map['Location'] ?? '',
      date: map['Date'] ?? '',
      salary: map['Salary'] ?? '',
    );
  }
}
