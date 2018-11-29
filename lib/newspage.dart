import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsPage extends StatefulWidget {
   
   final String title;
   final String desc;
   final String url;
   final String urlToImage;
   final String time;
   final String date;

  @override
  _NewsPageState createState() => _NewsPageState();
  NewsPage({Key key, this.date,this.title,this.desc,this.url,this.urlToImage,this.time}) : super(key: key);
}

class _NewsPageState extends State<NewsPage> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     title: "NewsX",
     home: new Scaffold(
       body: Column(
         children: <Widget>[
           Expanded(
         child:  ListView(
         shrinkWrap: true,
         children: <Widget>[
           Container(
         color: Colors.white,
         child: Column(
           mainAxisAlignment: MainAxisAlignment.start,
           crossAxisAlignment: CrossAxisAlignment.center,
           children: <Widget>[
              new CachedNetworkImage(
                  imageUrl:
                   "${widget.urlToImage}",
                   placeholder: SizedBox(),
               ),
             
             Padding(
               padding: EdgeInsets.all(15.0),
             ),
             Card(
               elevation: 0.0,
               shape: RoundedRectangleBorder(
                 borderRadius: BorderRadius.circular(10.0),
               ),
               
               margin: EdgeInsets.all(12.0),
               child: Column(
              children: <Widget>[
                
                Text(
                  "${widget.title}",style: TextStyle(color: Colors.grey[700],fontSize: 22.0,fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 50.0,
                ),
                Text(
                  "${widget.desc}".split("[")[0],style: TextStyle(color: Colors.grey[850],
                  fontSize: 19.0,
                  ),
                ),
              Padding(
                  padding: EdgeInsets.only(top: 30.0),
                ),
                
                Text(
                  "Published At: ${widget.time}",style: TextStyle(color: Colors.black,fontSize: 15.0
                  ),),
                 Padding(
                  padding: EdgeInsets.only(top: 10.0),
                ),
                Text(
                  "Published On: ${widget.date}",style: TextStyle(color: Colors.black,fontSize: 15.0
                  ),
                ),

              ],
               ),
             )
           ],
         ),
       ),
       SizedBox(
         height: 15.0,
       ),
       Container(
         padding: EdgeInsets.symmetric(horizontal: 15.0),
         child: RichText(
         text: TextSpan(
          text: 'Read More: \n${widget.url}',
                  style: new TextStyle(color: Colors.blue),
                  recognizer: new TapGestureRecognizer()
                    ..onTap = () {
                      launch( '${widget.url}'
                          );
                    },
       
       ),
       ),
       ),
       Padding(
         padding: EdgeInsets.only(bottom: 20.0),
       )
         ],
       ),
       )
         ],
       )
     ),
    );
  }
}
