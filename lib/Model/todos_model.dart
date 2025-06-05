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
}
