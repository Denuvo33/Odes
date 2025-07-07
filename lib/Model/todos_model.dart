class TodosModel {
  String? userId;
  int? id;
  String? title;
  bool? completed;
  String? dateCreated;
  String? alarmDate;

  TodosModel({
    this.userId,
    this.id,
    this.dateCreated,
    this.alarmDate,
    this.title,
    this.completed,
  });

  TodosModel fromMap(Map<String, dynamic> map) {
    return TodosModel(
      title: map['title'],
      completed: map['completed'],
      dateCreated: map['dateCreated'],
      alarmDate: map['alarmDate'] ?? '',
      id: map['id'],
    );
  }

  Map<String, dynamic> toMap(int id) {
    return {
      'title': title,
      'completed': completed ?? false,
      'dateCreated': dateCreated,
      'alarmDate': alarmDate ?? '',
      'id': id,
    };
  }
}
