class Job {
  final int workYear; // Added workYear field
  final String jobTitle;
  final String jobCategory;
  final String salaryCurrency;
  final double salary;
  final double salaryInUsd;
  final String employeeResidence;
  final String experienceLevel;
  final String employmentType;
  final String workSetting;
  final String companyLocation;
  final String companySize;

  Job({
    required this.workYear, // Add workYear to constructor
    required this.jobTitle,
    required this.jobCategory,
    required this.salaryCurrency,
    required this.salary,
    required this.salaryInUsd,
    required this.employeeResidence,
    required this.experienceLevel,
    required this.employmentType,
    required this.workSetting,
    required this.companyLocation,
    required this.companySize,
  });

  factory Job.fromMap(Map<String, dynamic> map) {
    return Job(
      workYear: map['work_year'] ?? 0, // Parse workYear from the map
      jobTitle: map['job_title'] ?? '',
      jobCategory: map['job_category'] ?? '',
      salaryCurrency: map['salary_currency'] ?? '',
      salary: (map['salary'] ?? 0).toDouble(),
      salaryInUsd: (map['salary_in_usd'] ?? 0).toDouble(),
      employeeResidence: map['employee_residence'] ?? '',
      experienceLevel: map['experience_level'] ?? '',
      employmentType: map['employment_type'] ?? '',
      workSetting: map['work_setting'] ?? '',
      companyLocation: map['company_location'] ?? '',
      companySize: map['company_size'] ?? '',
    );
  }
}
