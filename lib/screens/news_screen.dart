import 'dart:convert';

import 'package:cryptocatch/Models/Article.dart';
import 'package:flutter/material.dart';
import 'package:cryptocatch/services/HexColor.dart';
import 'package:cryptocatch/Widgets/BlogTile.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  Future getNewsData() async {
    var now = new DateTime.now();
    var lastweek = now.subtract(new Duration(days: 7));

    List<Article> News = [];
    http.Response response = await http.get(
        'https://newsapi.org/v2/everything?qinTitle=Bitcoin OR Cryptocurrency OR Ethereum&from=$lastweek&to=$now&pageSize=50&apiKey=d13b7069562e4e48a729abe8bfa53d49');
    print(
        'https://newsapi.org/v2/everything?qinTitle=Bitcoin OR Cryptocurrency OR Ethereum&from=$lastweek&to=$now&pageSize=50&apiKey=d13b7069562e4e48a729abe8bfa53d49');
    if (response.statusCode == 200) {
      print("success");
      String data = response.body;
      var jsonData = jsonDecode(data);
      print(jsonData.runtimeType);

//      for (var data in jsonData) {
//        Articles articles = Articles.fromJson(jsonData);
//        News.add(articles);
//      }
      if (jsonData["status"] == 'ok') {
        print("done");
        jsonData["articles"].forEach((element) {
          if (element["urlToImage"] != null && element["description"] != null) {
            Article article = Article(
                element["title"],
                element["description"],
                element["url"],
                element["urlToImage"],
                element["source"]["name"]);
            News.add(article);
            print("done");
          }
        });
      }

//      for (var data in jsonData) {
//        Article article = Article(data["articles"][]["urlToImage"],
//            data["articles"][1]["title"], data["articles"][1]["description"]);
//        News.add(article);
//      }

      print(News);
      return News;
    } else {
      print(response.statusCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Latest Crypto News"),
          backgroundColor: HexColor('#0D3AA9'),
          automaticallyImplyLeading: false,
        ),
        body: Container(
          margin: EdgeInsets.only(top: 16),
          child: FutureBuilder(
            future: getNewsData(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return Container(
                  child: Center(
                    child: SpinKitRotatingPlain(
                      color: Colors.blue,
                      size: 100,
                    ),
                  ),
                );
              } else {
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return BlogTile(
                        imageUrl: snapshot.data[index].urlToImage,
                        title: snapshot.data[index].title,
                        desc: snapshot.data[index].description,
                        url: snapshot.data[index].url,
                        source: snapshot.data[index].source,
                      );
                    });
              }
            },
          ),
        ));
  }
}
