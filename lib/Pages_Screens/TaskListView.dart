
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hazlo/Pages_Screens/NoteList2.dart';
import 'package:hazlo/Widget/TasksListWidget.dart';

class TaskListview extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return TaskListState();
  }


}

class TaskListState  extends State<TaskListview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Tasks"),
    leading: IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context,
            MaterialPageRoute(builder: (context) => NoteList2()));
      },
    ),
        ),
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                    top: 40, left: 30, right: 30, bottom: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[

                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "All Tasks",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
 // this where the task count should be??
                  ],
                ),
              ),

              // box decoration
              Expanded(
                  child: Container(
                      padding: EdgeInsets.only(left: 30),
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      height: MediaQuery
                          .of(context)
                          .size
                          .height * 0.55,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(25.0),
                              topRight: Radius.circular(25.0)),
                          color: Color(0xFF005792)
                      ),
                      child: Stack(
                          children: <Widget>[
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(padding: EdgeInsets.only(top: 30),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      child: Icon(
                                        Icons.assignment,
                                        color: Color(0xFF005792),
                                        size: 20,
                                      ),
                                      radius: 20,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    'Tasks', style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold
                                  ),
                                  ),

                                  //This is where the Tasks will be shown
                                  Container(
                                    padding: EdgeInsets.only(top: 20),
                                    child: Row(
                                      children: <Widget>[
                                        TasksListWidget()

                                      ],
                                    ),
                                  )
                                ]
                            )
                          ]
                      )))
            ]
        )
    );
  }
}


