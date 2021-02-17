import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:google_fonts/google_fonts.dart';

class BlogDetail extends StatefulWidget {
  dynamic params;
  BlogDetail({Key key, this.params}) : super(key: key);

  @override
  _blogDetailState createState() => _blogDetailState();
}

class _blogDetailState extends State<BlogDetail> {
  get item => widget.params;
  Widget _backButton() {
    return  Container(
      padding: EdgeInsets.only(top: 30),
      width: MediaQuery.of(context).size.width,
      height: 90,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                padding: EdgeInsets.only(left: 15, top: 12, bottom: 10),
                child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
              )),
          Container(
              padding: EdgeInsets.only(left: 6, top: 11, bottom: 10),
              child: Text('Blog',
                style: GoogleFonts.nunito(fontSize: 21, fontWeight: FontWeight.bold, color: Color(0xff333333)))
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        body: Container(
          height: size.height,
          decoration: BoxDecoration(color: Color(0xffFFFFFF)),
          child: Stack(
            children: <Widget>[
              Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Container(
                              height: 300,
                              margin: const EdgeInsets.only(top: 100, left: 20.0, right: 20.0, bottom: 20.0),
                              width: double.infinity,
                              child: ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                                child: Image.network(
                                  item['image'],
                                  fit: BoxFit.cover,
                                ),
                              ),
                             ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(item['title'], style: GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xff333333)),),
                            Text(item['created_date'], style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xff333333).withOpacity(.5))),
                            Divider(),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Html(
                          data: item['description'],
                          style: {
                            "p" : Style(
                              fontFamily: 'Nunito',
                            ),
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(top: 0, left: 0, child: _backButton()),
            ],
          ),
        )
    );
  }
}