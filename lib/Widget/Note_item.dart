
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hazlo/Model/Note.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'package:timeago/timeago.dart' as timeago;


class NoteItem extends StatelessWidget {

  final Note note;
  final Function(Note) onEdit;
  final Function(Note) onDelete;
  //final Function(Note) onShare;
  final Function(Note) onTap;
  final f = new DateFormat('yyyy-MM-dd hh:mm');



   NoteItem(
      { Key key, @required this.note, @required this.onEdit, @required this.onDelete, @required this.onTap, t})
      : super (key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0,
        horizontal: 8.0,),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Slidable(
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        secondaryActions: <Widget>[
          // Slide Edit Action
          IconSlideAction(
            caption: 'Edit',
            color: Colors.blueGrey,
            icon: Icons.edit,
            onTap: () => onEdit(note),
          ),

          // Slide Delete Action
          IconSlideAction(
            caption: 'Delete',
            color: Colors.red,
            icon: Icons.delete,
            onTap: () => onDelete(note),
          ),

        //Slide Share Action
          IconSlideAction(
            caption: 'Share',
            color: Color(0xFF005792),
            icon: Icons.share,
            onTap: () => onShare(context,note),
          ),
        ],

        child: ListTile(
          onTap: () => onTap(note),
          title: Text(note.title),
          // displaying when the note was created.
          subtitle:Text(timeago.format(DateTime.tryParse(note.createdAt.toString())).toString())
        ),
      ),
    );
  }
  // share functionality.
  void onShare(BuildContext context, Note note) {
   final String  text =  "Hazlo:" " ${note.title} - ${ note.description}";

    Share.share(text,subject: note.description);

  }

}
