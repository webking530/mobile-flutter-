import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fitemos/src/model/apisModal.dart';
import 'package:fitemos/src/benchMark/benchDetailPage.dart';
import 'package:localstorage/localstorage.dart';
import 'package:fitemos/src/utils/apiDataSource.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';


class BenchMark extends StatefulWidget {
  BenchMark({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _benchmarkState createState() => _benchmarkState();
}

class _benchmarkState extends State<BenchMark> {
  RestDatasource api = new RestDatasource();
  final LocalStorage storage = new LocalStorage('fitemos_store');
  dynamic benchmarkData;
  dynamic historyData;
  bool isLoading = false;
  bool loadingFlag = true;
  bool opacityFlag = true;

  _getHistory(dynamic item) async {
    String accessToken = storage.getItem('accessToken')['authentication']['accessToken'];
    api.getHistory(accessToken).then((Account history) {
      setState(() {
        historyData = history.returnData;
      });
      Navigator.push(context, MaterialPageRoute(builder: (context) => BenchDetail(params: item, historyData: historyData)));
    }).catchError(( error) {
    });
  }

  _getBenchmark() async {
    String accessToken = storage.getItem('accessToken')['authentication']['accessToken'];
    api.getBenchmark(accessToken).then((Account benchmarks) {
      setState(() {
        benchmarkData = benchmarks.returnData['published'];
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
    _getBenchmark();
  }

  Widget _blogItemBody(item) {
    final width = MediaQuery.of(context).size.width - 40;
    return InkWell(
      onTap: () {
        _getHistory(item);
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
                    height: 230,
                    child: Image.network(
                      item['image'],
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
            Container(
                width: width,
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(10), bottomLeft: Radius.circular(10)),
                    color: Color(0xffFFFFFF)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          RichText(
                            textAlign: TextAlign.left,
                            text: TextSpan(
                              text: item['title'],
                              style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xff333333)))),
                          RichText(
                              textAlign: TextAlign.left,
                              text: TextSpan(
                                  text: item['result'],
                                  style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xff333333).withOpacity(0.5)))),
                            ]
                      )
                  ),
          ]
        )
      )
    );
  }

  Widget _backButton() {
    return Container(
      padding: EdgeInsets.only(top: 45, left: 20),
      height: 90,
      child: RichText( textAlign: TextAlign.left, text: TextSpan(text: 'Benchmarks',style: GoogleFonts.nunito(fontSize: 21, fontWeight: FontWeight.bold, color: Color(0xff333333)))),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    ListView listView = ListView.builder(
      itemCount: benchmarkData != null? benchmarkData.length : 0,
      itemBuilder: (BuildContext context, int index) {
        return Align(
          alignment: Alignment.topCenter,
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 7),
                _blogItemBody(benchmarkData[index]),
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
                  Flexible(
                    child: listViewContainer,
                    flex: 1,
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