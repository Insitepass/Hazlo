import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hazlo/Model/Note.dart';

class NoteDetails extends StatelessWidget {
  final Note note;

  const NoteDetails({Key key, @required this.note}) : super(key: key);
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: Text('Note Details')
     ),
     body: SingleChildScrollView(
       padding:const EdgeInsets.all(16.0),
       child:Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: <Widget>[
           Text(note.title, style:Theme.of(context).textTheme.headline5),

           Text(note.description,style: Theme.of(context).textTheme.bodyText1,),

         ],
       )
     ),
   );
  }
}