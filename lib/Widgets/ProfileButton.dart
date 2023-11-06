import 'package:appoflutter/Entry_Point.dart';
import 'package:appoflutter/ProfileScreen.dart';
import 'package:flutter/material.dart';
import 'package:page_route_transition/page_route_transition.dart';

class ProfileButton extends StatefulWidget {
  const ProfileButton({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfileButton> createState() => _ProfileButtonState();
}

class _ProfileButtonState extends State<ProfileButton> with SingleTickerProviderStateMixin {

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.50).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTapDown: (_) {
            _animationController.forward();
          },
          onTapUp: (_) {
            _animationController.reverse();
            PageRouteTransition.effect = TransitionEffect.fade;
            PageRouteTransition.push(context, const EntryPoint(screen: ProfileScreen(),));
          },
          onTapCancel: () {
            _animationController.reverse();
          },
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: child,
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('images/profileicon.png'),
                ],
              ),
            ),
          ),
        ),
        const Text(
          "Profile",
          style: TextStyle(
            fontFamily: "ChalkBold",
            fontSize: 15,
            color: Color(0xFF707070),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
