import 'package:flutter/material.dart';
import 'package:social_downloader/constants.dart';

class HomeScreen extends StatefulWidget {
  static const id = 'HomeScreen';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Social Downloader'),
        centerTitle: true,
      ),
      body: Container(
        height: size.height,
        width: size.width,
        child: ListView.builder(
            padding: EdgeInsets.all(16.0),
            itemCount: ListSocialMedia.length,
            itemBuilder: (context, i) {
              return RaisedButton(
                textColor: Colors.white,
                color: ListSocialMedia[i]['color'],
                onPressed: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Image.asset(
                      ListSocialMedia[i]['icon'],
                      width: 24.0,
                      height: 24.0,
                      color: Colors.white,
                    ),
                    Text(ListSocialMedia[i]['title']),
                    SizedBox(
                      width: 8.0,
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
