import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart' show rootBundle;



class TermsandConditionsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TermsandConditionsState();
  }
}

class TermsandConditionsState extends State<TermsandConditionsPage> {

  String data = '';

  fetchFileData() async
  {
    String termsText;

    termsText = await rootBundle.loadString('assets/txt/Terms.txt');


     setState(() {
       data = termsText;
     });
  }

  @override
  void initState() {

    fetchFileData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Terms and Conditions'),
        leading:IconButton(icon: Icon(
            Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop('Settings');
            }
        ),
        backgroundColor: Color(0xFF005792),
      ),
      body:Padding(
    padding: EdgeInsets.all(10),
    child: ListView(
    children: <Widget>[
      Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget> [
            Expanded(
              child: Text(data),

            )
          ],
        )
      )
    ]
    )
    )
    );

  }


}
