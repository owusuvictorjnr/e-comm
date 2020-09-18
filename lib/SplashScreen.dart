import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'LogInScreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SplashScreen();
  }
}
class _SplashScreen extends State<SplashScreen> {
  @override
  void initState(){
    super.initState();
    NavigateToLogin();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    MyImage(),
                    Text(
                      'Amansan Store',
                      style: TextStyle(
                          fontSize: 23,
                          fontStyle: FontStyle.italic,
                          color: Colors.white),
                    )
                  ],
                )),
            Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(),
                    SizedBox(height: 20,),
                    Text(
                      'Online Store For Everyone',
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 12,
                          color: Colors.white),
                    )
                  ],
                )),
          ],
        ),
      ),
    );
  }

//Navigating to login screen
void NavigateToLogin(){
  //BuildContext context;
  Timer(Duration(seconds: 5), ()=> Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (BuildContext context)=> LogInScreen())
  ));

  @override
  void initState(){
    super.initState();
    NavigateToLogin();
  }
}


}



class MyImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AssetImage image = new AssetImage('images/pic6.png');
    Image logo = new Image(
      image: image,
      width: 200,
      height: 200,
    );
    return logo;
  }
}
