import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BlogTile extends StatelessWidget {
  final String imageUrl, title, desc, url, source;
  BlogTile(
      {@required this.imageUrl,
      @required this.title,
      @required this.desc,
      this.url,
      this.source});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _launchURL,
      child: Card(
        elevation: 1.0,
        color: Colors.white,
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 14.0),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          width: 100,
          height: 140,
          child: Row(
            children: <Widget>[
//            Container(
//              margin: const EdgeInsets.symmetric(horizontal: 2.0),
//              width: 100,
//              height: 120,
////              decoration: BoxDecoration(
////                borderRadius: BorderRadius.all(Radius.circular(3.0)),
////                color: Colors.blue,
////              ),
//            ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: Colors.blue)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.fill,
                    height: 80,
                    width: 100,
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            margin:
                                const EdgeInsets.only(top: 20.0, bottom: 10.0),
                            child: Text(
                              title,
                              maxLines: 3,
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(source)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _launchURL() async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
