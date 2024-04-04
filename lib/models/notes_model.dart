class NotesModel {
  final int id;
  final String title;
  final String description;
  final String email;

  NotesModel(
      {required this.id,
      required this.title,
      required this.description,
      required this.email});

  NotesModel.fromMap(Map<String, dynamic> items)
      : id = items['id'],
        title = items['title'],
        description = items['description'],
        email = items['email'];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'email': email,
    };
  }
}
