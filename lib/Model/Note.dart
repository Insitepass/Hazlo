
import 'package:hazlo/Model/database_item.dart';

class Note extends DatabaseItem {
  final String title;
  final String id;
  final String description;
  final DateTime createdAt;
  final String userId;


  Note({this.title, this.id, this.description, this.createdAt, this.userId})
      :super(id);

  Note.fromDS(String id, Map<String, dynamic> data)
      :
        id=id,
        title=data['title'],
        description=data['description'],
        userId=data['Userid'],
        createdAt=data['createdat']?.toDate(),
        super(id);




  Map<String, dynamic> toMap() =>
      {
        "title": title,
        "description": description,
        "created_at": createdAt,
        "userid": userId,
      };


}
