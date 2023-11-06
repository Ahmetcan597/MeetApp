import 'package:rive/rive.dart';

class RiveAsset {
  final String artboard, stateMachineName, title, src;
  late SMIBool? input;

  RiveAsset(this.src,
      {required this.artboard,
        required this.stateMachineName,
        required this.title,
        this.input});

  set setInput(SMIBool status) {
    input = status;
  }
}


List<RiveAsset> sideMenus = [
  RiveAsset("assets/riveassets/icons.riv", artboard: "HOME", stateMachineName: "HOME_interactivity", title: "Home"),
  RiveAsset("assets/riveassets/icons.riv", artboard: "SEARCH", stateMachineName: "SEARCH_interactivity", title: "Your Services"),
  RiveAsset("assets/riveassets/icons.riv", artboard: "LIKE/STAR", stateMachineName: "STAR_interactivity", title: "Favorites"),
  RiveAsset("assets/riveassets/icons.riv", artboard: "CHAT", stateMachineName: "CHAT_interactivity", title: "Your Chats"),
];