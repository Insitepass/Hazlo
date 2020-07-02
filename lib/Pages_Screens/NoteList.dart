import 'package:flutter/material.dart';
import 'package:hazlo/Model/Note.dart';
import 'package:hazlo/Pages_Screens/Calendar.dart';
import 'package:hazlo/Pages_Screens/Note_details.dart';
import 'package:hazlo/Services/db_service.dart';
import 'package:hazlo/Widget/Note_item.dart';

import 'AddNote.dart';

class NoteList extends StatefulWidget {
  final Note note;

  const NoteList({Key key, this.note}) : super(key: key);

  @override
  State<StatefulWidget> createState() {

    return NoteListState();
  }
}

class NoteListState extends State<NoteList> {
  int count = 0;

  //creating a list of items known as notes
  final notes = List<String>.generate(20, (i) => "Items ${i + 1}");

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // ignore: non_constant_identifier_names
    return Scaffold(
        key: _formKey,
        backgroundColor: Colors.grey.shade300,
        appBar: AppBar(
          title: Text('Notes'),
          automaticallyImplyLeading: false,
          backgroundColor: Color(0xFF005792),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {},// sign out function
            ),
          ],
        ),
        body: StreamBuilder(
          stream: notesDb.streamList(),
          builder: (BuildContext context, AsyncSnapshot<List<Note>>snapshot) {
            if (snapshot.hasError) return Center(
              child: Text("There was an error"),
            );

            if (!snapshot.hasData) return CircularProgressIndicator();
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return NoteItem(note: snapshot.data[index],
                    onDelete: (note)async {
                    if(await _confrimDelete(context)) {
                      notesDb.removeItem(note.id);
                    }
                    },
                    onTap:(note) => Navigator.push(context,MaterialPageRoute(builder:(_)=> NoteDetails(note: note,),
                    )
                    ),
                    onEdit: (note) {
                    Navigator.push(context, MaterialPageRoute(
                      builder:(_) => AddNote(note: note,)
                    ));
                    },
                  );
                }
            );
          },
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            // FAB 2: Calender Button
            FloatingActionButton(
              child: Icon(Icons.date_range),
              onPressed: () {
                Navigator.push(context, new MaterialPageRoute(
                    builder: (context) => new Calendar()));
              },
              heroTag: null,
              backgroundColor: Color(0xFF005792),
            ),
            SizedBox(
              height: 10,
            ),
            // FAB 1: Add button
            FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                // debugPrint('FAB clicked');
                Navigator.push(context, new MaterialPageRoute(
                    builder: (context) => new AddNote()));
              },
              heroTag: null,
              backgroundColor: Color(0xFF005792),

            )
          ],

        )

    );

  }
  Future<bool>_confrimDelete(BuildContext context) async {
   return showDialog(
        context: context,
       builder:(context) => AlertDialog(
         title: Text("Confirm Delete"),
         content: Text("Are you want to delete note?"),
         actions: <Widget>[
           FlatButton(
             child:Text("No"),
             onPressed: ()=> Navigator.pop(context,false) ,
           ),
           FlatButton(
             child:Text("Yes"),
             onPressed: ()=> Navigator.pop(context,true) ,
           ),
         ],
       )

    );
  }
}