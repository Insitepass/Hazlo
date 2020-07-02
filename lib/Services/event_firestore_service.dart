
import 'package:hazlo/Model/Event.dart';
import 'package:hazlo/Services/db_service.dart';


DatabaseService<EventModel> eventDBS = DatabaseService<EventModel>
  ("events",fromDS: (id,data) => EventModel.fromDS(id, data),toMap: (event) => event.toMap());