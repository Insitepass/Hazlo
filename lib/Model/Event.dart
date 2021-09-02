
import 'database_item.dart';

class EventModel extends DatabaseItem{
  final String id;
  final String title;
  final String description;
  final DateTime eventDate;
  final String userId;

  EventModel({this.id,this.title, this.description, this.eventDate,this.userId}):super(id);

  factory EventModel.fromMap(Map data) {
    return EventModel(
      title: data['title'],
      description: data['description'],
      eventDate: DateTime.fromMicrosecondsSinceEpoch(data['eventdate']),
      userId:data['Userid'],
    );
  }
  factory EventModel.fromDS(String id, Map<String,dynamic> data) {
    return EventModel(
      title: data['title'],
      description: data['description'],
      eventDate: DateTime.fromMicrosecondsSinceEpoch(data['eventdate']),
      userId:data['Userid'],
    );
  }
  
  
  Map<String,dynamic> toMap() => {
      "title":title,
      "description": description,
      "eventdate":eventDate,
      "userid":userId,
    };
}
