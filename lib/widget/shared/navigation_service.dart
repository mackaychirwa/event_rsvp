import 'package:flutter/material.dart';
import 'global_verables.dart';


class NavigationService{
  void pushPage(Widget page) {
    var context=GlobalVariable.navState.currentContext;
    if(context!=null) {
      Navigator.push<Widget>(
          context, MaterialPageRoute(builder: (context) => page));
    }
  }

  Future pushPageByContext(BuildContext context,Widget page) async {
    await Navigator.push<Widget>(
        context, MaterialPageRoute(builder: (context) => page));
  }

  void bottomSheetByContext(BuildContext context,Widget page){
    showBottomSheet(context: context, builder: (context) => page);
  }

  void bottomSheet(Widget page){
    var context=GlobalVariable.navState.currentContext;
    if(context!=null) {
      showBottomSheet(context: context, builder: (context) => page);
    }
  }

  void popPageByContext(BuildContext context){
    Navigator.pop(context);
  }

  void popPage(){
    var context=GlobalVariable.navState.currentContext;
    if(context!=null) {
      Navigator.pop(context);
    }
  }

  Future pageSlideAnimation(BuildContext context, Widget page)async{
    var route= PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 1000),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        final offsetAnimation = animation.drive(tween);
        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );

    await Navigator.of(context).push(route);
  }
  Future pageSlideToRightAnimation(BuildContext context, Widget page) async{
    var route= PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 1000),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(-1,0);
        const end = Offset.zero;
        const curve = Curves.ease;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        final offsetAnimation = animation.drive(tween);
        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );

    await Navigator.of(context).push(route);
  }
}