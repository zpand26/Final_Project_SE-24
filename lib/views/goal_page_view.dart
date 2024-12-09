import 'package:flutter/material.dart';
import 'package:northstars_final/presenters/goal_page_presenter.dart';
import 'package:northstars_final/models/goal_page_model.dart';
import 'package:northstars_final/models/goal_item.dart';

class GoalPageView extends StatefulWidget {
  final GoalPagePresenter goalPagePresenter;

  const GoalPageView(this.goalPagePresenter, {super.key});

  @override
  _goalPageViewState createState() => _goalPageViewState();
}

class _goalPageViewState extends State<GoalPageView> {

  final _goalController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void updateView(List<GoalPageModel> todos) {
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children:
          generateGoalList(),
      )
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.yellow,
      elevation: 0,
      title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Icon(
          Icons.menu,
          color: Colors.black,
          size: 30,
        ),
        Container(
          height: 40,
          width: 40,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset('assets/images/avatar.jpeg'),
          ),
        ),
      ]),
    );
  }

  List<Widget> generateGoalList(){
    List<Text> list = [];
    for (GoalItem goal in widget.goalPagePresenter.getGoals()){
      var text =
      Text('${goal.description}');
      list.add(text);
    }
    return list;
  }


}
