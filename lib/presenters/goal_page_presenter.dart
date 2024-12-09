import 'package:northstars_final/models/goal_page_model.dart';

class GoalPagePresenter {
  final GoalPageModel goalPageModel;
  final Function(List<GoalPageModel>) updateView;

  GoalPagePresenter(this.goalPageModel, this.updateView);

  // Initial load of ToDo items
  void loadTodos() {
    updateView(GoalPageModel.todoList());
  }

  // Handle ToDo item completion
  void handleToDoChange(GoalPageModel todo) {
    todo.isDone = !todo.isDone;
    updateView(GoalPageModel.todoList()); // Update the view with modified list
  }

  // Delete a ToDo item
  void deleteToDoItem(String id) {
    var todos = GoalPageModel.todoList();
    todos.removeWhere((item) => item.id == id);
    updateView(todos);
  }

  // Add a new ToDo item
  void addToDoItem(String todoText) {
    var todos = GoalPageModel.todoList();
    todos.add(GoalPageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      todoText: todoText,
    ));
    updateView(todos);
  }

  // Run filter based on the search query
  void runFilter(String enteredKeyword) {
    var todos = GoalPageModel.todoList();
    List<GoalPageModel> results = enteredKeyword.isEmpty
        ? todos
        : todos.where((item) => item.todoText!.toLowerCase().contains(enteredKeyword.toLowerCase())).toList();
    updateView(results);
  }
}
