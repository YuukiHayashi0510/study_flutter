import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

class JsonParsingSimple extends StatefulWidget {
  const JsonParsingSimple({Key? key}) : super(key: key);

  @override
  State<JsonParsingSimple> createState() => _JsonParsingSimpleState();
}

class _JsonParsingSimpleState extends State<JsonParsingSimple> {
  late Future data;

  @override
  void initState() {
    // TODO: implement initState
    data = getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Parsing Json"),
      ),
      body: Center(
        child: Container(
          child: FutureBuilder(
              future: getData(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData)
                  return createListView(snapshot.data, context);
                // return Text(snapshot.data[0]['title'].toString());
                else
                  return CircularProgressIndicator();
                //  loading
              }),
        ),
      ),
    );
  }

  Future getData() async {
    var data;
    String url = "https://jsonplaceholder.typicode.com/posts";
    Network network = Network(url);

    data = network.fetchData();
    // data.then((value)=>{
    //   print(value[0]['title'])
    // });
    return data;
  }

  Widget createListView(List data, BuildContext context) {
    return Container(
      child: ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, int index) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Divider(height: 5.0,),
                ListTile(
                  title: Text("${data[index]["title"]}"),
                  subtitle: Text("${data[index]["body"]}"),
                  leading: Column(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.black26,
                        radius: 23,
                        child: Text("${data[index]["id"]}"),
                      )
                    ],
                  ),
                )
              ],
            );
          }),
    );
  }
}

class Network {
  final String url;

  Network(this.url);

  Future fetchData() async {
    print("$url");
    Response response = await get(Uri.parse(url));
    if (response.statusCode == 200) {
      // print(response.body);
      return json.decode(response.body);
    } else {
      print(response.statusCode);
    }
  }
}
