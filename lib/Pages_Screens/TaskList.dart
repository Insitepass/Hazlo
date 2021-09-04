
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hazlo/Pages_Screens/NoteList2.dart';
import 'package:intl/intl.dart';

class TaskListview extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return TaskListState();
  }


}

class TaskListState  extends State<TaskListview> {

  final Firestore _db = Firestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String user;
  var taskStream;
  DateTime date;



  initUser() async {
    user = (await _firebaseAuth.currentUser()).uid;
    setState(() {});
  }


  @override
  void initState() {
    super.initState();
    taskStream = _db.collection('tasks')
        .where('userid', isEqualTo: user)
        .orderBy('date', descending: true)
        .snapshots();

    initUser();
  }


// this is to get amount of users.
Future _getCount() async => Firestore.instance.collection('tasks')
    .where('userid', isEqualTo: user)
    .getDocuments()
    .then((value) {
      var count = 0;
      count = value.documents.length;

      return count;
});

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
                    // This is the task count
                     FutureBuilder(
                       future: _getCount(),
                       builder: (context, snapshot) {
                         if(_getCount() == null) {
                           return Text('0');
                         }
                         else {
                           return ListTile(
                             title: Text("${snapshot.data.toString()}",style:TextStyle(
                                 fontSize: 28.0
                             )),
                           );
                         }

                       },
                     )
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
                                  Padding(padding: EdgeInsets.only(top: 20),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),

                                  //This is where the Tasks will be shown
                                  Container(
                                    // padding: EdgeInsets.only(top: 20),
                                    child: Row(
                                      children: <Widget>[
                                        //TasksListWidget()
                                        ShowTasks()
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


class ShowTasks  extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return ShowTasksState();
  }

}

class ShowTasksState extends State<ShowTasks> {



  DateTime chosenDate = DateTime.now();
  final Firestore _db = Firestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String user;
  var taskStream;
  DateTime date;



  initUser() async {
    user = (await _firebaseAuth.currentUser()).uid;
    setState(() {});
  }


  @override
  void initState() {
    super.initState();

  }


  @override
  void dispose() {
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return
      Expanded(
          child:
          StreamBuilder <QuerySnapshot>(
            stream: taskStream = _db.collection('tasks')
                .where('userid', isEqualTo: user)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot>snapshot) {
              if (snapshot.hasError) return Center(
                child: Text("Error : unable to return your tasks",
                    style: TextStyle(
                        color: Colors.white
                    )
                ),

              );
              if (!snapshot.hasData) return CircularProgressIndicator();
              //  Returning data
              if (snapshot.hasData) {
                // final List<DocumentSnapshot> documents = snapshot.data.documents;

                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                      final listItem = snapshot.data
                          .documents[index];
                      return CheckboxListTile(
                          title: Text(
                              listItem.data['taskName'], style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 20,
                            decoration: listItem.data['isChecked']
                                ? TextDecoration.lineThrough
                                : null,
                            decorationThickness: 3,
                          )),
                          subtitle: Text((date == null)
                              ? DateFormat.yMMMMEEEEd().format(DateTime.now())
                              : DateFormat.yMMMMEEEEd().format(date),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                          value: listItem.data['isChecked'],
                          onChanged: (bool val) async {
                            setState(() {
                              listItem.data['isChecked'] = val;
                              listItem.data.remove(val);
                            });
                            // delete document
                            await _db.collection('tasks').document(listItem
                                .documentID).delete();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('Task done!'),
                                backgroundColor: Colors.red,
                                duration: Duration(seconds: 1)
                            )
                            );
                          }

                      );

                  },


                );

              }
              return CircularProgressIndicator();
            }
    )

                );
              }

  }









