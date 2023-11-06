import 'package:appoflutter/Widgets/ContactWidget.dart';
import 'package:appoflutter/Widgets/ProfileButton.dart';
import 'package:appoflutter/Widgets/TopSide.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:like_button/like_button.dart';

import 'Widgets/CommentsWidget.dart';

class BusinessScreen extends StatefulWidget {
  const BusinessScreen({Key? key}) : super(key: key);

  @override
  State<BusinessScreen> createState() => _BusinessScreenState();
}

class _BusinessScreenState extends State<BusinessScreen> {

  Future<bool> onLikeButtonTapped(bool isLiked) async{
    /// send your request here
    // final bool success= await sendRequest();

    /// if failed, you can do nothing
    // return success? !isLiked:isLiked;

    return !isLiked;
  }

  //TODO Basliki kisalt
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xFFEAFDFC),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(height: 8,),
              TopSide(),
              Container(height: 8,),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: const Color(0xFFBFEAF5),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: Image.asset(
                        "images/barberpng.png",
                        height: 156,
                        width: 380,
                      ),
                    ),
                    Row(
                      children: [
                        Padding(padding: const EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.white,
                            backgroundImage: NetworkImage("https://monteluke.com.au/wp-content/gallery/linkedin-profile-pictures/9.JPG"),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Ceylin Isik",style: TextStyle(fontFamily: "ChalkBold",fontSize: 20,color: Color(0xFF707070)),textAlign: TextAlign.start,),
                            Text("Barber",style: TextStyle(fontFamily: "ChalkBoldRe",fontSize: 12,color: Color(0xFF707070)),textAlign: TextAlign.start,),
                            Container(
                              width: 140,
                                child: Text("LoremLoremLoremLoremLoremLoremLoremLoremLoremLoremLoremLoremLoremLoremLoremLoremLoremLoremLoremLoremLoremLoremLorem",style: TextStyle(fontFamily: "ChalkBoldRe",fontSize: 8,color: Color(0xFF707070)),textAlign: TextAlign.start,)),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Container(
                                  width: 130,
                                  child: RatingBar.builder(
                                    initialRating: 3,
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    itemSize: 17,
                                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                    itemBuilder: (context, _) => Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    onRatingUpdate: (rating) {
                                      print(rating);
                                    },
                                  ),
                                ),
                              ),
                              Text("Did 7 Jobs",style: TextStyle(fontFamily: "ChalkBold",fontSize: 12,color: Color(0xFF707070)),textAlign: TextAlign.start,),
                              LikeButton(onTap: onLikeButtonTapped,),
                              Text("Add to Favorites",style: TextStyle(fontFamily: "ChalkBold",fontSize: 8,color: Color(0xFF707070)),textAlign: TextAlign.start,),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Text("Photos",style: TextStyle(fontFamily: "ChalkBold",fontSize: 20,color: Color(0xFF707070)),textAlign: TextAlign.start,),
                    ),
                    CarouselSlider(
                      options: CarouselOptions(
                        height: 200,
                        aspectRatio: 16/9,
                        viewportFraction: 1,
                        initialPage: 0,
                        enableInfiniteScroll: true,
                        reverse: false,
                        autoPlay: false,
                        autoPlayInterval: Duration(seconds: 3),
                        autoPlayAnimationDuration: Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enlargeCenterPage: true,
                        enlargeFactor: 0.3,
                        scrollDirection: Axis.horizontal,
                      ),
                      items: [1,2,3,4,5].map((i) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 352,
                                  height: 200,
                                  //margin: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.amber,
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      }).toList(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8,left: 20.0),
                      child: Text("Services",style: TextStyle(fontFamily: "ChalkBold",fontSize: 20,color: Color(0xFF707070)),textAlign: TextAlign.start,),
                    ),
                    Container(
                      width: 370,
                      height: 90,
                      child: ListView.builder(
                        itemCount: 3,
                        itemBuilder: (BuildContext context, int index){
                          return Center(
                            child: Container(
                              width: 350,
                              height: 40,
                              margin: EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5), // Shadow color
                                      spreadRadius: 1, // Spread radius
                                      blurRadius: 2, // Blur radius
                                      offset: const Offset(0, 3),
                                    )
                                  ],
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white
                              ),
                              child: Center(child: Text("Hair Cut = 100TL $index",style: TextStyle(fontFamily: "ChalkBold",fontSize: 20,color: Color(0xFF707070)))),
                            ),
                          );
                        }
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8,left: 20.0),
                      child: Text("Comments",style: TextStyle(fontFamily: "ChalkBold",fontSize: 20,color: Color(0xFF707070)),textAlign: TextAlign.start,),
                    ),
                    Center(
                      child: Container(
                        width: 340,
                        height: 120,
                        child: ListView.builder(
                            itemCount: 3,
                            itemBuilder: (BuildContext context, int index){
                              return CommentsWidget();
                            }
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8,left: 20.0),
                      child: Text("Location",style: TextStyle(fontFamily: "ChalkBold",fontSize: 20,color: Color(0xFF707070)),textAlign: TextAlign.start,),
                    ),
                    Center(
                      child: Container(
                        width: 340,
                        height: 160,
                        child: Center(
                          child: Container(
                            width: 210,
                            height: 85,
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5), // Shadow color
                                    spreadRadius: 1, // Spread radius
                                    blurRadius: 2, // Blur radius
                                    offset: const Offset(0, 3),
                                  )
                                ],
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white
                            ),
                            child: Column(
                              children: [
                                Image.asset("images/bluelocation.png",),
                                Text("Click To See The Location",style: TextStyle(fontFamily: "ChalkBold",fontSize: 16,color: Color(0xFF707070)),textAlign: TextAlign.start,),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8,left: 20.0,bottom: 8),
                      child: Text("Working Hours",style: TextStyle(fontFamily: "ChalkBold",fontSize: 20,color: Color(0xFF707070)),textAlign: TextAlign.start,),
                    ),
                    Center(
                      child: Container(
                        width: 350,
                        height: 70,
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5), // Shadow color
                                spreadRadius: 1, // Spread radius
                                blurRadius: 2, // Blur radius
                                offset: const Offset(0, 3),
                              )
                            ],
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text("MidWeek 09:00-21:00",style: TextStyle(fontFamily: "ChalkBoldRe",fontSize: 16,color: Color(0xFF707070)),textAlign: TextAlign.start,),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8,left: 20.0,bottom: 8),
                      child: Text("Contact",style: TextStyle(fontFamily: "ChalkBold",fontSize: 20,color: Color(0xFF707070)),textAlign: TextAlign.start,),
                    ),
                    ContactWidget(text:"Phone Number: 05455837162"),
                    ContactWidget(text:"Email: ahmetcantemel59@gmail.com"),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          //TODO BU iki containeri kisaltabilirsin birde bunlar gesture detector yap
                          Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(bottom: 5),
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5), // Shadow color
                                      spreadRadius: 1, // Spread radius
                                      blurRadius: 2, // Blur radius
                                      offset: const Offset(0, 3),
                                    )
                                  ],
                                  color: Colors.white,
                                  shape: BoxShape.circle
                                ),
                                child: Center(child: Image.asset("images/chaticonblue.png",)),
                              ),
                              Text("Start Chat",style: TextStyle(fontFamily: "ChalkBold",fontSize: 20,color: Color(0xFF707070)),textAlign: TextAlign.start,),
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(bottom: 5),
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5), // Shadow color
                                        spreadRadius: 1, // Spread radius
                                        blurRadius: 2, // Blur radius
                                        offset: const Offset(0, 3),
                                      )
                                    ],
                                    color: Colors.white,
                                    shape: BoxShape.circle
                                ),
                                child: Center(child: Image.asset("images/editiconblue.png",)),
                              ),
                              Text("Edit",style: TextStyle(fontFamily: "ChalkBold",fontSize: 20,color: Color(0xFF707070)),textAlign: TextAlign.start,),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(height: 20,)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
