import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_poroject/model/todo_model.dart';

class TodoApp extends StatefulWidget {
  const TodoApp({super.key});

  @override
  State<TodoApp> createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  List<Todo> _todos = [];
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _mobilenumbercontroller = TextEditingController();
  int _currentIndex = -1;

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Center(child: Text("Todo App",style:TextStyle(
          color: Colors.white,
          fontSize: 30,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic
        ) ,)),
      ),
      
      backgroundColor:Colors.red ,
      
      body: SingleChildScrollView( 
        
        // Use SingleChildScrollView
        child: Column(
        
          children: [
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _nameController,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  hintText: 'FirstName',
                  hintStyle: TextStyle(
                    color: Colors.black, // Change hint text color here
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    
                    borderRadius: BorderRadius.circular(12),
                    
                    
                  )
                ),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _descriptionController,
               
                decoration: InputDecoration(
                  hintText: 'Address',
                  hintStyle: TextStyle(
                    color: Colors.black, // Change hint text color here
                  ),
                   fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    
                    borderRadius: BorderRadius.circular(12),
                    
                  )
                ),
                minLines: 5,
                maxLines: 8,
              ),
            ),
              Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _mobilenumbercontroller,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: 'Mobile Number',
                  
                  hintStyle: TextStyle(
                    color: Colors.black, // Change hint text color here
                  ),
                   fillColor: Colors.white,
                  filled: true,
                  
                  border: OutlineInputBorder(
                    
                    borderRadius: BorderRadius.circular(12),
                    
                    
                  ),
                  
                ),
                minLines: 5,
                maxLines: 8,
              ),
            ),
            ElevatedButton(
              onPressed: _currentIndex == -1 ? _addTodo : _updateTodo,
               style: ElevatedButton.styleFrom(
    foregroundColor: Colors.black, backgroundColor: Colors.white, // Text color
  ),
              child: Text(_currentIndex == -1 ? "Add" : "Update"),
            ),
            SizedBox(height: 20),
            _todos.isEmpty
                ? Center(child: Text("No Data",style: TextStyle(color: Colors.white,fontStyle: FontStyle.italic),),
                
                )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(), // Disable scrolling for ListView
                    itemCount: _todos.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(_todos[index].name,style: TextStyle(color: Colors.white,fontStyle: FontStyle.italic),),
                        subtitle: Text(_todos[index].description,style: TextStyle(color: Colors.white,fontStyle: FontStyle.italic),),
                        
                        //subtitle: Text(_todos[index].description,style: TextStyle(color: Colors.white,fontStyle: FontStyle.italic),),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit,
                              color: Colors.white,),
                              onPressed: () {
                                setState(() {
                                  _currentIndex = index;
                                  _nameController.text = _todos[index].name;
                                  _descriptionController.text =
                                      _todos[index].description;
                                      _mobilenumbercontroller.text=_todos[index].mobile;
                                });
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete,
                              color: Colors.white,),
                              onPressed: () {
                                _deleteTodo(index);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }

  void _addTodo() {
    if (_nameController.text.isEmpty || _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Both title and description are required.")),
        
      );
      return;
    }
    final todo = Todo(
      name: _nameController.text,
      description: _descriptionController.text,
      mobile: _mobilenumbercontroller.text,
    );
    setState(() {
      _todos.add(todo);
      _saveTodos();
      _nameController.clear();
      _descriptionController.clear();
      _mobilenumbercontroller.clear();
    });
  }

  void _updateTodo() {
    if (_nameController.text.isEmpty || _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Both title and description are required.")),
      );
      return;
    }
    final todo = Todo(
      name: _nameController.text,
      description: _descriptionController.text,
      mobile: _mobilenumbercontroller.text,
    );
    setState(() {
      _todos[_currentIndex] = todo;
      _saveTodos();
      _nameController.clear();
      _descriptionController.clear();
       _mobilenumbercontroller.clear();
      _currentIndex = -1;
    });
  }

  void _deleteTodo(int index) {
    setState(() {
      _todos.removeAt(index);
      _saveTodos();
    });
  }

  void _loadTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final todos = prefs.getStringList('todos');
    if (todos != null) {
      setState(() {
        _todos = todos
            .map((todo) => Todo.fromJson(jsonDecode(todo))) 
            .toList();
      });
    }
  }

  void _saveTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final todos = _todos.map((todo) => jsonEncode(todo.toJson())).toList(); 
    prefs.setStringList('todos', todos);
  }
}
