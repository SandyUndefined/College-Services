import 'package:college_services/pages/profile.dart';
import 'package:flutter/material.dart';
import 'package:college_services/services/usermanagement.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HomePage'),
      ),
      body: ListPage(),
    );
  }
}

class DetailPage extends StatefulWidget {
  final DocumentSnapshot post;
  final String uid;
  
  DetailPage({this.post,this.uid});
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  String userID;

  navigateToProfile(){
    print(widget.uid);
    userID = widget.uid;
    Navigator.push(context, MaterialPageRoute( builder:(context) => Profile(userID: userID,)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.post.data["Name"],
        ),
      ),
      body: Container(
        child: Card(
          elevation: 4,
          child:Padding(
            padding: EdgeInsets.only(left:10.0,top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new Row(
                  children: <Widget>[
                    InkWell(
                      onTap: () => navigateToProfile(),
                      child: Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(widget.post.data["User Pic"]),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(50.5)),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: EdgeInsets.only(left: 25,right: 15),
                        child: Text(widget.post.data["Description"],style: TextStyle(fontSize: 16),),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(left: 75,top: 5),
                  child: Text(DateFormat.yMMMd().add_jm().format(DateTime.parse(widget.post.data["Creation Time"].toDate().toString())),style: TextStyle(color: Colors.black38,fontSize: 12),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 75,top: 35,bottom: 8),
                  child: Text(widget.post.data.length.toString()+"Files uploaded",style: TextStyle(color: Colors.blueAccent,fontSize: 14,fontStyle: FontStyle.italic),),
                ),
                Divider(),
                new Row(
                  children: <Widget>[
                    Padding(
                      padding:EdgeInsets.only(left: 5),
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.favorite_border,
                            color: Colors.redAccent, size: 23.0),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 65),
                      child:IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.chat_bubble_outline,
                          color: Colors.blue,size: 23.0,),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 75),
                      child:IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.near_me,
                          color: Colors.blue,size: 23.0,),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {

  Future _data;

  @override
  void initState() {
    super.initState();
    _data = UserManagement().getPosts();
  }

  navigateToDetail(DocumentSnapshot post,String uid){
    Navigator.push(context, MaterialPageRoute( builder:(context) => DetailPage(post: post,uid: uid,)));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: _data,
          builder: (_,snapshot){
       if(snapshot.connectionState == ConnectionState.waiting){
        return Center(child: CircularProgressIndicator(),);
       }
       else
         {
           return ListView.builder(itemCount:snapshot.data.length,
               itemBuilder: (_,index){
                 return Card(
               elevation: 4,
               child:Padding(
                 padding: EdgeInsets.only(left:10.0,top: 10),
               child: InkWell(
                 onTap: () => navigateToDetail(snapshot.data[index],snapshot.data[index].data["Userid"],),
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   mainAxisSize: MainAxisSize.min,
                   children: <Widget>[
                     new Row(
                       children: <Widget>[
                         Container(
                           width: 45,
                           height: 45,
                   decoration: BoxDecoration(
                             image: DecorationImage(
                               image: NetworkImage(snapshot.data[index].data["User Pic"]),
                                fit: BoxFit.cover,
                             ),
                             borderRadius: BorderRadius.all(Radius.circular(50.5)),
                           ),
                         ),
                         Padding(
                           padding:  EdgeInsets.only(left:15),
                           child: Text(snapshot.data[index].data["Name"],style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18),),
                         ),
                         ],
                     ),
                     Padding(
                       padding: EdgeInsets.only(left: 60,bottom: 10),
                       child: Text(DateFormat.yMMMd().add_jm().format(DateTime.parse(snapshot.data[index].data["Creation Time"].toDate().toString())),style: TextStyle(color: Colors.black38,fontSize: 12),),

                     ),
                     Flexible(
                     child:Padding(
                       padding: EdgeInsets.only(left: 75,right: 15),
                       child: Text(snapshot.data[index].data["Description"],style: TextStyle(fontSize: 16),),
                     ),
                     ),
                     Padding(
                       padding: EdgeInsets.only(left: 75,top: 15,bottom: 8),
                       child: Text(snapshot.data.length.toString()+"Files uploaded",style: TextStyle(color: Colors.blueAccent,fontSize: 14,fontStyle: FontStyle.italic),),
                     ),
                     Divider(),
                     new Row(
                       children: <Widget>[
                         Padding(
                           padding:EdgeInsets.only(left: 5),
                           child: IconButton(
                             onPressed: () {},
                             icon: Icon(Icons.favorite_border,
                                 color: Colors.redAccent, size: 23.0),
                           ),
                         ),
                         Padding(
                           padding: EdgeInsets.only(left: 65),
                            child:IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.chat_bubble_outline,
                              color: Colors.blue,size: 23.0,),
                            ),
                         ),
                         Padding(
                           padding: EdgeInsets.only(left: 75),
                           child:IconButton(
                             onPressed: () {},
                             icon: Icon(Icons.near_me,
                               color: Colors.blue,size: 23.0,),
                           ),
                         ),
                       ],
                     ),
                   ],
                 ),
               ),
               ),
             );
           });
         }
      }),
    );
  }
}


