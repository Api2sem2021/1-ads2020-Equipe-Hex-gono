import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:no_name/bloc.navigation_bloc/navigation_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:no_name/screens/sidebar/Menu_Item.dart';

class Sidebar extends StatefulWidget {
  @override
  _SidebarState createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> with SingleTickerProviderStateMixin<Sidebar>{

  AnimationController _animationController;
  StreamController<bool> isSidebarOpenedStreamController;
  Stream<bool> isSidebarOpenedStream;
  StreamSink<bool>isSidebarOpenedSink;
  final bool isSidebarOpened = false;
  final _animationDuration = const Duration(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: _animationDuration);
    isSidebarOpenedStreamController = PublishSubject<bool>();
    isSidebarOpenedStream = isSidebarOpenedStreamController.stream; 
    isSidebarOpenedSink = isSidebarOpenedStreamController.sink;
  }

  @override
  void dispose() {
    _animationController.dispose();
    isSidebarOpenedStreamController.close();
    isSidebarOpenedSink.close();
    super.dispose();
  }

  void onIconPressed() {
    final animationStatus = _animationController.status;
    final isAnimationCompleted = animationStatus == AnimationStatus.completed;

    if (isAnimationCompleted){
      isSidebarOpenedSink.add(false);
      _animationController.reverse();
    }
    else {
      isSidebarOpenedSink.add(true);
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;

    return StreamBuilder<bool>(
      initialData: false,
      stream: isSidebarOpenedStream,
      builder: (context, isSidebarOpenedAsync){
        return AnimatedPositioned(
          duration: _animationDuration,
          top: 0,
          bottom: 0,
          left: isSidebarOpenedAsync.data? 0 : 0,
          right: isSidebarOpenedAsync.data? 0 : screenWidth - 45,
          child: Row(
            children: <Widget>[  
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  color: Color(0xDD000000),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 100,),
                      ListTile(
                        title: Text(
                          "Bárbara",
                          style: TextStyle(color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w800),
                        ),
                        subtitle: Text(
                          "barbara.port@outlook.com",
                          style: TextStyle(color: Colors.white12,
                          fontSize: 30,
                          fontWeight: FontWeight.w800),
                        ),
                        leading: CircleAvatar(
                          child: Icon(
                            Icons.perm_identity,
                            color: Colors.white,
                          ),
                          radius: 40,
                        ),
                      ),
                      Divider(
                        height: 64,
                        thickness: 0.5,
                        color: Colors.white.withOpacity(0.3),
                        indent: 32,   
                        endIndent: 32,
                      ),
                      MenuItem(
                        icon: Icons.home,
                        title: "Home",
                        onTap: () {
                          onIconPressed();
                          BlocProvider.of<NavigationBloc>(context).add(NavigationEvents.HomePageClickedEvent);
                        }
                      ),
                      MenuItem(
                        icon: Icons.person,
                        title: "Notifications",
                        onTap: () {
                          onIconPressed();
                          BlocProvider.of<NavigationBloc>(context).add(NavigationEvents.NotificationsClickedEvent);
                        }
                      ),
                      MenuItem(
                        icon: Icons.person,
                        title: "My profile",
                        onTap: () {
                          onIconPressed();
                          BlocProvider.of<NavigationBloc>(context).add(NavigationEvents.MyProfileClickedEvent);
                        }
                      ),
                      Divider(
                        height: 64,
                        thickness: 0.5,
                        color: Colors.white.withOpacity(0.3),
                        indent: 32,   
                        endIndent: 32,
                      ),
                      MenuItem(
                        icon: Icons.settings,
                        title: "Settings",
                        onTap: () {
                          onIconPressed();
                          BlocProvider.of<NavigationBloc>(context).add(NavigationEvents.HomePageClickedEvent);
                        }
                      ), 
                      MenuItem(
                        icon: Icons.settings,
                        title: "Log out",
                      ), 
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment(0, -0.9),
                child: GestureDetector(
                  onTap: (){
                    onIconPressed();
                  },
                  child: ClipPath(
                    clipper: CustomMenuClipper(),
                    child: Container(
                      width: 35,
                      height: 110,
                      color: Color(0xDD000000),
                      alignment: Alignment.centerLeft,
                      child: AnimatedIcon(
                        progress: _animationController.view,
                        icon: AnimatedIcons.menu_close,
                        color: Colors.white,
                        size: 25,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class CustomMenuClipper extends CustomClipper<Path>{
  @override
  Path getClip(Size size){
    Paint paint = Paint();
    paint.color = Colors.white;

    final width = size.width;
    final height = size.height;

    Path path = Path();
    path.moveTo(0, 0);
    path.quadraticBezierTo(0, 8, 10, 16);
    path.quadraticBezierTo(width -1, height / 2 - 20, width, height / 2);
    path.quadraticBezierTo(width + 1, height / 2, 10, height - 16);
    path.quadraticBezierTo(0, height - 8, 0, height);

    path.close();

    return null;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper){
    return true;
  }
}