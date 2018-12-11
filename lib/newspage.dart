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
   final String author;
   final bool darkThemeEnabled;

  @override
  _NewsPageState createState() => _NewsPageState();
  NewsPage({Key key, this.author,this.date,this.title,this.desc,this.url,this.urlToImage,this.time,this.darkThemeEnabled}) : super(key: key);
}

class _NewsPageState extends State<NewsPage> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     title: "NewsX",
     theme: widget.darkThemeEnabled?ThemeData.dark():ThemeData.light(),
     home: new Scaffold(
       appBar: AppBar(
         elevation: 0.0,
         centerTitle: true,
         title: Text("News Brief",style: TextStyle(
           fontSize: 25.0,
           color: !widget.darkThemeEnabled?Colors.black87:Colors.white
         ),),
         backgroundColor: widget.darkThemeEnabled?null:Colors.grey.shade200,
         leading: IconButton(
           icon: Icon(Icons.arrow_back,
           color: widget.darkThemeEnabled?Colors.white:Colors.black54,),
           onPressed: (){Navigator.pop(context);},
         ),
       ),
       body: ListView(
            children: <Widget>[
              SizedBox(
               height: 40.0,
             ),
             Center(
               child: Padding(
                 padding: const EdgeInsets.symmetric(horizontal:20.0),
                 child: Text(
                   "${widget.title}",style: TextStyle(
                   fontSize: 23.0,
                   fontWeight: FontWeight.bold,
                   fontFamily: "Sourcesans"),
                 ),
               ),
             ),
             SizedBox(
               height: 8.0,
             ),
               Padding(
                 padding: const EdgeInsets.symmetric(horizontal:15.0),
                 child: CachedNetworkImage(
                   height: 300.0,
                    imageUrl:
                     "${widget.urlToImage}",
                     placeholder: SizedBox(),
                 ),
               ),
             SizedBox(
               height: 30.0,
             ),
             
             Padding(
               padding: const EdgeInsets.symmetric(horizontal:15.0),
               child: Text(
                 "${widget.desc}".split("[")[0],style: TextStyle(color: widget.darkThemeEnabled?Colors.grey.shade200:Colors.grey.shade800,
                 fontSize: 19.0,
                 fontFamily: "PTsans"
                 ),
               ),
             ),
             SizedBox(
               height: 35.0,
             ),
            //  Expanded(
            //    child: Container(),
            //  ),
             Center(
               child: RichText(
                 text: TextSpan(
                 text: 'Read More By Visiting: ${widget.author}',
                 style: new TextStyle(color: Colors.blue),
                 recognizer: new TapGestureRecognizer()
                 ..onTap = () {
                 launch( '${widget.url}'
                 );
                 },
         ),
         ),
             ),
         SizedBox(
           height: 50.0,
         ),
            ],
       )
     ),
    );
  }
}
