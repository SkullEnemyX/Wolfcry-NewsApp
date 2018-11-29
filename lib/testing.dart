//  Future<bool> confirmDialog1(BuildContext context) {
//   return showDialog<bool>(
//       context: context,
//       barrierDismissible: true, // user must tap button!
//       builder: (BuildContext context) {
//         return new AlertDialog(
//           contentPadding: EdgeInsets.all(0.0),
//           content: Container(
//             decoration: BoxDecoration(
//               color: Colors.grey.shade800
//             ),
//             //width: 130.0,
//             //height: 300.0,
//             child: Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisSize: MainAxisSize.min,
//                 children: <Widget>[
//                   Center(
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(15.0),
//                        child: Image(
//                         image: AssetImage(
//                           "asset/logo.png",
//                         ),
//                         width: 100.0,
//                         height: 100.0,
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.only(
//                       top: 15.0
//                     ),
//                   ),
//                   Center(
//                     child: Text("Wolfcry",style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 30.0
//                     ),),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.only(bottom: 15.0),
//                   ),
                 
//                  RichText(
//                    text: TextSpan(
//                      children: [
//                        TextSpan(
//                          text: "Developer: ",style: TextStyle(
//                            fontSize: 15.0
//                          ),
//                        ),
//                       TextSpan(
//                         text: "Vineet Kishore",style: TextStyle(
//                           fontSize: 15.0,
//                           color: Colors.tealAccent
//                         )
//                       )
//                      ]
//                    ),
//                  ),
                  
//                   Text("\nCredits:",style: TextStyle(
//                     color: Colors.white,fontSize: 20.0),
//                   ),
//                   RichText(
//                     text: TextSpan(
//                       children: [
//                         TextSpan(
//                           text: "Samarth Agarwal: ",style: TextStyle(
//                             color: Colors.tealAccent,
//                             fontSize: 15.0
//                           ),
//                         ),
//                         TextSpan(
//                           text: "Loading Animation",style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 15.0
//                           ),),
//                         TextSpan(
//                           text: "\nNewsapi.org: ",style: TextStyle(
//                             color: Colors.tealAccent,
//                             fontSize: 15.0
//                           ),),
//                         TextSpan(
//                           text: "News Source",style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 15.0
//                           ),),
//                       ]
//                     ),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.symmetric(
//                       vertical: 30.0
//                     ),
//                   ),
//                   Center(
//                     child: Text("Made with ❤ in India",style: TextStyle(fontSize: 20.0,
//                       color: Colors.white
//                     ),),
//                   )
//                 ],
//               ),
//             ),
//           ),
          
//         );
//       });
// }