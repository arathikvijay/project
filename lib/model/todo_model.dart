class Todo {
  final String name;
  final String description;
  final String mobile;

  Todo({required this.name, required this.description,required this.mobile});

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      name: json['name'],
      description: json['description'],
      mobile: json['mobile'],
    
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': name,
      'description': description,
      'nobile': mobile,
    };
  }
}