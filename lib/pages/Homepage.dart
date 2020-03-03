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
  DetailPage({this.post});
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       title: Text(widget.post.data["Name"]),
      ),
      body: Container(
        child: Card(
          child: ListTile(
            title: Text(widget.post.data["Name"]),
            subtitle: Text(widget.post.data["Description"]),
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

  navigateToDetail(DocumentSnapshot post){
    Navigator.push(context, MaterialPageRoute( builder:(context) => DetailPage(post: post,)));
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
                 padding: EdgeInsets.all(15.0),
               child: InkWell(
                 onTap: () => navigateToDetail(snapshot.data[index]),
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
                               image: AssetImage('assets/images/user_upload.png'),
                                fit: BoxFit.cover,

                             ),
                             borderRadius: BorderRadius.all(Radius.circular(50.5)),
                           ),
                         ),
                         Padding(
                           padding:  EdgeInsets.only(left:15),
                           child: Text(snapshot.data[index].data["Name"],style: TextStyle(fontWeight: FontWeight.w600,fontSize: 20),),
                         ),

                         Padding(
                           padding: EdgeInsets.only(left: 18),
                           child: Text(DateFormat.yMMMd().add_jm().format(DateTime.parse(snapshot.data[index].data["Creation Time"].toDate().toString())),style: TextStyle(color: Colors.black38,fontSize: 12),),

                         ),
                         ],
                     ),
                     Padding(
                       padding: EdgeInsets.only(left: 75),
                       child: Text(snapshot.data[index].data["Description"],style: TextStyle(fontSize: 16),),
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


