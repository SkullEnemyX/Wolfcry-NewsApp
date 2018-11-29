import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:newsfeed/bookmark.dart';
import 'package:newsfeed/color_loader.dart';
import 'package:newsfeed/latest.dart';
import 'package:newsfeed/main.dart';
import 'package:newsfeed/newsdata.dart';
import 'package:newsfeed/newspage.dart';
import 'package:newsfeed/subscription.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Newsfeed extends StatefulWidget {
  final data;
  @override
  _NewsfeedState createState() => _NewsfeedState();
  Newsfeed({this.data});
}

class _NewsfeedState extends State<Newsfeed> with SingleTickerProviderStateMixin{
  IconData menubutton = Icons.menu;
  int tapvalue = 0;
  TabController tabController ;
  bool value=false;
  bool darkThemeEnabled=false;
  SubscriptionData subscriptionData = SubscriptionData();

  @override
    void initState() {
      super.initState();
      tabController = TabController(length: 3,vsync: this,initialIndex: 1);
      setState(() {
      fetchThemeData();
      getJsonData();
          });
    }


    @override
      void dispose() {
        tabController.dispose();
        super.dispose();
      }

  getNewsData() async{
  var urlLink = await http.get(Uri.encodeFull("https://api.myjson.com/bins/1902n2"),headers: {"Accept":"application/json"});
   subscriptionData.newsFetch = json.decode(urlLink.body);
}

Future<List<dynamic>> getJsonData() async{
  await getNewsData();
  List<String> listOfNews = [];
    int ind;
    var ufdata=[];
    var data=[];
    String urlFetch;
    var response,convertDataToJson;
    final prefs = await SharedPreferences.getInstance();
    listOfNews = prefs.getStringList("NewsList")??["125"];
    for(int i=0;i<listOfNews.length;i++)
    {
      ind = int.parse(listOfNews[i]);
      urlFetch = subscriptionData.newsFetch[ind]["url"];
      response = await http.get(
      Uri.encodeFull(urlFetch),
      headers: {"Accept": "application/json"}
    );
      convertDataToJson = json.decode(response.body);
      //print(convertDataToJson['articles']);
      ufdata=convertDataToJson['articles']; 
      //Future.delayed(Duration(seconds: 1));
      data.addAll(ufdata);
    }
    data.shuffle();
    subscriptionData.newsValue = data;
    // subscriptionData.newsValue.shuffle();
    //print(subscriptionData.newsValue);
    //Navigator.push(context, MaterialPageRoute(builder: (context)=>Newsfeed(data: data,)));
    return subscriptionData.newsValue;
   
  }

  void fetchThemeData() async{
    var themeData = await SharedPreferences.getInstance();
    var themeValue = themeData.getInt("Theme");
    themeValue==1?darkThemeEnabled=true:darkThemeEnabled=false;
    setState(() {});
  } 

  void saveThemeData() async{
     var themeData = await SharedPreferences.getInstance();
     darkThemeEnabled?themeData.setInt("Theme",1 ):themeData.setInt("Theme", 0);
     //print(themeData.getInt("Theme"));
  }

