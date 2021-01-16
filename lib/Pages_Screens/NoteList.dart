import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hazlo/Model/Note.dart';
import 'package:hazlo/Pages_Screens/Calendar.dart';
import 'package:hazlo/Pages_Screens/Note_details.dart';
import 'package:hazlo/Services/db_service.dart';
import 'package:hazlo/Widget/Note_item.dart';
import 'package:hazlo/Widget/Popup_Menu.dart';
import 'AddNote.dart';
import 'Login.dart';
import 'Settings.dart';
import 'dart:async';

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
   var list;
  //creating a list of items known as notes
  final notes = List<String>.generate(20, (i) => "Items ${i + 1}");

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseUser user;
  bool isSearching = false;
  Icon cusIcon = Icon(Icons.search);
  Widget custSearchBar = Text('Notes');


  GoogleSignIn get _googleSignIn => GoogleSignIn();
  final _formKey = GlobalKey<FormState>();

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<
      RefreshIndicatorState> ();


  @override
  void initState() {
    super.initState();
    list = List<String>.generate(20, (i) => "Items ${i + 1}");
    _refresh();
    initUser();
  }

  initUser() async {
    user = await _firebaseAuth.currentUser();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // ignore: non_constant_identifier_names

    return Scaffold(
        key: _formKey,
        backgroundColor: Colors.grey.shade300,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: custSearchBar,
          actions: <Widget>[
            IconButton(
                icon: cusIcon,
                onPressed: () {
                  setState(() {
                    if (this.cusIcon.icon == Icons.search) {
                      this.cusIcon = Icon(Icons.cancel);
                      this.custSearchBar = TextField(
                        textInputAction: TextInputAction.go,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Search Notes"
                        ),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                      );
                    }
                    else {
                      this.cusIcon = Icon(Icons.search);
                      this.custSearchBar = Text('Notes');
                    }
                  });
                }),
            
            // PopupMenu that has signout function
            PopupMenuButton<String>(
              onSelected: choiceAction,
              itemBuilder: (BuildContext context) {
                return Constants.choices.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
            
            ],
        ),
        // Refresh indicator
        body: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: _refresh,
          child:
          StreamBuilder(
            stream: notesDb.streamList(),
            builder: (BuildContext context, AsyncSnapshot<List<Note>>snapshot) {
              if (snapshot.hasError) return Center(
                child: Text("Error: unable to loading your notes"),
              );

              if (!snapshot.hasData) return CircularProgressIndicator();
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return NoteItem(note: snapshot.data[index],
                      onDelete: (note) async {
                        if (await _confrimDelete(context)) {
                          notesDb.removeItem(note.id);
                        }
                      },
                      onTap: (note) =>
                          Navigator.push(context, MaterialPageRoute(
                            builder: (_) => NoteDetails(note: note,),
                          )
                          ),
                      onEdit: (note) {
                        Navigator.push(context, MaterialPageRoute(
                            builder: (_) => AddNote(note: note,)
                        ));
                      },
                    );
                  }
              );
            },
          ),
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
                    builder: (context) => new AddNote2()));
              },
              heroTag: null,
              backgroundColor: Color(0xFF005792),

            ),

          ],

        )
    );
  }

// More menu Options
  Future<void> choiceAction(String choice) async
  {
    if (choice == Constants.SignOut) {
      await _firebaseAuth.signOut();
      await _googleSignIn.signOut();

      Navigator.push(context, new MaterialPageRoute(
          builder: (context) => new Login()));
      print('user Signed Out');
    }

    if (choice == Constants.Settings) {
      Navigator.push(
          context, new MaterialPageRoute(builder: (context) => new Settings()));
    }
  }


  //Delete function
  Future<bool> _confrimDelete(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: Text("Confirm Delete"),
              content: Text("Are you want to delete note?"),
              actions: <Widget>[
                FlatButton(
                  child: Text("No"),
                  onPressed: () => Navigator.pop(context, false),
                ),
                FlatButton(
                  child: Text("Yes"),
                  onPressed: () => Navigator.pop(context, true),
                ),
              ],
            )

    );
  }

  // pull to refresh function
  Future<Null> _refresh() async {
    _refreshIndicatorKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      list = List<String>.generate(20, (i) => "Items ${i + 1}");

    });
    return null;
  }
}


