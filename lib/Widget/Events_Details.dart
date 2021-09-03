import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hazlo/Services/admob_service.dart';
import 'package:provider/provider.dart';

import 'BottomNavigator.dart';

class EventDetails extends StatefulWidget {
  final DocumentSnapshot event;


  // const EventDetails(DocumentSnapshot event,) : event = event;
  EventDetails({Key key, this.event}) :super(key:key);

  @override
  _EventDetailsState createState() => _EventDetailsState(event);


}



class _EventDetailsState  extends State<EventDetails> {
  final Firestore _db = Firestore.instance;
  DocumentSnapshot event;
  _EventDetailsState(DocumentSnapshot event) {
    this.event = event;
  }

  String user;
  BannerAd banner;


  @override
  void initState() {
    super.initState();

    //today = DateTime.now();
  }

  // add mob stuff
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final adHelper = Provider.of<AdHelper>(context);
    adHelper.initialization.then((status) {
      setState(() {
        banner = BannerAd(
          adUnitId: AdHelper.bannerAdUnitId,
          size: AdSize.largeBanner,
          request: AdRequest(),
          listener: adHelper.adListener,
        )..load();
      });
    });
  }


  @override
  Widget build(BuildContext context){

    final String title = widget.event.data['title'];
    final String details = widget.event.data['description'];
    return Scaffold(
      appBar: AppBar(
        title: Text('Event details'),
        actions: <Widget> [
      Padding(
      padding: EdgeInsets.only(right: 20.0),
      child: GestureDetector(
        // delete event
        onTap: ()  async {
          await _db.collection('events').document(event
              .documentID).delete();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Event Deleted'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 1)
          )
         );
          Navigator.push(context, new MaterialPageRoute(
              builder: (context) => new BottomNavbar()));
        },
        child: Icon(
            Icons.delete,
          color: Colors.white,
        ),
      )
      )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("$title", style: Theme.of(context).textTheme.headline5,),
            SizedBox(height: 20.0),
            Text("$details"),
            SizedBox(height: 20.0),
            // banner ad
            if(banner == null)
              SizedBox(
                height:150,
              )
            else
              Container(
                height:150,
                child: AdWidget(ad: banner),
              ),
          ],
        ),
      ),
    );
  }


}

