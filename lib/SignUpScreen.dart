import './LogInScreen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignUpScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SignUpScreen();
  }


}

class _SignUpScreen extends State<SignUpScreen>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      //we changed the column to listview
      body: ListView(
        children: <Widget>[
          //The login begins from here
          Container(
            width: double.infinity,
            height: 180,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 50,
                  ),
                  Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                  Text(
                    'Welcome to our store',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  )
                ],
              ),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(150),
              ),
              color: Colors.pinkAccent,
            ),
          ),

          //User Name widget
          Theme(
              data: ThemeData(hintColor: Colors.blue),
              child: Padding(
                padding: EdgeInsets.only(top: 10, right: 20, left: 20),
                child: TextField(
                  style: TextStyle(color: Colors.black54), //text color
                  decoration: InputDecoration(
                    labelText: 'User Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                      BorderSide(color: Colors.pinkAccent, width: 1),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                      BorderSide(color: Colors.pinkAccent, width: 1),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                      BorderSide(color: Colors.pinkAccent, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                      BorderSide(color: Colors.pinkAccent, width: 1),
                    ),
                  ),
                ),
              )),

          //Email widget
          Theme(
            data: ThemeData(hintColor: Colors.blue),
            child: Padding(
              padding: EdgeInsets.only(top: 10, right: 20, left: 20),
              child: TextField(
                style: TextStyle(color: Colors.black54),
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.pinkAccent, width: 1),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.pinkAccent, width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.pinkAccent, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.pinkAccent, width: 1),
                  ),
                ),
              ),
            ),
          ),

          //Password container
          Theme(
            data: ThemeData(hintColor: Colors.blue),
            child: Padding(
              padding: EdgeInsets.only(top: 10, right: 20, left: 20),
              child: TextField(
                style: TextStyle(color: Colors.black54),
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.pinkAccent, width: 1),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.pinkAccent, width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.pinkAccent, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.pinkAccent, width: 1),
                  ),
                ),
              ),
            ),
          ),

//          Padding(padding: EdgeInsets.only(right: 20),
//            child: Container(
//              width: double.infinity,
//              child: Text(
//                'Forgot password?',
//                style: TextStyle(color: Colors.pinkAccent),
//                textAlign: TextAlign.right,
//              ),
//            ),
//          ),
          SizedBox(
            height: 10,
          ),

          //log in widget
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: RaisedButton(
              onPressed: () {},
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              color: Colors.pinkAccent,
              child: Text(
                'Sign Up',
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              padding: EdgeInsets.all(10),
            ),
          ),

          SizedBox(
            height: 10,
          ),
          Container(
            width: double.infinity,
            height: 1,
            color: Colors.blue,
          ),

          //Google sign in container
          Padding(
            padding: EdgeInsets.only(top: 15, right: 20, left: 20),
            child: RaisedButton(
              onPressed: () {},
              color: Colors.white,
              padding: EdgeInsets.all(10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Row(
                children: <Widget>[
                  Icon(
                    FontAwesomeIcons.google,
                    color: Colors.pink,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Sign up with google',
                    style: TextStyle(fontSize: 20, color: Colors.pink),
                  )
                ],
              ),
            ),
          ),

          //Facebook sign in widget
          Padding(
            padding: EdgeInsets.only(top: 15, right: 20, left: 20),
            child: RaisedButton(
              onPressed: () {},
              color: Colors.white,
              padding: EdgeInsets.all(10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Row(
                children: <Widget>[
                  Icon(
                    FontAwesomeIcons.facebook,
                    color: Colors.blue,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Sign up with facebook',
                    style: TextStyle(fontSize: 20, color: Colors.blue),
                  )
                ],
              ),
            ),
          ),

          SizedBox(
            height: 10,
          ),

          Center(
            child: Column(
              children: <Widget>[
                Text(
                  'You already have an account?',
                  style: TextStyle(color: Colors.pinkAccent),
                ),

                //Registration text
                SizedBox(
                  height: 5,
                ),

                FlatButton(
                    onPressed: (){
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (BuildContext context)=> LogInScreen())
                      );

                    },
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Log In',
                          style: TextStyle(color: Colors.blue),
                        ),



                        Container(
                          width: 45,
                          height: 1,
                          color: Colors.blue,
                        ),
                      ],
                    )

                )

              ],
            ),

            //Registration widget
          )
        ],
      ),
    );
  }

}
