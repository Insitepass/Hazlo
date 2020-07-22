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
             // user profile button
            IconButton(
              icon: Icon(Icons.person),
              onPressed: () async {
                getCurrentUser();
              },

            ),
            // PopupMenu that has signout function
           PopupMenuButton<String>(
             onSelected: choiceAction,
             itemBuilder: (BuildContext context) {
               return Constants.choices.map((String choice) {
               return PopupMenuItem<String>(
                 value:  choice,
                 child: Text(choice),
               );
               }).toList();
             },
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
  
  Future<void> choiceAction(String choice) async
{
  if(choice == Constants.SignOut)
    {
      await _firebaseAuth.signOut();
      await _googleSignIn.signOut();

      Navigator.push(context, new MaterialPageRoute(
          builder: (context) => new Login()));
          print('user Signed Out');
    }

}
// getting the current user
  Future<String> getCurrentUser() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String uid = user.uid.toString();
    return uid;
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
