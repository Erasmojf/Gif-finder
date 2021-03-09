

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _search;
  http.Response response;
  

 Future<Map> _getGifs() async{
 if(_search == null){
    response = await http.get("https://api.giphy.com/v1/gifs/trending?api_key=wAYmtIbZHYugai9263E6hrPVJSgZvXDQ&limit=20&rating=G");
  }else {
    response = await http.get("https://api.giphy.com/v1/gifs/search?api_key=wAYmtIbZHYugai9263E6hrPVJSgZvXDQ&q=$_search&limit=25&offset=$_offSet&rating=G&lang=en");
  } return json.decode(response.body);
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}