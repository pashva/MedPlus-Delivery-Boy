import 'package:flutter/material.dart';
import 'package:googlemaps/ordermodel.dart';


class Profile extends StatefulWidget {

  List<order> delist;
  Profile({this.delist});
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    double height=MediaQuery.of(context).size.height;
    double width=MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Delivered Items"),
      ),
      body: Container(
        child:ListView.builder(
            shrinkWrap: true,
            itemCount: widget.delist.length,
            itemBuilder: (BuildContext context,int index){
              return Padding(
                padding: const EdgeInsets.only(left: 50,right: 50,bottom: 30),
                child: Container(
                  margin: EdgeInsets.only(top: 20),
                  height: 150,
                  width: width*0.6,
                  child: Card(
                    elevation: 20,
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text("Name:"+widget.delist[index].username,style: TextStyle(
                              fontWeight: FontWeight.w800,

                            ),),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Text("Order:",style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 0.02347*height
                            ),),
                            FlatButton(
                                color: Colors.green,
                                onPressed: ()async {
                                  showDialog(context: context
                                      ,barrierDismissible: false,
                                      builder: (BuildContext context){
                                        return AlertDialog(
                                          actions: <Widget>[
                                            FlatButton(
                                              child: Text('Close'),
                                              onPressed: () {

                                                Navigator.pop(context);
                                              },
                                            ),
                                          ],
                                          title: Text(widget.delist[index].orderitems),

                                        );


                                      }
                                  );





                                }, child: Text("Items List",style: TextStyle(
                                color: Colors.white
                            ),)),
                            Text("Cost:"+widget.delist[index].cost.toString(),style: TextStyle(
                              fontWeight: FontWeight.w800,

                            ),)
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Text("Address:",style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 0.02347*height
                            ),),
                            FlatButton(
                                color: Colors.green,
                                onPressed: ()async {
                                  showDialog(context: context
                                      ,barrierDismissible: false,
                                      builder: (BuildContext context){
                                        return AlertDialog(
                                          actions: <Widget>[
                                            FlatButton(
                                              child: Text('Close'),
                                              onPressed: () {

                                                Navigator.pop(context);
                                              },
                                            ),
                                          ],
                                          title: Text(widget.delist[index].address),

                                        );


                                      }
                                  );





                                }, child: Text("Address",style: TextStyle(
                                color: Colors.white
                            ),))
                          ],
                        ),

                        Row(
                          children: <Widget>[
                            Text("Delivered"),
                            Icon(Icons.thumb_up,color: Colors.green,)
                          ],
                        )



                      ],
                    ),

                  ),
                ),
              );
            }
        ),
      ),
    );
  }
}
