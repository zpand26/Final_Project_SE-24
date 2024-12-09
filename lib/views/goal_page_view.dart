import 'package:flutter/material.dart';
import 'package:northstars_final/presenters/goal_page_presenter.dart';
import 'package:northstars_final/models/goal_page_model.dart';
import 'package:northstars_final/models/ToDoItem.dart';

class GoalPageView extends StatefulWidget {
  final GoalPagePresenter goalPagePresenter;

  const GoalPageView(this.goalPagePresenter, {super.key});

  @override
  _goalPageViewState createState() => _goalPageViewState();
}

class _goalPageViewState extends State<GoalPageView> {
  List<GoalPageModel> _foundToDo = [];
  final _todoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.goalPagePresenter.loadTodos();
  }

  void updateView(List<GoalPageModel> todos) {
    setState(() {
      _foundToDo = todos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              children: [
                searchBox(),
                Expanded(
                  child: ListView(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 50, bottom: 20),
                        child: Text(
                          'All ToDos',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      for (GoalPageModel toDo in _foundToDo.reversed)
                        ToDoItem(
                          todo: toDo,
                          onToDoChanged: (todo) => widget.goalPagePresenter.handleToDoChange(todo),
                          onDeleteItem: (id) => widget.goalPagePresenter.deleteToDoItem(id),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 20, right: 20, left: 20),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 0.0),
                          blurRadius: 10.0,
                          spreadRadius: 0.0,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: _todoController,
                      decoration: InputDecoration(
                        hintText: 'Add a new todo item',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 20, right: 20),
                  child: ElevatedButton(
                    child: Text(
                      '+',
                      style: TextStyle(
                        fontSize: 40,
                      ),
                    ),
                    onPressed: () {
                      widget.goalPagePresenter.addToDoItem(_todoController.text);
                      _todoController.clear();
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(60, 60),
                      elevation: 10,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget searchBox() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        onChanged: (value) => widget.goalPagePresenter.runFilter(value),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.black,
            size: 20,
          ),
          prefixIconConstraints: BoxConstraints(
            maxHeight: 20,
            minWidth: 25,
          ),
          border: InputBorder.none,
          hintText: 'Search',
          hintStyle: TextStyle(color: Colors.grey),
        ),
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
}
