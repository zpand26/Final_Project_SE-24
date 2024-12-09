import 'package:northstars_final/models/goal_page_model.dart';
import 'package:northstars_final/models/goal_item.dart';
class GoalPagePresenter {
  final GoalPageModel goalPageModel;
  final Function(List<GoalPageModel>) updateView;

  GoalPagePresenter(this.goalPageModel, this.updateView);

  List<GoalItem> getGoals(){
    return goalPageModel.goals;
  }

  void addGoal(GoalItem goal){
    goalPageModel.goals.add(goal);
  }


}