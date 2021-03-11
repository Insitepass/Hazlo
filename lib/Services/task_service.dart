import 'package:hazlo/Model/Task.dart';
import 'package:hazlo/Services/db_service.dart';

DatabaseService<Task> taskDBS = DatabaseService<Task>
  ("tasks",fromDS:(id,data) => Task.fromDS(id,data),toMap:(task) => task.toMap());
