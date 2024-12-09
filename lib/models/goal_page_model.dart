class GoalPageModel {
  String? id;
  String? todoText;
  bool isDone;

  GoalPageModel({
    required this.id,
    required this.todoText,
    this.isDone = false,
  });

  // Sample method to fetch or process data
  Future<String> fetchData() async {
    await Future.delayed(const Duration(seconds: 2));
    return "Hello from Model!";
  }

  static List<GoalPageModel> todoList() {
    return [
      GoalPageModel(id: '01', todoText: 'Morning Exercise', isDone: true),
      GoalPageModel(id: '02', todoText: 'Buy Groceries', isDone: true),
      GoalPageModel(id: '03', todoText: 'Check Emails'),
      GoalPageModel(id: '04', todoText: 'Team Meeting'),
      GoalPageModel(id: '05', todoText: 'Work on mobile apps for 2 hours'),
      GoalPageModel(id: '06', todoText: 'Dinner with Jenny'),
    ];
  }
}
