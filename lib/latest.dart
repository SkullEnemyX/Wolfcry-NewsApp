import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:newsfeed/newspage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:auto_size_text/auto_size_text.dart';

class Latest extends StatefulWidget {

  int change = 0;
  bool darkThemeEnabled=false;
  var future; 
  @override
  _LatestState createState() => _LatestState();
  Latest({this.change,@required this.darkThemeEnabled,this.future});
}
class _LatestState extends State<Latest> {
  Color bookmarkColor = Colors.grey.shade300;
  int bookmarkval = 0;
  var data=[];
  var ufdata = [];
  var newsData;
  bool darkThemeEnabled=false;
  Color textColor;


  @override
    void initState() {
      super.initState();
      darkThemeEnabled = widget.darkThemeEnabled;
      //getJsonData();
    }
    
    @override
      void didUpdateWidget(Latest oldWidget) {
        super.didUpdateWidget(oldWidget);
        if(oldWidget.darkThemeEnabled!=widget.darkThemeEnabled)
        {
          setState(() {
          textColor = widget.darkThemeEnabled?Colors.grey.shade300:Colors.black;
            });
        }
      }

    void shownewsToast(String msg,int time) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: time,
        );
  }

  getNewsData() async{
  var urlLink = await http.get(Uri.encodeFull("https://api.myjson.com/bins/1902n2"),headers: {"Accept":"application/json"});
   newsData = json.decode(urlLink.body);
   //print(newsData);
   return newsData;
}

  @override
  Widget build(BuildContext context) {
    var deviceOrientation = MediaQuery.of(context).orientation;
    
    return Scaffold(
          body: Container(
        child: RefreshIndicator(
                    onRefresh: () async{
                    await Future.delayed(Duration(milliseconds: 500));
                    widget.change==1? shownewsToast("Fetching News",5):shownewsToast("Shuffling News",1);
                    widget.change==1?data = []:null;
                    widget.change = 0;
                    setState(() {
                    widget.future.shuffle();
                    });},
                    child:ListView.builder(
                          padding: EdgeInsets.all(10.0),
                          //addAutomaticKeepAlives: true,
                          itemCount: widget.future.length==null?0:widget.future.length,
                          itemBuilder: (BuildContext context,int index)
                          {
                            return GestureDetector(
                            onTap: ()=>widget.future[index]["content"]==null?
                                launch( '${widget.future[index]["url"]}')
                              :Navigator.push(context, MaterialPageRoute(builder:(BuildContext context)=> NewsPage(
                              date: widget.future[index]["publishedAt"].toString().split("T")[0],
                              desc: widget.future[index]["content"],
                              time: widget.future[index]["publishedAt"].toString().split("T")[1].split("Z")[0],
                              title: widget.future[index]["title"],
                              url: widget.future[index]["url"],
                              author: widget.future[index]['source']['name'],
                              darkThemeEnabled: widget.darkThemeEnabled,
                              urlToImage: widget.future[index]["urlToImage"],
                            ))),
                             child: widget.future[index]["urlToImage"]!=null?
                              Card(
                                elevation: 5.0,
                                child: Column(
                                  children: <Widget>[
                                    SizedBox(
                                      height: 20.0,
                                    ),
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                       child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          SizedBox(
                                            width: 15.0,
                                          ),
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Container(child: AutoSizeText(widget.future[index]["title"],
                                              minFontSize: 16.0,
                                              stepGranularity: 0.5,
                                                style: TextStyle(color: textColor,
                                                fontFamily: "Sourcesans",
                                                fontWeight: FontWeight.bold),),
                                                width: deviceOrientation==Orientation.portrait? 190.0:400,),
                                              SizedBox(height: 20.0,),
                                              Container(child: Text("Source : "+widget.future[index]["source"]["name"],
                                              style: TextStyle(fontSize: 15.0,
                                              fontFamily: "Sourcesans",
                                              color: textColor,),),
                                              width: 190.0,),
                                            ],
                                          ),
                                          SizedBox(
                                          width: 15.0,
                                        ), 
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(3.5),
                                            child: Container(
                                              child: widget.future[index]["urlToImage"]!=null?CachedNetworkImage(
                                                imageUrl: widget.future[index]["urlToImage"],
                                                height:  deviceOrientation==Orientation.portrait?110.0:150.0,
                                                width:  deviceOrientation==Orientation.portrait?150.0:210,
                                                fit: BoxFit.cover,
                                              ):Container(),
                                            ),
                                          ),
                                         SizedBox(
                                          width: 10.0,
                                        ), 
                                        ],
                                      ),
                                    ),
                                  SizedBox(
                                      height: 20.0,
                                    ),
                                  ],
                                ),
                              ):Container(),
                            );
                          },)
                  )
        
      ),
    );
  }
}