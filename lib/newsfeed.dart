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
import 'package:url_launcher/url_launcher.dart';
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
  final SubscriptionData subscriptionData = SubscriptionData();

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
        Navigator.push(context, MaterialPageRoute(
          builder: (context)=>AboutPage()
        ));
       
      //confirmDialog1(context);
    }
  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
              theme: darkThemeEnabled?ThemeData.dark():ThemeData.light(),
              home: Scaffold(
              //drawer: Drawer(),
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
                    color: Colors.tealAccent[700],
                    onPressed: (){
                      showSearch(context: context,delegate: SearchNews(
                        data: subscriptionData.newsValue,
                        darkThemeEnabled: darkThemeEnabled
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
                  indicatorColor: Colors.tealAccent[700],
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
                    Subscription(subscriptionData: subscriptionData,
                    darkThemeEnabled: darkThemeEnabled,),
                    snapshot.hasData==false?Container(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                ColorLoader3(
                                  dotRadius: 6.0,
                                  radius: 28.0,
                                  color: darkThemeEnabled?Colors.tealAccent:Colors.tealAccent[700]
                                ),
                              Text(
                                "Fetching The Latest News For You",
                                style: TextStyle(
                                  fontSize: 16.0,
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

class AboutPage extends StatefulWidget {

  @override
  AboutPageState createState() {
    return new AboutPageState();
  }
}

class AboutPageState extends State<AboutPage> with SingleTickerProviderStateMixin{

   AnimationController controller;
   Animation rotation;

  _launchURL(String toMailId, String subject, String body) async {
    var url = 'mailto:$toMailId?subject=$subject&body=$body';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
    void initState() {
      super.initState();
      controller = AnimationController(duration: Duration(seconds: 2),vsync: this);
      rotation = Tween(begin: -1.0 ,end: 1.0).animate(
        CurvedAnimation(parent: controller,curve: Interval(0.0, 0.25,curve: Curves.fastOutSlowIn))
      );
      //controller.forward();

    }

    @override
      void dispose() {
        controller.dispose(); 
        super.dispose();
      }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
          home: Scaffold(
          body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: FractionalOffset.bottomCenter,
              end: FractionalOffset.topCenter,
              colors: [Color(0xFF92FFC0),Color(0xFF32CCBC)]
            )
          ),
          //color: Colors.teal,
          child: ListView(
              children:<Widget>[ Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 40.0,
                  ),
                  AnimatedBuilder(
                    animation: controller,
                    builder: (BuildContext context, Widget child){
                      return GestureDetector(
                        onTap: (){
                        controller.repeat();

                       //controller.reverse();
                       },
                         child: RotationTransition(
                          turns: rotation,
                                                child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white
                          ),
                          child: Image.asset("assets/boy.png",
                          height: 120.0,),
                    ),
                        ),
                      );}
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text("Vineet Kishore",style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0
                  ),),
                SizedBox(
                  height: 20.0,
                ),
                Text("Flutter Developer and Designer",style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.0
                  ),),
                SizedBox(
                  height: 15.0,
                ),
                Text("Computer Science Engineer",style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.0
                  ),),
                SizedBox(
                  height: 30.0,
                ),
                ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Container(
                  height: 355.0,
                  width: 300.0,
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                    ListTile(
                      onTap: ()async => await _launchURL('vineetkishore01@gmail.com', 'Review about Wolfcry', 
                      'Replace with the content'),
                      leading: Icon(Icons.mail,color: Colors.black,),
                      title: Text("Email"),
                    ),
                    Divider(color: Colors.black,),
                    ListTile(
                      onTap: () => launch("https://www.quora.com/profile/Vineet-Kishore"),
                      leading: Image.asset("assets/quora.png", height: 34.0,
                      width: 20.0,),
                      title: Text("Quora"),
                    ),
                    Divider(color: Colors.black,),
                    ListTile(
                      onTap: ()async => await launch("https://github.com/SkullEnemyX"),
                      leading: Image.asset("assets/github.png",
                      height: 20.0,),
                      title: Text("Github"),
                    ),
                    Divider(color: Colors.black,),
                    ListTile(
                      onTap: ()async => await _launchURL('vineetkishore01@gmail.com', 'Review about Wolfcry', 
                      'Replace with the content'),
                      leading: Image.asset("assets/playstore.png",height: 20.0,),
                      title: Text("Google Play"),
                    ),
                    Divider(color: Colors.black,),
                    ListTile(
                      onTap: ()async => await launch("https://angel.co/vineet-kishore?al_content=view+your+profile&al_source=transaction_feed%2Fnetwork_sidebar"),
                      leading: Image.asset("assets/angel.jpg",
                      height: 30.0,),
                      title: Text("Angel List"),
                    ),
                    ],
                  ),
                ),
                ),
                ],
              ),
            ),]
          ),
        ),
      ),
    );
  }
}

class SearchNews extends SearchDelegate {
  var data;
  bool darkThemeEnabled;
  SearchNews({this.data,this.darkThemeEnabled});

  @override
  List<Widget> buildActions(BuildContext context) {
    //print(data);
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
    return data==null?Container(): ListView.builder(
      itemCount: data==null?0:suggestionList.length,
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
                author: data[index]["source"]["name"],
                darkThemeEnabled: darkThemeEnabled,
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
                    color: Colors.black,
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
