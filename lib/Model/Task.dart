import 'database_item.dart';

class Task extends DatabaseItem{

  final String id;
  final String taskName;
  final  DateTime date;
  final String userId;
  bool isChecked;

  Task({this.id, this.taskName,this.date, this.isChecked,this.userId}) : super(id);

  void toggleIsChecked() {
    isChecked = !isChecked;
  }

  Task.fromDS(String id,Map<String, dynamic> data):
      id =id,
      taskName = data['taskName'],
      date=data['date']?.toDate(),
      userId = data['userId'],
      super(id);


  Map<String, dynamic> toMap() =>
      {
        "taskName": taskName,
        "date": date,
        "userId": userId,
      };



}
