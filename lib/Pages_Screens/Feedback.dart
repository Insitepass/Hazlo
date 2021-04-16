
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class FeedbackPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return FeedbackPageState();
  }
}

class FeedbackPageState extends State<FeedbackPage> {
   final _formkey = GlobalKey<FormState>();
  TextEditingController  _titleController = TextEditingController();
  TextEditingController  _messageController = TextEditingController();
  TextEditingController  _emailController = TextEditingController();

  String platformResponse;




  @override
  Widget build(BuildContext context) {
    return Scaffold (
      appBar: AppBar(
        title: Text('Feedback'),
        backgroundColor: Color(0xFF005792),
      ),
          // title field
          body: Form(
            key: _formkey,
          child: Padding(
            padding:EdgeInsets.all(10),
          child : ListView(
            children: <Widget> [
              // first field title field
          Container(
          padding: EdgeInsets.all(10),
            child: TextFormField(
              validator:(value) {
                if(value == null || value.isEmpty) {
                  return "Please enter title";
                }
                return null;
              },
                controller: _titleController,
                onChanged: (value) {
                  debugPrint(
                      'title field has been clicked'
                  );
                },
                decoration: InputDecoration(
                    hintText: 'Title',
                    labelStyle: Theme
                        .of(context)
                        .textTheme
                        .headline5,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: const BorderSide(
                          color: Color(0xFF005792)),
                    )
                )
            ),
          ),

      // second field Message field
      Container(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
        child:TextFormField (
          validator:(value) {
            if(value == null || value.isEmpty) {
              return "Please enter your message";
            }
            return null;
          },
            maxLines: 5,
            controller: _messageController,
            onChanged:(value) {
              debugPrint(
                  'Message field has been clicked'
              );
            }
            ,
            decoration: InputDecoration(
            hintText: 'Message',
            labelStyle: Theme
                .of(context)
                .textTheme
                .headline5,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: const BorderSide(
                  color: Color(0xFF005792)),
            )
        ),

      ),

    ),



              // email filed
              Container(
                padding: EdgeInsets.all(10),
                child:TextFormField(
                  controller: _emailController,
                  validator: (value) {
                    String pattern =
                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                    RegExp regExp = new RegExp(pattern);
                       if (value.isEmpty) {
                  return "Email is required";
                 } else if (!regExp.hasMatch(value)) {
                 return 'Invalid email';
                } else {
                   return null;
              }
                  },
                    onChanged: (value) {
                      debugPrint(
                          ' email field clicked');
                    },
                    decoration: InputDecoration(
                        hintText: 'Your email address (Required)',
                        labelStyle: Theme
                            .of(context)
                            .textTheme
                            .headline5,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: const BorderSide(
                              color: Color(0xFF005792)),
                        )
                    )

                ),


              ),

              // Separator container
              Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              ),
        // Submit button
          Container(
            height: 50,
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: ElevatedButton.icon(
              icon: Icon(Icons.send),
                label: Text('Send'),
                style: ElevatedButton.styleFrom(
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),

                ),
               onPressed: () async {
                try{
                  //sending email function
                    final Email _email = Email(
                      body:  _messageController.text,
                      subject: _titleController.text,
                      recipients:['Nombuso@busogirl.com'],
                      cc:['busogirl@gmail.com'],
                      bcc:['Nombuso.Mthimkhulu@outlook.com'],
                      isHTML:false,
                    );

                    await FlutterEmailSender.send(_email);
                    platformResponse = 'success';
                    if(_formkey.currentState.validate()) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar
                        (SnackBar(content:Text('Thank you for your feedback!')));
                    }

                }
                catch (error) {
                   platformResponse = error.toString();
                }

               }


                ),
        )


            ]
          )


    )
          )
    );
  }


}

