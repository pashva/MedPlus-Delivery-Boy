//ListView.builder(
//itemCount: x.length,
//
//itemBuilder: (BuildContext context,int index){
//return SingleChildScrollView(
//child: Column(
//children: <Widget>[
//Card(
//child: Column(
//children: <Widget>[
//Row(
//
//children: <Widget>[
//Container(
//child: SingleChildScrollView(
//child: Column(
//children: <Widget>[
////Card(
//child: Text("Order:"+x[index].orderitems,style: TextStyle(
//fontWeight: FontWeight.w900,
//fontSize: 0.02347*height
//),),
//elevation: 6,
//),
//],
//),
//),
//height: 0.02347*4*height,
//width: 0.2347*height,
//),
//
//Container(
//child: SingleChildScrollView(
//child: Column(
//children: <Widget>[
//Card(
//elevation: 6,
//child: Text("Cost:"+x[index].cost,style: TextStyle(
//fontWeight: FontWeight.w900,
//fontSize: 0.02347*height
//),),
//),
//],
//),
//),
//height: 0.02347*4*height,
//width: 0.2347*height,
//)
//],
//),
//FloatingActionButton(
//heroTag: "lol"+"$index",
//onPressed: (){
//Navigator.push(context, MaterialPageRoute(builder: (context)=>MyHomePage(x[index].address)));
//},
//child: Icon(Icons.shopping_cart,size: 34,color: Colors.white,),
//),
//Container(
//child: SingleChildScrollView(
//child: Column(
//children: <Widget>[
//Text("Name :"+x[index].username,style: TextStyle(
//fontWeight: FontWeight.w900,
//fontSize: 0.02347*height
//),),
//Text("Address :"+x[index].address,style: TextStyle(
//fontWeight: FontWeight.w900,
//fontSize: 0.02347*height
//),),
//
//],
//),
//),
//height: 0.02347*4*height,
//width: 0.2347*height,
//),
//],
//),
//),
//Row(
//mainAxisAlignment: MainAxisAlignment.start,
//children: <Widget>[
//FlatButton(
//color: Colors.orangeAccent,
//onPressed: (){
//x.removeAt(index);
//setState(() {
//
//});
//
//}, child: Text("Delivered",style: TextStyle(
//fontSize: 0.02347*height
//),))
//
//],
//)
//],
//),
//);
//}));