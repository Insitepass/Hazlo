import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hazlo/Model/Note.dart';
import 'package:hazlo/Services/admob_service.dart';
import 'package:provider/provider.dart';

class NoteDetails extends StatefulWidget {
  final Note note;

  const NoteDetails({Key key, @required this.note}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return NoteDetailsState(note);
  }


}


class NoteDetailsState extends State<NoteDetails> {
  final Note note;
  BannerAd banner;

  final _formKey = GlobalKey<FormState>();

  NoteDetailsState(this.note);





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
  Widget build(BuildContext context) {

    return Scaffold(
      key: _formKey,
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
          )
      ),
    );
  }
}

