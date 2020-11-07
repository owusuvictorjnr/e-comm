import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class PolicyDialog extends StatelessWidget {
  PolicyDialog({
    Key key,
    this.radius = 28,
    @required this.mdFileName,
  })  : assert(mdFileName.contains('.md'), 'The file must contain the .md extension'),
        super(key: key);

  final double radius;
  final String mdFileName;

  // ===> THIS FUNCTION IS SPINKIT FOR THE SPIN <===
  final spinkit = SpinKitHourGlass(
    color: Color(0xff706695),
    size: 50.0,
  );

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
      child: Container(
        height: 350,
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                future: Future.delayed(Duration(milliseconds: 150)).then((value) {
                  return rootBundle.loadString('assets/$mdFileName');
                }),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Markdown(
                      data: snapshot.data,
                    );
                  }
                  return Center(
                    child: spinkit,
                  );
                },
              ),
            ),
            FlatButton(
              padding: EdgeInsets.all(0),
              //color: Theme.of(context).buttonColor,
              // color:  Color(0xFF008ECC),
              color: Color(0xff706695),
              onPressed: () => Navigator.of(context).pop(),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(radius),
                  bottomRight: Radius.circular(radius),
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(radius),
                    bottomRight: Radius.circular(radius),
                  ),
                ),
                alignment: Alignment.center,
                height: 50,
                width: double.infinity,
                child: Text(
                  "CLOSE",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    //color: Theme.of(context).textTheme.button.color,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}