  void menuList(String value)
  {
    
    if(value=='b')
    {
      Share.share("Check out developer's github repository for source code https://github.com/SkullEnemyX");
    }
    else if(value=='c')
    {
        Navigator.push(context,
        PageRouteBuilder(pageBuilder: (context, animation1, animation2) {
        return AboutPage();
        },
        transitionsBuilder: (context, animation1, animation2, child) {
        return SlideTransition(

        position: Tween<Offset>(begin: const Offset(0.0, 1.0),
        end: Offset.zero).animate(animation1),
        
        child: SlideTransition(
          position: new Tween<Offset>(
          begin: Offset.zero,
          end: const Offset(0.0, 1.0),
        ).animate(animation2),
        child: child,
        ),);
        },
        transitionDuration: Duration(milliseconds: 500),),
        );
      //confirmDialog1(context);
    }
  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
              theme: darkThemeEnabled?ThemeData.dark():ThemeData.light(),
              home: Scaffold(
              drawer: Drawer(),
              // floatingActionButton: FloatingActionButton(
              //   onPressed: (){
              //     getNewsData();
              //   },
              // ),
              appBar: AppBar(
                backgroundColor: darkThemeEnabled?Colors.grey.shade900:Colors.white,

                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.search),
                    iconSize: 30.0,
                    color: Colors.tealAccent,
                    onPressed: (){
                      showSearch(context: context,delegate: SearchNews(
                        data: subscriptionData.newsValue
                      ));
                    },
                  )
                ],
                title: Text("News Feed",style: TextStyle(fontSize: 24.0,color: darkThemeEnabled?Colors.white:Colors.black),),
                centerTitle: true,
                leading: new PopupMenuButton<String>(
                  onSelected: menuList,
                  icon: new Icon(Icons.menu,color: Colors.grey.shade500,size: 30.0,),
                    itemBuilder: (BuildContext context){
                      return <PopupMenuItem<String>>[
                      PopupMenuItem<String>(
                      value: 'a',
                      child: ListTile(
                        trailing: SwitchButton(
                          switchValue: darkThemeEnabled,
                          valueChanged: (valchange)
                          {
                            setState(() {
                              darkThemeEnabled = valchange;
                              saveThemeData();
                            });
                          },
                        ),
                        title: Text("Dark Theme"),
                        
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: 'b',
                      child: ListTile(
                        title: Text("Share"),
                      ),),
                    const PopupMenuItem<String>(
                      value: 'c',
                      child: ListTile(
                        //leading: Icon(Icons.exit_to_app),
                        title: Text("About"),
                      ),
                    
                    ),
                    ];}
                ),
                bottom: TabBar(
                  controller: tabController,
                  labelStyle: TextStyle(
                    fontSize: 15.0
                  ),
                  labelColor: darkThemeEnabled?Colors.white:Colors.black,
                   tabs: <Widget>[
                     new Tab(
                       text: "Subscription",
                     ),
                     new Tab(
                       text: "Latest",
                     ),
                     new Tab(
                       text: "Bookmark",
                     )
                   ],
                ),
              ),
              body: FutureBuilder(
                future: getJsonData(),
                builder: (context,snapshot){
                return TabBarView(
                  controller: tabController,
                  children: <Widget>[
                    Subscription(subscriptionData: subscriptionData,),
                    snapshot.hasData==false?Container(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                ColorLoader3(
                                  dotRadius: 6.0,
                                  radius: 28.0,
                                ),
                              Text(
                                "Fetching The Latest News For You",
                                style: TextStyle(
                                  fontSize: 15.0
                                ),
                              )
                              ],
                            )
                          ),
                        ):
                    Latest(darkThemeEnabled: darkThemeEnabled,future: subscriptionData.newsValue,),
                    Bookmark()
                  ],
                );}
              ),
          ),
        );
  }
}

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
        body: Container(
        color: Colors.teal,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Developer: Vineet Kishore",style: TextStyle(
                color: Colors.black,
                fontSize: 20.0
              ),)
            ],
          ),
        ),
      ),
    );
  }
}

class SearchNews extends SearchDelegate {
  var data;
  SearchNews({this.data});

  @override
  List<Widget> buildActions(BuildContext context) {
    print(data);
    return [
      IconButton(
        icon: Icon(Icons.clear),
        color: Colors.teal,
        onPressed: (){query='';},
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: (){
        close(context, null);
      },
    );
  }

  List<String> newsTitle = [];

  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    newsTitle = [];
    for(int i=0;i<data.length;i++)
    {
      newsTitle.add(data[i]["title"]);
    }
    final suggestionList = query.isEmpty?newsTitle:newsTitle.where((p)=>p.contains(query)).toList();
    //print(suggestionList);
    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (BuildContext context,int index){
        return Card(
          elevation: 1.0,
          margin: EdgeInsets.symmetric(horizontal: 15.0,vertical: 5.0),
          child: ListTile(
            onTap: ()=>Navigator.push(context, MaterialPageRoute(
              builder: (context)=> NewsPage(
                date: data[index]["publishedAt"].toString().split("T")[0],
                desc: data[index]["content"],
                time: data[index]["publishedAt"].toString().split("T")[1].split("Z")[0],
                title: data[index]["title"],
                url: data[index]["url"],
                urlToImage: data[index]["urlToImage"],
              )
            )),
            title: RichText(
              text: TextSpan(
                text: suggestionList[index].substring(0,query.length),
                style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),
                children: [TextSpan(
                  text: suggestionList[index].substring(query.length,suggestionList[index].length),
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12.0
                  )
                )]
              ),
            ),
          ),
        );
      }
    );
  }

}
