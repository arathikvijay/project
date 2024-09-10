import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_poroject/model/todo_model.dart';


class TodoController {
  List<Todo> _todos = [];

  // Get all todos
  List<Todo> get todos => _todos;

  // Add a new todo
  Future<void> addTodo(String fname, String description,String mobilenum) async {
    final todo = Todo(name: fname, description: description,mobile: mobilenum);
    _todos.add(todo);
    await _saveTodos();
  }

  // Update a todo
  Future<void> updateTodo(int index, String fname, String description,String mobilenum) async {
    final todo = Todo(name: fname, description: description,mobile: mobilenum);
    _todos[index] = todo;
    await _saveTodos();
  }

  // Delete a todo
  Future<void> deleteTodo(int index) async {
    _todos.removeAt(index);
    await _saveTodos();
  }

  // Load todos from SharedPreferences
  Future<void> loadTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final todos = prefs.getStringList('todos');
    if (todos != null) {
      _todos = todos.map((todo) => Todo.fromJson(jsonDecode(todo))).toList();
    }
  }

  // Save todos to SharedPreferences
  Future<void> _saveTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final todos = _todos.map((todo) => jsonEncode(todo.toJson())).toList();
    prefs.setStringList('todos', todos);
  }
}