import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fitemos/src/account/profilePage.dart';
import 'package:fitemos/src/account/configurePage.dart';
import 'package:fitemos/src/account/supportPage.dart';
import 'package:fitemos/src/account/shareFitness.dart';
import 'package:fitemos/src/account/billPage.dart';
import 'package:fitemos/src/account/rateApp.dart';
import 'package:fitemos/src/utils/apiDataSource.dart';
import 'package:fitemos/src/model/apisModal.dart';
import 'package:localstorage/localstorage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

class AccountPage extends StatefulWidget {
  AccountPage({Key key}) : super(key: key);

  @override
  _accountState createState() => _accountState();
}

class _accountState extends State<AccountPage> {
  RestDatasource api = new RestDatasource();
  final LocalStorage storage = new LocalStorage('fitemos_store');
  dynamic userInfo;
  dynamic workoutData;
  dynamic userData;
  dynamic historyData;
  String toWorkout = '';
  String workoutCount = '';
  String combineVal = '';
  double progressVal = 0.0;
  String avatarImg = 'https://dev.fitemos.com/storage/media/avatar/X-man-small.jpg';
  bool loadingFlag = true;
  bool opacityFlag = true;

  _getReferral() async {
    String accessToken = storage.getItem('accessToken')['authentication']['accessToken'];
    api.getReferral(accessToken).then((Account referral) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => ShareFitness(params: referral.returnData)));
    }).catchError(( error) {
    });
  }

  _getHistory() async {
    String accessToken = storage.getItem('accessToken')['authentication']['accessToken'];
    api.getHistory(accessToken).then((Account history) {
      setState(() {
        historyData = history.returnData;
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
  _getRecentWorkout() async {
    String accessToken = storage.getItem('accessToken')['authentication']['accessToken'];
    api.getProfileWorkout(accessToken).then((Account workout) {
      setState(() {
        workoutData = workout.returnData['profile'];
        workoutCount = workout.returnData['profile']['workoutCount'].toString();
        toWorkout = workout.returnData['profile']['toWorkout'].toString();
        combineVal = workoutCount + '/' + toWorkout;
        progressVal = 1 / double.parse(toWorkout) * double.parse(workoutCount);
      });
      _getHistory();
    }).catchError(( error) {
    });
  }

  void updateState() {
    setState(() {
    dynamic user = storage.getItem('accessToken')['user'];
    userData = user;
    if (user != null) {
      userInfo = user;
    }
    if (user['avatar'] != null) {
      avatarImg = user['avatarUrls']['medium'];
    }
    _getRecentWorkout();
    });
  }

  @override
  void initState() {
    super.initState();
    updateState();
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

  Widget _headerInfo() {
    final width = MediaQuery.of(context).size.width-40;
    return InkWell(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child:Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(50)),
                child: Image.network(
                  avatarImg,
                  width: 52,
                  height: 52,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20),
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
              Container(
                width: width - 150,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: '${userInfo['customer']['first_name']} ${userInfo['customer']['last_name']}',
                        style: GoogleFonts.nunito(fontSize: 21, fontWeight: FontWeight.bold, color: Color(0xff333333)))),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: combineVal,
                        style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.normal, color: Color(0xff333333)))),
                  ]
                ),
              ),
              Container(
                width: width - 150,
                padding: EdgeInsets.only(top: 10),
                child: SizedBox(
                  height: 8.0,
                  child: LinearProgressIndicator(
                    backgroundColor: Color(0xffD4ED6F).withOpacity(0.4),
                    value: progressVal,
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xffAFCA32)),
                  ),
                ),
              ),
              ],
            ),
            ),
          ],
        ),
      )
    );
  }

  Widget _headerAccount() {
    return InkWell(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 25,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topRight: Radius.circular(25), topLeft: Radius.circular(25)),
          color: Colors.white,
        ),
      )
    );
  }

  Widget _bodyAccount() {
    final height = MediaQuery.of(context).size.height;
    return InkWell(
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(left: 10),
        color: Color(0xffFFFFFF),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            ListTile(
              title: Text(
                "Mi Perfil",
                style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xff333333))
              ),
              trailing: Icon(
                Icons.keyboard_arrow_right,
                color: Colors.grey.shade400,
              ),
              onTap: () {
                if(historyData != null) Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Profile(workoutData: workoutData, userData: userData, historyData: historyData)));
              },
            ),
            SizedBox(height: 5),
            ListTile(
              title: Text(
                  "Configuración",
                  style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xff333333))
              ),
              trailing: Icon(
                Icons.keyboard_arrow_right,
                color: Colors.grey.shade400,
              ),
              onTap: () async {
                var result = await Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Configure(userData: userData)));
                if(result){
                  setState(() {
                    userData = storage.getItem('accessToken')['user'];
                  });
                }
              },
            ),
            SizedBox(height: 5),
            ListTile(
              title: Text(
                  "Cuenta",
                  style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xff333333))
              ),
              trailing: Icon(
                Icons.keyboard_arrow_right,
                color: Colors.grey.shade400,
              ),
              onTap: () async {
                var result = await Navigator.push(
                    context, MaterialPageRoute(builder: (context) => BillPage()));
                print(result);
                if(result){
                  updateState();
                }
              },
            ),
            SizedBox(height: 5),
            ListTile(
              title: Text(
                  "Invita a un amigo",
                  style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xff333333))
              ),
              trailing: Icon(
                Icons.keyboard_arrow_right,
                color: Colors.grey.shade400,
              ),
              onTap: () {
                _getReferral();
              },
            ),
            SizedBox(height: 5),
            ListTile(
              title: Text(
                  "Soporte",
                  style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xff333333))
              ),
              trailing: Icon(
                Icons.keyboard_arrow_right,
                color: Colors.grey.shade400,
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Support()));
              },
            ),
            SizedBox(height: 5),
            ListTile(
              title: Text(
                  "Déjanos una Valoración",
                  style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xff333333))
              ),
              trailing: Icon(
                Icons.keyboard_arrow_right,
                color: Colors.grey.shade400,
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => RateApp()));
              },
            ),
            SizedBox(height: height * 0.2774),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Container(
          height: height,
          decoration: BoxDecoration(color: Color(0xffE5E5E5)),
          child: Stack(
          children: <Widget>[
          Container(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: height * .08),
                  _headerInfo(),
                  SizedBox(height: 30),
                  _headerAccount(),
                  _bodyAccount(),
                ],
              ),
            ),
          ),
            Positioned(left: 0, top: 0, child: loadingFlag? _showLoading() : Container()),
        ],
      ),
    ));
  }
}
