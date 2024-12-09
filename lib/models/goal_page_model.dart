import 'package:northstars_final/models/goal_item.dart';
class GoalPageModel {

  // Sample method to fetch or process data
  Future<String> fetchData() async {
    await Future.delayed(const Duration(seconds: 2));
    return "Hello from Model!";
  }

  List<GoalItem> goals = [
    GoalItem('First goal', true),
    GoalItem('Second goal', false),
  ];


}
