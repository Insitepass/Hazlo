
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:custom_switch/custom_switch.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hazlo/Model/Event.dart';
import 'package:hazlo/Model/Note.dart';
import 'package:hazlo/Services/db_service.dart';
import 'package:hazlo/Services/event_firestore_service.dart';
import 'package:hazlo/Services/local_Notification_Service.dart';



class AddNote extends StatefulWidget {
  final Note note;
  final EventModel event;
  final localNotificationService notificationService;

  const AddNote({Key key, this.note, this.event, this.notificationService}) : super(key: key);

  @override
  State<StatefulWidget> createState() {

    return AddNoteState();
  }
}

class AddNoteState extends State<AddNote> {

  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
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

  localNotificationService serivce = localNotificationService();

  get flutterNotification => localNotificationService;

  @override
  void initState() {
    super.initState();
    _editMode = widget.note != null;
    _titleController =
        TextEditingController(text: _editMode ? widget.note.title : null);
    _descriptionController =
        TextEditingController(text: _editMode ? widget.note.description : null);
    _descriptionNode = FocusNode();
    _eventDate = DateTime.now();
    time = TimeOfDay.now();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // ignore: missing_return
        onWillPop: () {
          Navigator.of(context).pop('NoteList');
        },
        child: Scaffold(
            key: _key,
            appBar: AppBar(
              title: Text('Add Note'),
              leading: IconButton(icon: Icon(
                  Icons.arrow_back),
                  onPressed: () {
                    Navigator.of(context).pop('NoteList');
                  }
              ),
              backgroundColor: Color(0xFF005792),
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
                                labelText: 'Title',
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
                          maxLines: 3,
                          controller: _descriptionController,
                          focusNode: _descriptionNode,
                          onChanged: (value) {
                            debugPrint(
                                'Something changed in Description Text field');
                          },
                          decoration: InputDecoration(
                              labelText: 'Description',
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

                      // Third Separation Container

                      Container(
                        padding: EdgeInsets.all(10),
                      ),


                      // Fourth Element Toggle on and off Switch
                      // toggle switch with date picker
                      Column(

                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[

                            Text('$textHolder', style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),),
                            SizedBox(height: 10.0),
                            Container(
                              padding: EdgeInsets.all(10),
                              child: CustomSwitch(
                                value: switchControl,
                                onChanged: toggleSwitch,
                                activeColor: Colors.blue,
                              ),
                            ),

                            Visibility(
                                visible: showCard,
                                child: DateTimePicker(_eventDate)

                            ),

                            SizedBox(height: 12.0,),


                            // Fifth Element Save Button
                            Container(
                              padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: RaisedButton(
                                        color: Color(0xFF005792),
                                        textColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: new BorderRadius
                                                .circular(30.0)),
                                        child: Text(
                                          'Save',
                                          textScaleFactor: 1.5,
                                        ),
                                        onPressed: () async {
                                          if (_titleController.text.isEmpty) {
                                            _key.currentState.showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      "Title is required."),
                                                ));
                                            return;
                                          }
                                          // Switch case statement for adding note or event.
                                          switch (switchControl == false) {
                                            case false:
                                            // Adding Events to Calendar
                                            //TODO find a way to make sure that date picked on date picker is entered.
                                              final FirebaseUser user = await auth
                                                  .currentUser();
                                              final userid = user.uid;
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
                                                        id: userid,
                                                        title: _titleController
                                                            .text,
                                                        description: _descriptionController
                                                            .text,
                                                        eventDate: _eventDate
                                                    ));

                                                //show notification
                                                _showNotification(
                                                    widget.notificationService);

                                                _key.currentState.showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                          "Event Added "),
                                                    ));
                                              }
                                              debugPrint('the switch in on');
                                              break;
                                            case true:
                                            // adding notes to the firebase collection
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
                                                    "Save button clicked");
                                              });
                                              debugPrint('switch is off');
                                              break;
                                            default:
                                              debugPrint(
                                                  'its off currently off');
                                          }
                                        }),
                                  ),

                                  // Sixth element delete button
                                  Container(width: 5.0,),
                                  Expanded(
                                    child: RaisedButton(
                                      color: Color(0xFF005792),
                                      textColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: new BorderRadius
                                              .circular(30.0)),
                                      child: Text(
                                        'Delete',
                                        textScaleFactor: 1.5,
                                      ),
                                      onPressed: () {
                                        _titleController.clear();
                                        _descriptionController.clear();
                                        setState(() {
                                          debugPrint("Delete button clicked");
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            )

                          ]

                      )
                    ]
                )
            )
        )
    );
  }
void _showNotification(localNotificationService showNotificationDaily ) async{
  showTimePicker(
    initialTime: TimeOfDay.now(),
    context: context,
  ).then((selectedTime) async {
    int hour = selectedTime.hour;
    int minute = selectedTime.minute;
    print(selectedTime);
    serivce.showNotificationDaily( 0,_titleController.text, _descriptionController.text, hour, minute);
print('new event'+ _eventDate.toString());
    FocusScope.of(context).requestFocus(
        FocusNode());
    Navigator.pop(context);
});



  }




  // toggele Switch function.
  void toggleSwitch(bool value)  {
    if (switchControl == false) {
      setState(() {
        switchControl = true;
      });
      // card will be displayed if the Switch is on.
      setState(() {
        showCard = !showCard;
      });
    }
    else {
      setState(() {
        switchControl = false;
        textHolder = 'Add to Calendar';

      });
      // card will not be displayed if the Switch is off.
      setState(() {
        showCard = !showCard;
      });
    }
  }

  void setReminderAction({String time, String name, RepeatInterval repeat}) {}
}


// Date Time Picker class
class DateTimePicker extends StatefulWidget {

  DateTimePicker(DateTime eventDate);


  @override
  DateTimePickerState createState() => new DateTimePickerState();
}
class DateTimePickerState extends State<DateTimePicker> {
  DateTime _eventDate;
  TimeOfDay time;

  @override
  void initState() {
    super.initState();
    _eventDate = DateTime.now();
    time = TimeOfDay.now();
  }
 // TODO fix notifiation called on null error
  //TODO fix overflowing pixels error
  @override
  Widget build(BuildContext context) {
    return
      SingleChildScrollView(
          child:Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Divider(color: Color(0xFF005792), thickness: 1,),
                ListTile(
                  title: Text("Date:"),
                  subtitle: Text(
                    "${_eventDate.day}/${_eventDate.month}/${_eventDate
                        .year}"),
                  //trailing: Icon(
                      //Icons.keyboard_arrow_down, color: Color(0xFF005792)),
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
                ListTile(
                  title:Text("Time:"),
                  subtitle: Text(" ${time.hour}:${time.minute}"),
                  trailing: Icon(Icons.keyboard_arrow_down,color: Color(0xFF005792)),
                  onTap:() async {
                    TimeOfDay  T = await showTimePicker(
                        context: context, initialTime: time
                    );
                    if(
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






