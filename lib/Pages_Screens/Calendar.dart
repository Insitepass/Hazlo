


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hazlo/Model/Event.dart';
import 'package:hazlo/Pages_Screens/NoteList2.dart';
import 'package:hazlo/Widget/Events_Details.dart';
import 'package:table_calendar/table_calendar.dart';



class Calendar extends StatefulWidget {
  final EventModel event;

  const Calendar({Key key, this.event}) : super(key: key);


  @override
  State<StatefulWidget> createState() {

    return CalendarState();
  }
}

class CalendarState extends State<Calendar> {
  final Firestore _db = Firestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String user;
  CalendarController _calendarController;
  DateTime today;
  DateTime startDate;
  DateTime endDate;

  Map<DateTime, List<dynamic>> _events;
  List<dynamic>_selectedEvents;

  var eventStream;
  var dateFormat;




  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
    _events ={};
    _selectedEvents = [];




    //today = DateTime.now();
  }


// returning and parsing firebase data
  Map<DateTime, List> _groupEvents (List<DocumentSnapshot>events){
    Map<DateTime,List> eventdata;


    for(int i = 0; i < events.length; i++) {
      DocumentSnapshot data = events[i];
      DateTime currentDate  = (data['eventdate'].toDate());
      List eventTitle = [];

      for(int e = 0; e < events.length;  e++) {
        DocumentSnapshot  temp = events[e];

        if(data['eventdate'] == temp['eventdate']) {
          eventTitle.add(temp.data['title']);
        }
      }

      if(eventdata == null) {
        eventdata = {
          currentDate : eventTitle

        };

      }
      else {
        eventdata[currentDate] = eventTitle;
      }

    }
    return eventdata;

  }



  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  initUser() async {
    user = (await _firebaseAuth.currentUser()).uid;
    setState(() {});
  }


// build the widget starts here.
  @override
  Widget build(BuildContext context)  {

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Calendar'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context,
                  MaterialPageRoute(builder: (context) => NoteList2()));
            },
          ),
        ),
        body:
        Container(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TableCalendar(
                    //check here
                    events:_events,
                    onDaySelected:(date,events,_) {
                      setState((){
                        _selectedEvents = events;
                      });
                    },
                    calendarStyle: CalendarStyle(
                      selectedColor: Colors.blueGrey,
                      todayColor: Color(0xFF005792),
                    ),
                    daysOfWeekStyle: DaysOfWeekStyle(
                        weekdayStyle: TextStyle(
                          //  color:Color(0xFF005792),
                            fontWeight: FontWeight.bold,
                            fontSize: 16
                        ),
                        weekendStyle: TextStyle(
                            color: Color(0xFF005792),
                            fontWeight: FontWeight.bold,
                            fontSize: 16
                        )
                    ),
                    headerStyle: HeaderStyle(
                        formatButtonVisible: true,
                        titleTextStyle: TextStyle(
                          //color: Color(0xFF005792),
                          fontSize: 20, fontWeight: FontWeight.bold,
                        ),
                        leftChevronIcon: Icon(
                          Icons.chevron_left,
                          color: Color(0xFF005792),
                        ),
                        rightChevronIcon: Icon(
                          Icons.chevron_right,
                          color: Color(0xFF005792),
                        )
                    ),

                    // build the calender
                    builders: CalendarBuilders(
                      selectedDayBuilder: (context, date, events) =>
                          Container(
                              margin: const EdgeInsets.all(4.0),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Theme
                                      .of(context)
                                      .primaryColor,
                                  borderRadius: BorderRadius.circular(
                                      25.0)),
                              child: Text(
                                date.day.toString(),
                                style: TextStyle(color: Colors.white),
                              )),
                      todayDayBuilder: (context, date, events) =>
                          Container(
                              margin: const EdgeInsets.all(4.0),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.blueGrey,
                                  borderRadius: BorderRadius.circular(
                                      25.0)),
                              child: Text(
                                date.day.toString(),
                                style: TextStyle(color: Colors.white),
                              )),
                    ),
                    calendarController: _calendarController,
                  ),
                  SizedBox(height: 20,),
                  Container(
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
                              child: Text(
                                'Today', style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold
                              ),
                              ),
                            ),
                            //This is where the events will be shown
                            Container(
                                padding: EdgeInsets.only(top: 20),
                                child: Row(
                                  children: <Widget>[
                                    // there is an error, it cannot read data even though it available on the database
                                    Expanded (
                                      child:
                                      StreamBuilder<QuerySnapshot>(
                                        stream:  eventStream = _db.collection('events')
                                            .where('userid', isEqualTo: user)
                                            .snapshots(),
                                        builder: (BuildContext context ,AsyncSnapshot<QuerySnapshot>snapshot) {
                                          if (snapshot.hasError)
                                            return Text(
                                                "unable to load Events",
                                                style: TextStyle(
                                                    color: Colors
                                                        .white
                                                )
                                            );
                                          if (!snapshot.hasData) {
                                            return CircularProgressIndicator();
                                          }
                                          if (snapshot.hasData) {
                                            // parsing the array here and input the list of events in the calendar  for the selected catagory
                                            List<DocumentSnapshot> documents = snapshot.data.documents;
                                            _selectedEvents = documents;
                                            _events =  _groupEvents (documents);
                                            print(_events.toString());
                                            // will have to fixt this at some point.
                                            _selectedEvents = _events[_events] ?? [];

                                            return ListView.builder(
                                                scrollDirection: Axis.vertical,
                                                shrinkWrap: true,
                                                itemCount: snapshot.data.documents.length,
                                                itemBuilder: (context, index)   {
                                                  final event = snapshot.data.documents[index];

                                                  return ListTile (
                                                    title: Text(event.data['title'],
                                                        style:TextStyle(
                                                            color:Colors.white
                                                        )),
                                                    onTap: () {

                                                      Navigator.push(context,MaterialPageRoute(builder: (_) => EventDetails(event:event)));
                                                    },
                                                   // edit event.
                                                   //  trailing: IconButton(
                                                   //    icon:Icon (Icons.edit),
                                                   //    color:Colors.white,
                                                   //    onPressed : () async {
                                                   //      //TODO  edit function
                                                   //    }
                                                   //      )
                                                  );
                                                }
                                            );

                                          }
                                          return CircularProgressIndicator();
                                        },

                                      ),
                                    )
                                  ],
                                )

                            ),

                          ],
                        )
                      ],

                    ),
                  ),
                ],
              ),
            )
        )
    );

  }
}







