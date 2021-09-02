import 'database_item.dart';

class Task extends DatabaseItem{

  final String id;
  final String taskName;
  final  DateTime date;
  final String userid;
  bool isChecked;

  Task({this.id, this.taskName,this.date, this.isChecked,this.userid}) : super(id);

  void toggleIsChecked(int index) {
    isChecked = !isChecked;
  }

  Task.fromDS(String id,Map<String, dynamic> data):
      id =id,
      taskName = data['taskName'],
      isChecked = false,
      date= DateTime.fromMicrosecondsSinceEpoch(data['date']),
      userid = data['userid'],
      super(id);


  Map<String, dynamic> toMap() =>
      {
        "taskName": taskName,
        "isChecked" :false,
        "date": date,
        "userid": userid,
      };



}
