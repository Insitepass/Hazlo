
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:custom_switch/custom_switch.dart';
import 'package:hazlo/Model/Event.dart';
import 'package:hazlo/Model/Note.dart';
import 'package:hazlo/Services/db_service.dart';
import 'package:hazlo/Services/event_firestore_service.dart';


class AddNote extends StatefulWidget {
  final Note note;
  final EventModel event;

  const AddNote({Key key, this.note, this.event}) : super(key: key);

  @override
  State<StatefulWidget> createState() {

    return AddNoteState();
  }
}

class AddNoteState extends State<AddNote> {

  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  final GlobalKey<ScaffoldState> _key =  new GlobalKey<ScaffoldState>();
  FocusNode _descriptionNode;
  bool _editMode;

  get auth => FirebaseAuth.instance;

  get _eventDate => DateTimePicker();
  

  @override
  void initState()
  {
    super.initState();
     _editMode = widget.note != null;
    _titleController = TextEditingController(text: _editMode? widget.note.title:null);
    _descriptionController = TextEditingController(text: _editMode? widget.note.description:null);
    _descriptionNode = FocusNode();

  }
  @override
  Widget build(BuildContext context) {


    return WillPopScope(
      // ignore: missing_return
        onWillPop: () {
          Navigator.of(context).pop('NoteList');
        },
        child: Scaffold(
          key : _key,
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

          body:Padding(
                padding: EdgeInsets.all(10),
                   child:ListView(
                      children: <Widget>[

           // First Element: Note title input box
                        Container(
                          padding : EdgeInsets.all(10),
                          child: TextField(
                              controller: _titleController,
                              onChanged: (value) {
                                debugPrint('Something changed in Title Text field');
                              },
                              decoration: InputDecoration(
                                  labelText: 'Title',
                                  labelStyle: Theme.of(context).textTheme.headline5,
                                  border:OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: const BorderSide(color:Color(0xFF005792)),
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
                             debugPrint('Something changed in Description Text field');
                           },
                      decoration: InputDecoration(
                           labelText: 'Description',
                      labelStyle: Theme.of(context).textTheme.headline5,
                      border:OutlineInputBorder(
                     borderRadius: BorderRadius.circular(5.0),
                      borderSide: const BorderSide(color:Color(0xFF005792)),
                      )
                         ),

                         ),
                      ),


                         // Third Element Toggle on and off Switch
                        // toggle switch with date picker
                       Container(
                         padding : EdgeInsets.all(10),
                         child : SwitchWidget(),
                       ),

                         // Fourth Element Save Button
                             Container(
                              padding: EdgeInsets.only(top:10.0,bottom: 10.0),
                              child:Row(
                              children: <Widget>[
                               Expanded(
                               child: RaisedButton(
                               color:Color(0xFF005792),
                                 textColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                                 child: Text(
                                'Save',
                                textScaleFactor: 1.5,
                                 ),
                                onPressed: () async{

                                 if(_titleController.text.isEmpty){
                                   _key.currentState.showSnackBar(SnackBar(
                                     content:Text("Title is required."),
                                   ));
                                   return;
                                 }
                                 // adding notes to the firebase collection
                                 final FirebaseUser user = await auth.currentUser();
                                 final userid = user.uid;
                                   Note note = Note(
                                       id: _editMode ? widget.note.id : null,
                                       title: _titleController.text,
                                       description: _descriptionController.text,
                                       createdAt: DateTime.now(),
                                       userId: userid
                                   );


                                   // edit not functionality
                                   if (_editMode) {
                                     await notesDb.updateItem(note);
                                   } else {
                                     await notesDb.createItem(note);
                                   }
                                _key.currentState.showSnackBar(SnackBar(
                                  content:Text("Note saved successfully")
                                ));
                                   // Adding Events to Calendar
                                 if(widget.note != null) {
                                   await eventDBS.updateData(widget.note.id,{
                                     "title":  _titleController.text,
                                     "description":  _descriptionController.text,
                                     "event_date": _eventDate
                                   });
                                 }else{
                                   await eventDBS.createItem(EventModel(
                                       title:  _titleController.text,
                                       description:  _descriptionController.text,
                                       eventDate: DateTime.now()
                                   ));
                                 }
                                FocusScope.of(context).requestFocus(FocusNode());
                                Navigator.pop(context);
                                _titleController.clear();
                                _descriptionController.clear();
                                setState(() {
                                debugPrint("Save button clicked");
                                 });
                                 },

                                 ),
                                   ),

                                 // Fifth element delete button
                                Container(width: 5.0,),
                                Expanded(
                               child: RaisedButton(
                               color:Color(0xFF005792),
                                 textColor: Colors.white,
                                 shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
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
                  )
                  )
                 );
  }

  inputData(note(userId)) async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String uid = user.uid.toString();
    return uid;
  }

}



// Toggle Switch class
class SwitchWidget extends StatefulWidget {
  @override
  SwitchWidgetClass createState() => new SwitchWidgetClass();
}
class SwitchWidgetClass extends State {

  bool switchControl = false;
  var textHolder = 'Add to Calendar';
  bool pressing = false;
  bool showCard = false;

  void toggleSwitch(bool value) {
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


  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,

        children: <Widget>[
          Text('$textHolder', style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
          Container(

            padding : EdgeInsets.all(10),
            child:CustomSwitch(
              onChanged: toggleSwitch,
              value: switchControl,
              activeColor: Colors.blue,

            ),

          ),
          Visibility(
              visible : showCard,
              child : DateTimePicker()


          ),
          SizedBox(height: 12.0,),


        ]);
  }
  
}
// Date Time Picker class
class DateTimePicker extends StatefulWidget {
  @override
  DateTimePickerState createState() => new DateTimePickerState();
}
class DateTimePickerState extends State<DateTimePicker> {
  DateTime pickedDate;
  TimeOfDay time;

  @override
  void initState() {
    super.initState();
    pickedDate = DateTime.now();
    time = TimeOfDay.now();
  }

  @override
  Widget build(BuildContext context) {
   return
      SingleChildScrollView(
       child: Column(
       crossAxisAlignment:CrossAxisAlignment.center,
         children:<Widget>[
           Divider(color:Color(0xFF005792),thickness: 1,),
         ListTile(

           title:Text("Date: ${pickedDate.year},${pickedDate.month},${pickedDate.day}"),
           trailing: Icon(Icons.keyboard_arrow_down , color:Color(0xFF005792)),
           onTap: _pickDate,

         ),
        Divider(color:Color(0xFF005792),thickness: 1,),
         ListTile(
           title: Text("Time: ${time.hour}:${time.minute}"),
           trailing: Icon(Icons.keyboard_arrow_down,color:Color(0xFF005792)),
           onTap:_pickTime,

         ),
           Divider(color:Color(0xFF005792),thickness: 1,),
       ],

       ),
     );

  }
  _pickDate() async{

  DateTime date = await  showDatePicker(
      context:context,
      firstDate: DateTime(DateTime.now().year-5),
      lastDate:DateTime(DateTime.now().year+5),
    initialDate: pickedDate,
    );

  if(date = null)
    setState((){
      pickedDate = date;
    });
  }
  _pickTime() async {
    TimeOfDay t = await showTimePicker(context: (context), initialTime: time);
    if(t = null)
      setState(() {
        time = t;
      });
  }

}
class Calender extends StatelessWidget {
  CalendarpageState createState() => CalendarpageState();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

class CalendarpageState {
}
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }






