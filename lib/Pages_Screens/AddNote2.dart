
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hazlo/Model/Event.dart';
import 'package:hazlo/Model/Note.dart';
import 'package:hazlo/Model/Task.dart';
import 'package:hazlo/Pages_Screens/TaskListView.dart';
import 'package:hazlo/Services/db_service.dart';
import 'package:hazlo/Services/event_firestore_service.dart';
import 'package:hazlo/Services/local_Notification_Service.dart';
import 'package:hazlo/Services/task_service.dart';
import 'package:intl/intl.dart';
import 'Calendar.dart';



class AddNote2 extends StatefulWidget {
  final Note note;
  final EventModel event;
  final Task task;

  //final Function onSaved;

  const AddNote2({Key key, this.note, this.event, this.task}) : super(key: key);

  @override
  State<StatefulWidget> createState() {

    return AddNote2State();
  }

}




class AddNote2State extends State<AddNote2> {
  String taskName;
  DateTime chosenDate = DateTime.now();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _taskNameController = TextEditingController();
  final GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
  FocusNode _descriptionNode;
  bool _editMode;
  bool switchControl = false;
  var textHolder = 'Add to Calendar';
  bool pressing = false;
  bool showCard = false;
  DateTime _eventDate;
  TimeOfDay time;



  get auth => FirebaseAuth.instance;



 get eventDate => DatePicker(eventDate);

  @override
  void initState() {
    super.initState();
    _editMode = widget.note != null;
    _titleController =
        TextEditingController(text: _editMode ? widget.note.title : null);
    _descriptionController =
        TextEditingController(text: _editMode ? widget.note.description : null);

    _taskNameController = TextEditingController(text:_editMode ? widget.task.taskName:null);

    _descriptionNode = FocusNode();
   _eventDate = DateTime.now();

    time = TimeOfDay.now();
  }



