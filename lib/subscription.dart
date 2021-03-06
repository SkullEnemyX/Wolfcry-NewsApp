import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:newsfeed/color_loader.dart';
import 'package:newsfeed/newsdata.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Subscription extends StatefulWidget {
  SubscriptionData subscriptionData;
  bool darkThemeEnabled;
  @override
  _SubscriptionState createState() => _SubscriptionState();
  Subscription({this.subscriptionData,this.darkThemeEnabled});
}

class _SubscriptionState extends State<Subscription> {
  
  static var newsData; 
  List<String> subPress=[] ;


  @override
    void initState() {
      super.initState();
      this.getNewsData();
      this.fetchpreferences();
    }
  
  fetchpreferences() async{
  final sprefs = await SharedPreferences.getInstance();
  subPress = sprefs.getStringList("subPress")??List<String>.generate(newsData.length, (int index)=> index==125?"1":"0");
  //print(subPress);

  }

  savepreferences(List<String> s) async{
    final sprefs = await SharedPreferences.getInstance();
    await sprefs.setStringList("subPress", s);
  }

  void shownewsToast() {
  Fluttertoast.showToast(
    msg: "Refresh the feed",
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    //timeInSecForIos: 1
    );
  }

  getNewsData() async{
  newsData = widget.subscriptionData.newsFetch;

   //print(newsData);
   return newsData;
}

addNews(int index) async{
List<String> listOfNews = [];
final prefs = await SharedPreferences.getInstance();
listOfNews = prefs.getStringList("NewsList")??["125"];
if(listOfNews.contains(index.toString())==false)
listOfNews.add(index.toString());
listOfNews.sort();
print(listOfNews);
prefs.setStringList("NewsList", listOfNews);
//prefs.clear();
}

removeNews(int index) async{
List<String> listOfNews = [];
final prefs = await SharedPreferences.getInstance();
listOfNews = prefs.getStringList("NewsList")??["125"];
if(listOfNews.contains(index.toString())==true)
listOfNews.remove(index.toString());
listOfNews.sort();
print(listOfNews);
prefs.setStringList("NewsList", listOfNews);
//prefs.clear();
}


  @override
  Widget build(BuildContext context) {
    var deviceOrientation = MediaQuery.of(context).orientation;
    return Scaffold(
        body: Container(
        child: FutureBuilder(
          future: getNewsData(),
          builder: (context,snapshot){
            if(!snapshot.hasData)
            return Container(
              child: Center(
                child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                ColorLoader3(
                                  dotRadius: 6.0,
                                  radius: 28.0,
                                  color: Colors.teal
                                ),
                              Text(
                                "Fetching Subscription List",
                                style: TextStyle(
                                  fontSize: 16.0,
                                ),
                              )
                              ],
                            )
              ),
            );
            else
            return GridView.builder(
              itemCount: snapshot.data.length,
              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: (deviceOrientation == Orientation.portrait) ? 3 : 5),
              itemBuilder: (context,i){
                return new Card(
            child: new SizedBox(
              height: 400.0,
              child: RaisedButton(
                color: subPress[i] == "0"?
                widget.darkThemeEnabled?Colors.grey.shade800: Colors.white70:Colors.grey.shade500,
                onPressed: (){
                  setState(() {
                          subPress[i] == "0"?subPress[i] = "1":subPress[i] = "0";
                          subPress[i] == "0"?removeNews(i):addNews(i);
                          setState(() {
                          shownewsToast();

                          // Latest(
                          //   change: 1,
                          // );
                          Future.delayed(Duration(seconds: 1));
                          });
                          savepreferences(subPress);
                          fetchpreferences();
                          //print(subPress);
                        });
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CachedNetworkImage(
                          imageUrl: snapshot.data[i]["logo"],
                          fit: BoxFit.cover,
                          height: deviceOrientation == Orientation.portrait?80.0:90.0,
                          width: deviceOrientation == Orientation.portrait?80.0:90.0,
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                      Text(snapshot.data[i]["title"],
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12.0,),)
                      ],
                    ),
                  ],
                ),
              ),
            )
          );
              }
            );
          }
        ),
      ),
    );
  }
}