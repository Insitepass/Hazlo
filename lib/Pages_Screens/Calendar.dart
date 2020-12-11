import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hazlo/Model/Event.dart';
import 'package:hazlo/Services/event_firestore_service.dart';
import 'package:hazlo/Widget/Events_Details.dart';
import 'package:table_calendar/table_calendar.dart';



class Calendar extends StatefulWidget {


  @override
  State<StatefulWidget> createState() {

    return CalendarState();
  }
}

class CalendarState extends State<Calendar> {
  CalendarController   _calendarController;
  Map<DateTime, List<dynamic>> _events;
  List<dynamic>_selectedEvents;

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
    _events = {};
    _selectedEvents = [];
  }

  Map<DateTime, List<dynamic>> _groupEvents(List<EventModel>events){
    Map<DateTime,List<dynamic>> data = {};
     events.forEach((event){
       DateTime date = DateTime(event.eventDate.year,event.eventDate.month,event.eventDate.day,12);
       if(data[date]  == null )data[date] = [];
       data[date].add(event);
 });
return data;
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }
// build the widget starts here.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar'),
      ),
        body:StreamBuilder<List<EventModel>>(
          stream: eventDBS.streamList(),
          builder: (context,snapshot) {
            if(snapshot.hasData){
              List<EventModel> allEvents = snapshot.data;
              if(allEvents.isNotEmpty) {
                _events = _groupEvents(allEvents);
              }
          }

    return SingleChildScrollView(
    child:Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
    TableCalendar(
      events: _events,
    calendarStyle: CalendarStyle(
    selectedColor: Colors.blueGrey ,
    todayColor: Color(0xFF005792)
    ),
    startingDayOfWeek: StartingDayOfWeek.monday,
    onDaySelected: (date,events,_) =>  setState((){
          _selectedEvents = events;
    }),
  
      // build the calender
        builders: CalendarBuilders(
        selectedDayBuilder: (context, date, events) => Container(
          margin: const EdgeInsets.all(4.0),
          alignment: Alignment.center,
          decoration:BoxDecoration(
              color: Theme.of(context).primaryColor,
          borderRadius:BorderRadius.circular(25.0)),
        child:Text(
          date.day.toString(),
          style: TextStyle(color:Colors.white),
        )),
      todayDayBuilder:(context,date, events) => Container(
        margin: const EdgeInsets.all(4.0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color:Colors.orange,
          borderRadius: BorderRadius.circular(25.0)),
          child: Text(
          date.day.toString(),
            style: TextStyle(color: Colors.white),
        )),
      ),
    calendarController: _calendarController,
    ),

      ..._selectedEvents.map((event) => ListTile(
        title: Text(event.title),
        onTap: () {
          Navigator.push(context,MaterialPageRoute(builder: (_) => EventDetails( event:event)));
        },
      ))

    ],
    )
    );
    },
    )
    );
  }

}


