import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


// checkbx item must delete when checked
class TaskItem extends StatelessWidget {
  final bool checkMark;
  final String task;
  final DateTime date;
  final Function toggleCheckMark;
  final int idxToDelete;


  TaskItem({
    this.checkMark,
    this.task,
    this.date,
    this.toggleCheckMark,
    this.idxToDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      background: Container(
        color: Colors.red,
      ),
      key: Key(task + task),
      onDismissed: (direction) {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text("Task removed"),
          backgroundColor: Colors.red,
        ));
      },
      child: ListTile(
        title: Text(
          task,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            decorationColor: Color(0xFF005792),
            decoration: checkMark ? TextDecoration.lineThrough : null,
            decorationThickness: 3,
            fontSize: 20,
          ),
        ),
        subtitle: Text(
          (date == null)
              ? DateFormat.yMMMMEEEEd().format(DateTime.now())
              : DateFormat.yMMMMEEEEd().format(date),
          style: TextStyle(
            fontSize: 15,
          ),
        ),
        trailing: Checkbox(
          value: checkMark,
          activeColor: Colors.green,
          onChanged: toggleCheckMark,
        ),
      ),
    );
  }
}