  @override
  Widget build(BuildContext context) {
    return
      Scaffold(

        // bottom actions
          bottomNavigationBar:
          // bottom app bar
          BottomAppBar(
             // color:Color(0xFF005792),

              child:Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:[
                    // Add Task
                    IconButton(
                      iconSize: 27.0,
                      color:Color(0xFF005792),
                      icon:Icon(Icons.assignment),
                      onPressed: () {
                        showDialog(
                          context:context,
                          builder:(BuildContext context) {
                            return AlertDialog(
                              scrollable: true,
                              title:Text('Add New Task',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                fontSize: 25,

                                fontWeight: FontWeight.w500,
                                      color:Color(0xFF005792)
                              )),
                              content: Row(
                                children: <Widget>[
                                  Flexible(
                                      child: Card(
                                        child: Column(
                              children: <Widget> [
                              TextField(
                              controller:_taskNameController,
                                onChanged:(value) =>
                                    (_taskNameController.text),

                              ),
                              SizedBox(
                                height:15,
                              ),
                                          Row(
                                            children: <Widget> [
                                              Icon(
                                                Icons.event,
                                                color: Color(0xFF005792),
                                              ),
                                              SizedBox(
                                                height: 5.0,
                                              ),
                                              Expanded(
                                                 child: Text(
                                                DateFormat.yMMMMEEEEd().format(chosenDate),
                                                style: TextStyle(
                                                  fontSize: 18,
                                                ),
                                              ),
                                              )
                                            ],
                                          ),
                                        SizedBox(
                                         height: 20,
                                          ),
                                          RaisedButton(
                                            color: Color(0xFF005792),
                                            shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                                            child: Text(
                                              "Add Task!",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 17,
                                              ),
                                            ),
                                            onPressed: () async {

                                              /* un//focus */
                                             // FocusScope.of(context).unfocus();
                                              // add task function here
                                              final FirebaseUser user = await auth.currentUser();
                                              final userid = user.uid;
                                              if(widget.task !=null) {
                                                await  taskDBS.updateItem(
                                                  Task(
                                                      id: userid,
                                                    taskName: _taskNameController.text,
                                                    date:chosenDate
                                                  )
                                                );
                                              }
                                              else {
                                                await taskDBS.createItem(
                                                    Task(
                                                        userId:userid,
                                                        taskName: _taskNameController.text,
                                                        date: chosenDate
                                                    ));
                                                Navigator.push(context, new MaterialPageRoute(
                                                    builder: (context) => new TaskListview()));
                                                 _taskNameController.clear();
                                                setState(() {
                                                  debugPrint(
                                                      'add task button pressed');
                                                });
                                              }

                                            },
                                          )
                                        ]
                                        )
                                      )
                                  )
                                ]
                              )
                              );


                      }
                        );


                      },

                    ),
                    // clear form
                    IconButton(
                      iconSize: 27.0,
                      color:Color(0xFF005792),
                      icon:Icon(Icons.clear),
                      onPressed: () {
                        _titleController.clear();
                        _descriptionController.clear();
                        setState(() {
                          debugPrint(
                              'clear button clicked');
                        });
                      },

                    ),
                  ]
              )
          ),


          // add note button
          floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
          floatingActionButton: new FloatingActionButton(
              child:new Icon(Icons.done),
              onPressed: () async{
                if (_titleController.text.isEmpty) {
                  _key.currentState.showSnackBar(
                      SnackBar(
                        content: Text(
                            "Title is required."),
                      ));
                  return;
                }
                final FirebaseUser user = await auth
                    .currentUser();
                final userid = user.uid;
                Note note = Note(
                    id: _editMode
                        ? widget.note.id
                        : null,
                    title: _titleController.text,
                    description: _descriptionController
                        .text,
                    createdAt: DateTime.now(),
                    userId: userid
                );
                _key.currentState.showSnackBar(
                    SnackBar(
                        content: Text(
                            "Note saved successfully")
                    ));

                // edit not functionality
                if (_editMode) {
                  await notesDb.updateItem(note);
                } else {
                  await notesDb.createItem(note);
                }
                _key.currentState.showSnackBar(
                    SnackBar(
                        content: Text(
                            "Note  Edited  successfully")
                    ));
                FocusScope.of(context)
                    .requestFocus(
                    FocusNode());
                Navigator.pop(context);
                _titleController.clear();
                _descriptionController.clear();
                setState(() {
                  debugPrint(
                      'Save button clicked');
                });
              },
              heroTag: null,
              backgroundColor: Color(0xFF005792)

          ),
          key: _key,
          appBar: AppBar(
              title: Text('Add Note'),
              actions:<Widget>[
                // add reminder/Events
                IconButton(
                  iconSize: 27.0,
                  color:Colors.white,
                  icon:Icon(Icons.add_alert_outlined),
                  onPressed: () {
                    showDialog(
                        context:context,
                        builder:(BuildContext context) {
                          return AlertDialog (
                              scrollable: true,
                              title: Text('Set Reminder'),
                              content: Padding (
                                padding: const EdgeInsets.all(8.0),
                                child: Form(
                                  child:Column(
                                    children: <Widget> [
                                      // Datepicker
                                      DatePicker(_eventDate),
                                      //timepicker
                                      TimePicker(_eventDate)

                                    ],
                                  ),
                                ),
                              ),
                              actions: [
                                FlatButton(
                                  child: Text("cancel"),
                                  onPressed: () {
                                    Navigator.pop(context,false);
                                  },
                                ),
                                RaisedButton(
                                  child: Text("Set"),
                                  color:Color(0xFF005792),
                                  shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                                  onPressed: () async {
                                    final FirebaseUser user = await auth
                                        .currentUser();
                                    final userid = user.uid;
                                    if (_titleController.text.isEmpty) {
                                      _key.currentState.showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                "Title is required."),
                                          ));
                                      return;
                                    }
                                    if (widget.event != null) {
                                      await eventDBS.updateItem(
                                          EventModel(
                                              id: userid,
                                              title: _titleController
                                                  .text,
                                              description: _descriptionController
                                                  .text,
                                              eventDate: widget.event
                                                  .eventDate
                                          ));
                                    } else {
                                      await eventDBS.createItem(
                                          EventModel(
                                              userId: userid,
                                              title: _titleController
                                                  .text,
                                              description: _descriptionController
                                                  .text,
                                              eventDate: _eventDate
                                          ));

                                      _key.currentState.showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                "Event Added "),
                                          ));
                                      Navigator.push(context, new MaterialPageRoute(
                                          builder: (context) => new Calendar()));

                                      //set notifications
                                      scheduleReminder();
                                    }
                                  },
                                ),
                              ]
                          );
                        }
                    );

                    debugPrint(
                        'add reminder button clicked');
                  },
                ),

            //backgroundColor: Color(0xFF005792),
            ]
          ),
          body: Padding(
            padding: EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[

                // First Element: Note title input box
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                      controller: _titleController,
                      onChanged: (value) {
                        debugPrint(
                            'Something changed in Title Text field');
                      },
                      decoration: InputDecoration(
                          hintText: 'Title',
                          labelStyle: Theme
                              .of(context)
                              .textTheme
                              .headline5,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: const BorderSide(
                                color: Color(0xFF005792)),
                          )
                      )
                  ),
                ),


                // Second Element Description Text box
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: TextField(
                    maxLines: 15,
                    controller: _descriptionController,
                    focusNode: _descriptionNode,
                    onChanged: (value) {
                      debugPrint(
                          'Something changed in Description Text field');
                    },
                    decoration: InputDecoration(
                        hintText: 'Description',
                        labelStyle: Theme
                            .of(context)
                            .textTheme
                            .headline5,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: const BorderSide(
                              color: Color(0xFF005792)),
                        )
                    ),

                  ),

                ),
              ],
            ),
          )
      );
  }


  // local notification schedular
