import 'package:example/delaunay_experiment.dart';
import 'package:example/menger_sponge.dart';
import 'package:flutter/material.dart';

import 'clock.dart';
import 'painter.dart';
import 'stars.dart';
import '3d_cube.dart';

void pushPage(BuildContext context, Widget page) {
  Navigator.of(context).pop();
  Navigator.of(context).push(MaterialPageRoute(builder: (context) => page));
}

List<Widget> _screens(BuildContext context) {
  return [
    ListTile(
      title: Text("Animated clock"),
      onTap: () => pushPage(context, Clock()),
    ),
    ListTile(
      title: Text("Canvas painter"),
      onTap: () => pushPage(context, Painter()),
    ),
    ListTile(
      title: Text("Stars"),
      onTap: () => pushPage(context, Stars()),
    ),
    ListTile(
      title: Text("3D cube"),
      onTap: () => pushPage(context, ThreeDCube()),
    ),
    ListTile(
      title: Text("Menger sponge"),
      onTap: () => pushPage(context, MengerSponge()),
    ),
    ListTile(
      title: Text("Delaunay experiment"),
      onTap: () => pushPage(context, DelaunayExperiment()),
    )
  ];
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("P5 examples"),
        centerTitle: true,
      ),
      drawer: Drawer(
          child: ListView.separated(
        itemBuilder: (context, index) {
          return _screens(context)[index];
        },
        itemCount: _screens(context).length,
        separatorBuilder: (context, index) => Divider(),
      )),
      body: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "P5 API examples",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    letterSpacing: .1),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "You can find all the examples in the app drawer . This technology is powered by the Open source community",
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              )
            ],
          )),
    );
  }
}
