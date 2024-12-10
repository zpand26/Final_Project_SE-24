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

  final TextEditingController _goalController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void updateView(List<GoalPageModel> goals) {
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          generateAddGoalForm(),
          generateClearAllButton(),
          Expanded(
          child: ListView(
            children:
          generateGoalList(),
          ),
          ),
      ],
      ),
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
    List<GestureDetector> list = [];
    for (GoalItem goal in widget.goalPagePresenter.getGoals()){
      var text =
      GestureDetector(
        onTap: ()
      {
        setState(() {
          goal.done = !goal.done;
        });
      },
    child:
      Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: ListTile(
            title: Text('${goal.description}',
            style:
          TextStyle(
            fontSize: 22,
            color: goal.done ? Colors.grey
                : Colors.black,
            decoration: goal.done ?
            TextDecoration.lineThrough :
            TextDecoration.none,
          ),
          ),
      ),
      )
      );
      list.add(text);
    }
    return list;
  }

  Column generateAddGoalForm(){
    return Column(
      children: <Widget>[
        TextField(controller: _goalController,),
        ElevatedButton(
          child: Text('Add Goal'),
          onPressed: (){
            if (_goalController.text.isNotEmpty){
              setState((){
                widget.goalPagePresenter.addGoal(GoalItem(_goalController.text, false));
                _goalController.text = '';
              },
              );
            }
          }
        ),
      ],
    );
  }

  ElevatedButton generateClearAllButton(){
  return ElevatedButton(
    child: Text ('Remove all'),
     onPressed: (){
      _confirmClear();
      });
  }

    void _confirmClear(){
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text('Really remove all goals?',
            style: TextStyle(fontSize:14),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: ()=> Navigator.of(context).pop(),
              child: Text('Cancel')),
              TextButton(
                onPressed: (){
                setState((){
                  widget.goalPagePresenter.clearGoals();
                });
                Navigator.of(context).pop();
                },
                  child: Text('Clear all')),
          ],

        );
        },
    );
  }

}