void scheduleReminder() async {
    var scheduledNotificationDateTime = _eventDate;

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'Hazlo',
        'Events',
      "Up coming event",
      icon: 'icon_logo_hazlo',
      sound: RawResourceAndroidNotificationSound('hazlo_just_saying'),
      largeIcon: DrawableResourceAndroidBitmap('icon_logo_hazlo'),
    );

    var iOSPlatformChannelSpecifics = IOSNotificationDetails(
      sound:'hazlo_just_saying.wav',
      presentAlert: true,
      presentBadge: true,
      presentSound: true);
      var  platformChannelSpecifics = NotificationDetails (
        androidPlatformChannelSpecifics,iOSPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.schedule(
        0,
        'Hazlo',
        "Up coming event",
        scheduledNotificationDateTime,
        platformChannelSpecifics);

}

  }


//datepicker class
class DatePicker extends StatefulWidget {

  DatePicker(DateTime eventDate);


  @override
  DatePickerState createState() => new DatePickerState();
}
class DatePickerState extends State<DatePicker> {
  DateTime _eventDate;
  TimeOfDay time;
 
  @override
  void initState() {
    super.initState();
    _eventDate = DateTime.now();
    time = TimeOfDay.now();
  }
  @override
  Widget build(BuildContext context) {
    return
      SingleChildScrollView(
          child:Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // Divider(color: Color(0xFF005792), thickness: 1,),
                ListTile(
                  title: Text("Date:"),
                  subtitle: Text(
                      "${_eventDate.day}/${_eventDate.month}/${_eventDate
                          .year}"),
                  trailing: Icon(
                      Icons.keyboard_arrow_down, color: Color(0xFF005792)),
                  onTap: () async {
                    DateTime picked = await showDatePicker(
                        context: context, initialDate: _eventDate,
                        firstDate: DateTime(_eventDate.year - 5),
                        lastDate: DateTime(_eventDate.year + 5));
                    if (picked != null) {
                      setState(() {
                        _eventDate = picked;
                      });
                    }
                  },
                ),
                Divider(color: Color(0xFF005792), thickness: 1,),
              ]
          )
      );
  }
}

//time picker class
class TimePicker extends StatefulWidget {

  TimePicker(DateTime eventDate);


  @override
  TimePickerState createState() => new TimePickerState();
}
class TimePickerState extends State<TimePicker> {
  //DateTime _eventDate;
  TimeOfDay time;

  @override
  void initState() {
    super.initState();
    //  _eventDate = DateTime.now();
    time = TimeOfDay.now();
  }

  @override
  Widget build(BuildContext context) {
    return
      SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                //  Divider(color: Color(0xFF005792), thickness: 1,),
                ListTile(
                    title: Text("Time:"),
                    subtitle: Text(" ${time.hour}:${time.minute}"),
                    trailing: Icon(
                        Icons.keyboard_arrow_down, color: Color(0xFF005792)),
                    onTap: () async {
                      TimeOfDay T = await showTimePicker(
                          context: context, initialTime: time
                      );
                      if (
                      T != null
                      )
                        setState(() {
                          time = T;
                        });
                    }
                ),
                Divider(color: Color(0xFF005792), thickness: 1,),

              ]
          )

      );
  }
}

