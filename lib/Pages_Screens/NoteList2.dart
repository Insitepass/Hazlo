import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hazlo/Model/Note.dart';
import 'package:hazlo/Model/searchword_class.dart';
import 'package:hazlo/Pages_Screens/AddNote2.dart';
import 'package:hazlo/Pages_Screens/Login.dart';
import 'file:///C:/Hazlo/hazlo/lib/Widget/Note_details.dart';
import 'package:hazlo/Services/db_service.dart';
import 'package:hazlo/Widget/Note_item.dart';
import 'package:hazlo/Widget/Popup_Menu.dart';
import 'Settings.dart';
import 'dart:async';

class NoteList2 extends StatefulWidget {

  final Note note;


  const NoteList2({Key key, this.note}) : super(key: key);


  @override
  State<StatefulWidget> createState() {

    return NoteList2State();
  }
}

class NoteList2State extends State<NoteList2> {
  int count = 0;
  var list;
  //creating a list of items known as notes
  final notes = List<String>.generate(500, (i) => "Items ${i + 1}");


  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseUser user;
  

  GoogleSignIn get _googleSignIn => GoogleSignIn();
  final _formKey = GlobalKey<FormState>();

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<
      RefreshIndicatorState> ();


  @override
  void initState() {
    super.initState();
    list = List<String>.generate(500, (i) => "Items ${i + 1}");
    _refresh();
    initUser();
  }

  initUser() async {
    user = await _firebaseAuth.currentUser();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        key: _formKey,
        backgroundColor: Colors.grey.shade300,
        appBar: AppBar(
          automaticallyImplyLeading: false,
           title: Text("Notes"),

           //custSearchBar,
          actions: <Widget>[
            IconButton(
            icon: Icon(Icons.search),
            onPressed: ()  async {
              //check here
              final result = await
              showSearch<String>(context: context, delegate: NoteSearch()
              );
              print(result);
            }

                ),
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
        body:
        RefreshIndicator(
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
                            builder: (_) => AddNote2(note: note,)
                        ));
                      },
                    );
                  }
              );
            },
          ),
        ),
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
                TextButton(
                  child: Text("No"),
                  onPressed: () => Navigator.pop(context, false),
                ),
                TextButton(
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



  // search functionality class
  class NoteSearch extends SearchDelegate<String> {
    // this is from the searchword class
    final keywords = Searchword.keywords;

    // final List<String> keywords;
    final Note note;
    String result;


    NoteSearch({ this.note,});


    @override
    List<Widget> buildActions(BuildContext context) {
      // actions for app bar
      return [
        IconButton(icon: Icon(Icons.clear),
            onPressed: () {
              query = "";
            })
      ];
    }

    @override
    Widget buildLeading(BuildContext context) {
      // leading icon on the left of the app bar
      return IconButton(
          icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow,
            progress: transitionAnimation,
          ),
          onPressed: () {
            close(context, result);
          }
      );
    }

    @override
    Widget buildResults(BuildContext context) {
      //show some result based on the selection
     return  StreamBuilder(
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

                  },
                  onTap: (note) =>
                      Navigator.push(context, MaterialPageRoute(
                        builder: (_) => NoteDetails(note: note,),
                      )
                      ),
                  onEdit: (note) {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (_) => AddNote2(note: note,)
                    ));
                  },
                );
              }
          );
        },
      );
    }


    @override
    Widget buildSuggestions(BuildContext context) {
      // show when someone searches for something

      final suggestions = keywords.where((keyword) {
        return keyword.toLowerCase().contains(query.toLowerCase());
      });
      return ListView.builder(
          itemCount: suggestions.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
                title: Text(
                  suggestions.elementAt(index),
                ),
                onTap: () {
                  query = suggestions.elementAt(index);
                }
            );
          });
    }

  }
