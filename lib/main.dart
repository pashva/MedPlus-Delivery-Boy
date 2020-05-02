import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:googlemaps/ordermodel.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'floatingpaint.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DeliveryBoy',
      home: FirstPage(),
    );
  }
}

// ignore: must_be_immutable
class MyHomePage extends StatefulWidget {
  
  MyHomePage(this.text);
  String text;
  List<Marker> allmarkers = [];
  List<double> latlng = [];
  List<Placemark> placemark = [];

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

Future<List> getorders() async {
  List<order> x = [];

  final String url = "https://owaismedplus.herokuapp.com/orders";
  var response = await http.post(url,
      headers: {
        "Accept": "application/json",
        "Content-type": "application/json",
      },
      body: json.encode({}));

  var res = json.decode(response.body);
  print(res[1][0]);
  for (int i = 0; i < res[0]; i++) {
    x.add(order(
        username: res[1][i]["name"],
        cost: res[1][i]["cost"],
        orderitems: res[1][i]["items"],
        address: res[1][i]["address"],
        id: res[1][i]["id"],
        contact: res[1][i]["contact"],
        ptype: res[1][i]["payment-type"]));
  }
  print(x);
  return x;
}

Future<List> done(int id) async {
  final String url = "https://owaismedplus.herokuapp.com/complete";
  var response = await http.post(url,
      headers: {
        "Accept": "application/json",
        "Content-type": "application/json",
      },
      body: json.encode({"id": id}));
}

var address = new TextEditingController();

class _MyHomePageState extends State<MyHomePage> {
  GoogleMapController mapController;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
        body: Stack(
      children: <Widget>[
        GoogleMap(
          markers: Set.from(widget.allmarkers),
          onMapCreated: onMapCreated,
          initialCameraPosition:
              CameraPosition(target: LatLng(40.7128, -74.0060), zoom: 10.0),
        ),
        Positioned(
          bottom: 0,
          left: width * 0.38,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              FlatButton(
                  color: Colors.blue,
                  onPressed: () async {
                    List<Placemark> placemark =
                        await Geolocator().placemarkFromAddress(widget.text);
                    setState(() {
                      widget.allmarkers.add(Marker(
                          markerId: MarkerId("mymarkrt"),
                          draggable: false,
                          position: LatLng(placemark[0].position.latitude,
                              placemark[0].position.longitude)));
                    });
                  },
                  child: Text("MARK")),
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        ),
        Positioned(
          top: 30.0,
          right: 15.0,
          left: 15.0,
          child: Container(
            height: 50.0,
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0), color: Colors.white),
            child: TextField(
              controller: address,
              decoration: InputDecoration(
                  hintText: 'Enter Address',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
                  suffixIcon: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: searchandNavigate(widget.text),
                      iconSize: 30.0)),
            ),
          ),
        )
      ],
    ));
  }

  searchandNavigate(String text) {
    Geolocator().placemarkFromAddress(text).then((result) {
      mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target:
              LatLng(result[0].position.latitude, result[0].position.longitude),
          zoom: 86.0)));
      widget.latlng[0] = result[0].position.latitude;
      widget.latlng[1] = result[0].position.longitude;
    });
  }

  void onMapCreated(controller) {
    setState(() {
      mapController = controller;
    });
  }
}

