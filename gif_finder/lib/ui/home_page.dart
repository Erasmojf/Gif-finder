

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gif_finder/ui/gif_page.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _offSet = 0;
  String _search;
  http.Response response;
  

 Future<Map> _getGifs() async{
 if(_search == null){
    response = await http.get(Uri.parse("https://api.giphy.com/v1/gifs/trending?api_key=2h69QPxkAKjn6CwO4XNpvXWxF6TP4CXL&limit=19&rating=g"));
  }else {
    response = await http.get(Uri.parse("https://api.giphy.com/v1/gifs/search?api_key=2h69QPxkAKjn6CwO4XNpvXWxF6TP4CXL&q=$_search&limit=19&offset=$_offSet&rating=g&lang=en"));
  } 
  return json.decode(response.body);

  }
@override
  void initState() {
    super.initState();
    _getGifs().then((map) => print(map));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.network("https://developers.giphy.com/static/img/dev-logo-lg.7404c00322a8.gif"),
        centerTitle: true,
       ),
       backgroundColor: Colors.black,
       body: Column(children: [
        Padding(padding: EdgeInsets.all(18.0),
         child: TextField(
           decoration: InputDecoration(
             labelText: 'Search',
             labelStyle: TextStyle(color: Colors.white),
             border: OutlineInputBorder()
           ),
           style: TextStyle(color: Colors.white, fontSize: 18.0),
           textAlign: TextAlign.center,
           onSubmitted: (text){
            setState(() {
               _search = text;
               _offSet = 0;
            });
           },
         ),
         
        ),
        Expanded(child: FutureBuilder(
          future: _getGifs(),
          builder: (context, snapshot){
            switch(snapshot.connectionState){
              case ConnectionState.waiting:
              case ConnectionState.none:

              return Container(
                width: 200,
                height: 200,
                alignment: Alignment.center,
                child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 5.0,
                ),
              );
              default:
              if(snapshot.hasError){
                return Container();
              }else{
               return _createGifsTable(context, snapshot);
              }

            } 
          },
          initialData: null,
          ))
       ],),
    );
  }


int _getCount(List data){
  if(_search == null || _search.isEmpty){
    return data.length;
  }else{
    return data.length + 1;
  }
}
  Widget _createGifsTable(BuildContext context, AsyncSnapshot snapshot) {
     return GridView.builder(
       padding: EdgeInsets.all(18.0),
       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
         crossAxisCount: 2,
         crossAxisSpacing: 10.0,
         mainAxisSpacing: 10.0,
         
         ), 
         itemCount: _getCount(snapshot.data['data']),
       itemBuilder: (context, index){
         if(_search == null || index < snapshot.data['data'].length)
           return GestureDetector(
           child: FadeInImage.memoryNetwork(
             placeholder: kTransparentImage, 
             image: snapshot.data['data'][index]['images']['fixed_height']['url'],
             height: 300.0,
             fit: BoxFit.cover,),
           onTap: (){
             Navigator.push(context, 
             MaterialPageRoute(
               builder: (context)=> GifPage(snapshot.data['data'][index]),
               ),
               );
           },
           onLongPress: (){
             Share.share(snapshot.data['data'][index]['images']['fixed_height']['url']);
           },
         );
         
         else
           return Container(
             child:  GestureDetector(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                      Icon(Icons.add, color: Colors.white, size: 70.0),
                      Text("Carregar mais...", 
                      style: TextStyle(color: Colors.white, fontSize: 20.0))
                  ],
                  ),
                  onTap: (){
                    setState(() {
                      _offSet += 19;
                    });
                  },
             ),
           );
       });
  }
}