import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fitemos/src/model/apisModal.dart';
import 'package:fitemos/src/blog/blogDetailPage.dart';
import 'package:localstorage/localstorage.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fitemos/src/model/apisModal.dart';
import 'package:fitemos/src/utils/apiDataSource.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';



class Blog extends StatefulWidget {
  Blog({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _blogState createState() => _blogState();
}

class _blogState extends State<Blog> {
  RestDatasource api = new RestDatasource();
  final LocalStorage storage = new LocalStorage('fitemos_store');
  dynamic blogData;
  int currentPage;
  bool isLoading = false;
  bool loadingFlag = true;
  bool opacityFlag = true;

  _getBlog(String pageSize, String pageNumber) async {
    String accessToken = storage.getItem('accessToken')['authentication']['accessToken'];
    api.getBlogData(pageSize, pageNumber, accessToken).then((GetBlog blogs) {
      setState(() {
        blogData = blogs.returnData['data'];
        currentPage = blogs.returnData['current_page'];
        opacityFlag = false;
      });
      Future.delayed(const Duration(milliseconds: 601), () {
        setState(() {
          loadingFlag = false;
        });
      });
    }).catchError(( error) {

    });
  }

  Widget _showLoading() {
    return AnimatedOpacity(
      opacity: opacityFlag ? 1 : 0 ,
      curve: Curves.easeInOut,
      duration: Duration(milliseconds: 600),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: SpinKitRipple(
          color: Color(0xff1A7998),
          size: 120.0,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _getBlog('100', '0');
  }

  Widget _blogItemBody(item) {
      final width = MediaQuery.of(context).size.width - 40;
      return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => BlogDetail(params: item)));
      },
      child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 3,
            offset: Offset(0, 0), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10)),
            child: Stack(
              children: <Widget>[
                Container(
                  width: width,
                  height: 200,
                  child: Image.network(
                    item['image'],
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  left: 20,
                  top: 20,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(3)),
                        color: Color(0xff51AB80)),
                    child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                            text: item['title'],
                            style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xffFFFFFF))))
                  ),
                ),
                Positioned(
                  bottom: 20,
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: width,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: RichText(
                        textAlign: TextAlign.left,
                        text: TextSpan(
                          text: item['title'],
                          style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xffFFFFFF))))
                ),
                ),
                ),
              ],
            ),
          ),
          Container(
              width: width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(bottomRight: Radius.circular(10), bottomLeft: Radius.circular(10)),
                  color: Color(0xffFFFFFF)),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 10),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                            height: 85,
                            child: Html(
                              data: item['description'],
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                            child: RichText(
                              textAlign: TextAlign.left,
                              text: TextSpan(
                                text: 'Fitemose - ${item['created_date']}',
                                style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xffB9B7B7)))),
                          ),
                          SizedBox(height: 10),
                      ]
                    )
          ),
        ]
    ),
      ),
    );
  }

  Widget _backButton() {
    return Container(
      padding: EdgeInsets.only(top: 45, left: 20),
      height: 90,
      child: RichText( textAlign: TextAlign.left, text: TextSpan(text: 'Blog',style: GoogleFonts.nunito(fontSize: 21, fontWeight: FontWeight.bold, color: Color(0xff333333)))),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    ListView listView = ListView.builder(
      itemCount: blogData != null? blogData.length : 0,
      itemBuilder: (BuildContext context, int index) {
        return Align(
          alignment: Alignment.topCenter,
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 7),
                _blogItemBody(blogData[index]),
                SizedBox(height: 7),
              ],
            ),
          ),
        );
      },
    );

    Container listViewContainer =  Container(
      height: double.infinity,
      decoration: BoxDecoration(color: Color(0xffFFFFFF)),
      child: listView,
    );

    return Scaffold(
        body: Container(
          height: height,
          decoration: BoxDecoration(color: Color(0xffFFFFFF)),
          child: Stack(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                      child: _backButton()
                  ),
                  NotificationListener<ScrollNotification>(
                    child: Flexible(
                      child: listViewContainer,
                      flex: 1,
                    ),
                    onNotification: (ScrollNotification scrollInfo) {
                      if (!isLoading && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                        //_loadData();
                        setState(() {
                          isLoading = true;
                        });
                      }
                    },
                  ),
                ],
              ),
              Positioned(left: 0, top: 0, child: loadingFlag? _showLoading() : Container()),
            ],
          ),
        )
    );
  }
}