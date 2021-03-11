import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hazlo/Model/Task.dart';
import 'package:hazlo/Services/task_service.dart';


import 'TaskItem.dart';

class TasksListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return
      Expanded (
        child:
        StreamBuilder(
          stream: taskDBS.streamList(),
          builder: (BuildContext context,AsyncSnapshot<List<Task>>snapshot) {
            if(snapshot.hasError) return Center(
              child: Text ("Error : unable to return your tasks",
                  style: TextStyle(
                    color:Colors.white
                  )
              ),

            );
            if(! snapshot.hasData) return CircularProgressIndicator();
            return ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
              //  final listItem = snapshot.data[index];
                // put checkbox item here.
                return TaskItem(
                  // checkMark: listItem.isChecked,
                  // date: listItem.date,
                  // task: listItem.taskName,
                  // idxToDelete: index,
                  //  toggleCheckMark: (bool currValue) {
                  //     toggleCheckMark(index);
                  //  },
                );
              },
            );
          },
        )
      );
  }




}