class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  Firestore _firestore = Firestore.instance;
  Location location = Location();
  List<order> delist = [];
  List<order> x = [];
  GlobalKey _key = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(60),
                  bottomLeft: Radius.circular(60)),
              color: Colors.green),
          height: height * 0.5,
          width: width,
        ),
        Container(
          height: height,
          width: width,
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: x.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding:
                      const EdgeInsets.only(left: 50, right: 50, bottom: 30),
                  child: Container(
                    margin: EdgeInsets.only(top: 20),
                    height: 250,
                    width: width * 0.6,
                    child: Card(
                      elevation: 20,
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Name:" + x[index].username.toUpperCase(),
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Contact no :" + x[index].contact.toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Payment type :" + x[index].ptype.toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                "Order:",
                                style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 0.02347 * height),
                              ),
                              FlatButton(
                                  color: Colors.green,
                                  onPressed: () async {
                                    showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            actions: <Widget>[
                                              FlatButton(
                                                child: Text('Close'),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ],
                                            title: Text(x[index].orderitems),
                                          );
                                        });
                                  },
                                  child: Text(
                                    "Items List",
                                    style: TextStyle(color: Colors.white),
                                  )),
                              Text(
                                "Cost:" + x[index].cost.toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                ),
                              )
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                "Address:",
                                style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 0.02347 * height),
                              ),
                              FlatButton(
                                  color: Colors.green,
                                  onPressed: () async {
                                    showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            actions: <Widget>[
                                              FlatButton(
                                                child: Text('Close'),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ],
                                            title: Text(x[index].address),
                                          );
                                        });
                                  },
                                  child: Text(
                                    "Address",
                                    style: TextStyle(color: Colors.white),
                                  )),
                            ],
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(20)),
                            child: IconButton(
                                icon: Icon(
                                  Icons.location_on,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  location.onLocationChanged.listen((currentloc) async {
                                    
                                    List<Placemark> userloc=await Geolocator().placemarkFromAddress(x[index].address);
                                    
                                    

                                    double distance=await Geolocator().distanceBetween(currentloc.latitude, currentloc.longitude, userloc[0].position.latitude, userloc[0].position.longitude);
                                    await _firestore.collection("Location").document("delLoc").setData({
                                      "latitude":currentloc.latitude,
                                      "longitude":currentloc.longitude,
                                      "distance":distance
                                    });
                                   });
                                  
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              MyHomePage(x[index].address)));
                                }),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              FlatButton(
                                  color: Colors.lightGreen,
                                  onPressed: () async {
                                    showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            actions: <Widget>[
                                              FlatButton(
                                                child: Text('Yes'),
                                                onPressed: () async {
                                                  delist.add(order(
                                                      orderitems:
                                                          x[index].orderitems,
                                                      cost: x[index].cost,
                                                      username:
                                                          x[index].username,
                                                      address:
                                                          x[index].address));
                                                  await done(x[index].id);

                                                  await x.removeAt(index);
                                                  setState(() {});
                                                  Navigator.pop(context);
                                                },
                                              ),
                                              FlatButton(
                                                child: Text('No'),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ],
                                            title: Text(
                                                "Confirmation: Is the item delivered?"),
                                          );
                                        });
                                  },
                                  child: Text(
                                    "Delivered",
                                    style: TextStyle(color: Colors.white),
                                  )),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }),
        ),
        Positioned(
            bottom: 20,
            right: 20,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.green, borderRadius: BorderRadius.circular(20)),
              child: IconButton(
                  icon: Icon(
                    Icons.assignment_ind,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Profile(
                                  delist: delist,
                                )));
                  }),
            )),
        Positioned(
            bottom: 20,
            left: 20,
            child: Container(
              color: Colors.green,
              child: FlatButton(
                  onPressed: () async {
                    print("tapped");
                    List l = await getorders();
                    setState(() {
                      x = l;
                    });
                  },
                  child: Text("New Orders")),
            )),
      ],
    ));
  }
}

// ignore: must_be_immutable
class Home extends StatefulWidget {
  Home(this.lat, this.long);
  double lat;
  double long;
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Completer<GoogleMapController> _controller = Completer();
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  String searchAddr;
  List<Marker> allmarkers = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            initialCameraPosition: _kGooglePlex,
            markers: Set.from(allmarkers),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: FlatButton(
                      onPressed: () {
                        getposi(widget.lat, widget.long);
                      },
                      child: Text(
                        "Go to the user location",
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<void> getposi(double lat, double long) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        bearing: 192.8334901395799,
        target: LatLng(lat, long),
        tilt: 59.440717697143555,
        zoom: 19.151926040649414)));

    setState(() {
      allmarkers.add(Marker(
          markerId: MarkerId("mymarkrt"),
          draggable: false,
          position: LatLng(lat, long)));
    });
  }
}
