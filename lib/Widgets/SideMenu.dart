import 'package:appoflutter/ChatsScreen.dart';
import 'package:appoflutter/Entry_Point.dart';
import 'package:appoflutter/FavoritesScreen.dart';
import 'package:appoflutter/MainScreen.dart';
import 'package:appoflutter/Models/RiveAssets.dart';
import 'package:appoflutter/YourServicesScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_route_transition/page_route_transition.dart';
import 'package:rive/rive.dart';
import 'SideMenuTile.dart';
import 'InfoCard.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {

  RiveAnimationController? animationController;
  RiveAsset selectedMenu = sideMenus.first;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 288,
        height: double.infinity,
        color: const Color(0xFF06283D),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InfoCard(name: "Ahmetcan Temel",profession: "Engineer",),
              Padding(
                padding: const EdgeInsets.only(left: 24,top: 32,bottom: 16),
                child: Text("BROWSE",style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white70),),
              ),
              ...sideMenus.map((menu) => SideMenuTile(
                menu: menu,
                riveonInit: (artboard) {

                },
                press: () {
                  setState(() {
                    selectedMenu = menu;
                  });
                  switch(menu.title){
                    case "Your Services":{
                      PageRouteTransition.effect = TransitionEffect.fade;
                      PageRouteTransition.push(context, const EntryPoint(screen: YourServicesScreen(),));
                    }
                    break;
                    case "Home":{
                      PageRouteTransition.effect = TransitionEffect.fade;
                      PageRouteTransition.push(context, const EntryPoint(screen: MainScreen(),));
                    }
                    break;
                    case "Favorites":{
                      PageRouteTransition.effect = TransitionEffect.fade;
                      PageRouteTransition.push(context, const EntryPoint(screen: FavoritesScreen(),));
                    }
                    break;
                    case "Your Chats":{
                      PageRouteTransition.effect = TransitionEffect.fade;
                      PageRouteTransition.push(context, const EntryPoint(screen: ChatsScreen(),));
                    }
                    break;
                  }
                },
                isActive: selectedMenu == menu,
              )),
            ],
          ),
        ),
      ),
    );
  }
}
