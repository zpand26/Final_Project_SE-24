import 'package:flutter/cupertino.dart';
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
      backgroundColor: Colors.blueGrey,
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              children:
              generateGoalList(),
            ),
          ),
          generateAddGoalForm(),
          generateClearAllButton(),
          generateClearDoneButton(),
          //generateGoalDurationMenu(),
      ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.deepPurpleAccent,
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
        color: Colors.white70,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: ListTile(
            title: Text(goal.description,
            style:
          TextStyle(
            fontSize: 14,
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
        Padding(padding: EdgeInsets.all(3),
          child: TextField(decoration: InputDecoration(filled: true, fillColor: Colors.lightBlueAccent), controller: _goalController)),
        Container(
          color: Colors.indigo,
          alignment: Alignment.bottomCenter,
         height: 50,
          margin: const EdgeInsets.all(10),
            child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
          shape: ContinuousRectangleBorder()),
          label: Text('Add Goal'),
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
        ),
      ],
    );
  }

  /*Row generateGoalDurationButton(){
    return Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      DropdownButton<String>(
        value: goalDuration,
    items: ["All", "Remote", "Hybrid"]
        .map((location) =>
    DropdownMenuItem(
    value: location,
    child: Text(location),
    ))
        .toList(),
    onChanged: (value) {
    if (value != null) {
    setState(() {
    selectedLocationFilter = value;
    });
    applyFilters();
    }
    },
    ),
    ],
    );
  }*/

  /*void generateDurationButton(){
    ListView(
      children: CupertinoSegmentedControl<int>(
      padding: EdgeInsets.all(10),
      children: [
        0: Text('Long-term'),
        1: Text('Short-term'),
      ]
      onValueChanged: (groupValue){
        print(groupvalue)
    },
  )
  }*/

  Container generateClearAllButton(){
    return Container(
      color: Colors.indigo,
        alignment: Alignment.bottomCenter,
        height: 50,
        margin: const EdgeInsets.all(3),
    child: ElevatedButton.icon(
    style: ElevatedButton.styleFrom(
    shape: ContinuousRectangleBorder()),
    label: Text ('Remove all'),
     onPressed: (){
      _confirmClear();
      }
      ),
    );
  }

  Container generateClearDoneButton(){
    return Container(
      color: Colors.indigo,
      alignment: Alignment.bottomCenter,
      height: 50,
      margin: const EdgeInsets.all(3),
    child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
            shape: ContinuousRectangleBorder()),
        label: Text ('Remove completed goals'),
        onPressed: (){
          setState(() {
            widget.goalPagePresenter.deleteDoneGoals();
          });
        }
        ),
    );
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
