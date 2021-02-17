import 'package:flutter/material.dart';
import 'package:bezier_chart/bezier_chart.dart';
import 'package:google_fonts/google_fonts.dart';


class Profile extends StatefulWidget {
  dynamic workoutData;
  dynamic userData;
  dynamic historyData;
  Profile({Key key, this.workoutData, this.userData, this.historyData}) : super(key: key);

  @override
  _profileState createState() => _profileState();
}

class _profileState extends State<Profile> {
  get workoutData => widget.workoutData;
  get userData => widget.userData;
  get historyData => widget.historyData;
  dynamic userInfo;
  dynamic objectiveLabel = {'cardio': 'Perder peso', 'fit': 'Ponerte en forma', 'strong': 'Ganar musculatura'};
  String avatarImg = 'https://dev.fitemos.com/storage/media/avatar/X-man-small.jpg';
  String customerHeight;
  String customerHeightUnit;
  String customerWeight;
  String customerWeightUnit;
  String customerIMC;
  String toWorkout = '';
  String workoutCount = '';
  String combineVal = '';
  double progressVal = 0.0;
  String level = '';
  String objective = '';
  String chartProgress = '';


  List<double> chartAxis = [];
  List<DataPoint> chartData = [];

  @override
  void initState() {
    super.initState();
    if (userData != null) {
      userInfo = userData;
    }
    if (userData['avatar'] != null) {
      avatarImg = userData['avatarUrls']['medium'];
    }
    if (userData['customer']['current_height'] != null){
      customerHeight = (double.parse(userData['customer']['current_height']).toInt()).toString();
      customerHeightUnit =userData['customer']['current_height_unit'];
    }else{
      customerHeight = (double.parse(userData['customer']['initial_height']).toInt()).toString();
      customerHeightUnit = userData['customer']['initial_height_unit'];
    }
    if (userData['customer']['current_weight'] != null) {
      customerWeight = (double.parse(userData['customer']['current_weight']).toInt()).toString();
      customerWeightUnit = userData['customer']['current_weight_unit'];
    } else {
      customerWeight = (double.parse(userData['customer']['initial_weight']).toInt()).toString();
      customerWeightUnit = userData['customer']['initial_weight_unit'];
    }
    if (userData['customer']['imc'] != null) customerIMC = userData['customer']['imc'].toString();
    else customerIMC = 0.toString();

    if(userData['customer']['current_condition'] != null) level = 'Nivel Físico ' + userData['customer']['current_condition'].toString();
    else level = 'Nivel Físico ' + userData['customer']['initial_condition'].toString();

    if(userData['customer']['objective'] != null) {
      objective = 'auto';
      if(objective == 'auto'){
        if(double.parse('${userData['customer']['imc']}') >= 25) objective = 'cardio';
        else if(double.parse('${userData['customer']['imc']}') <= 18.5) objective = 'strong';
        else objective = 'fit';
      }
    }

    workoutCount = workoutData['workoutCount'].toString();
    toWorkout = workoutData['toWorkout'].toString();
    combineVal = workoutCount + '/' + toWorkout;
    progressVal = 1 / double.parse(toWorkout) * double.parse(workoutCount);

    if(historyData['data'] != null){
      if(historyData['data'].length > 0){
        DateTime startDate = DateTime.parse(historyData['labels'][0]);
        chartProgress = historyData['data'][historyData['data'].length-1].toString();
        for (var i = 0; i < historyData['labels'].length; i++) {
          DateTime endDate = DateTime.parse(historyData['labels'][i]);
          int daysToGenerate = endDate.difference(startDate).inDays;
          chartAxis.add(daysToGenerate.toDouble());
          chartData.add(DataPoint<double>(value: double.parse(historyData['data'][i].toString()), xAxis: daysToGenerate.toDouble()));
        }
      }else{
        chartAxis = [0, 10, 20];
        chartData = [
          DataPoint<double>(value: 0, xAxis: 0),
          DataPoint<double>(value: 0, xAxis: 10),
          DataPoint<double>(value: 0, xAxis: 20),
        ];
      }
    }else {
      chartAxis = [0, 10, 20];
      chartData = [
        DataPoint<double>(value: 0, xAxis: 0),
        DataPoint<double>(value: 0, xAxis: 10),
        DataPoint<double>(value: 0, xAxis: 20),
      ];
    }
  }

  Widget _backButton() {
    return  Container(
      padding: EdgeInsets.only(top: 30),
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      height: 90,
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
              child: Text('Mi Perfil',
                style: GoogleFonts.nunito(fontSize: 21, fontWeight: FontWeight.bold, color: Color(0xff333333)))
          ),
        ],
      ),
    );
  }

  Widget _profileBody() {
    final width = MediaQuery.of(context).size.width - 40;
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric( horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: width/4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                RichText(
                    textAlign: TextAlign.left,
                    text: TextSpan(
                        children: [
                          TextSpan(
                            text: '$customerHeight',
                            style: GoogleFonts.nunito(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: Color(0xff333333),
                            ),
                          ),
                          TextSpan(
                            text: ' $customerHeightUnit',
                            style: GoogleFonts.nunito(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Color(0xff333333),
                            ),
                          ),
                        ]
                    )
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text('Altura',
                      style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.normal, color: Color(0xff333333))),
                ),
              ],
            ),
          ),
          Container(
            width: width / 4 * 2,
            padding: EdgeInsets.only(top: 0),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(width: 1.0, color: Color(0xff333333)),
                right: BorderSide(width: 1.0, color: Color(0xff333333)),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RichText(
                    textAlign: TextAlign.left,
                    text: TextSpan(
                        children: [
                          TextSpan(
                            text: '$customerWeight',
                            style: GoogleFonts.nunito(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: Color(0xff333333),
                            ),
                          ),
                          TextSpan(
                            text: ' $customerWeightUnit',
                            style: GoogleFonts.nunito(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Color(0xff333333),
                            ),
                          ),
                        ]
                    )
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8),
                  child:  Text('Peso',
                    style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.normal, color: Color(0xff333333))),
                ),
              ],
            ),
          ),
          Container(
            width: width / 4,
            padding: EdgeInsets.only(top: 0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(customerIMC,
                    style: GoogleFonts.nunito(fontSize: 24, fontWeight: FontWeight.w800, color: Color(0xff333333))),
                  Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text('IMC',
                      style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.normal, color: Color(0xff333333))),
                  ),
                ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _profileHeader() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric( horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(60)),
              child: Image.network(
                avatarImg,
                width: 120,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 10),
          Container(
            child: Text('${userInfo['customer']['first_name']} ${userInfo['customer']['last_name']}',
                style: GoogleFonts.nunito(fontSize: 24, fontWeight: FontWeight.w600, color: Color(0xff333333))),
          ),
          SizedBox(height: 5),
          Container(
            child: Text(level,
                style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.normal, color: Color(0xff333333).withOpacity(0.6))),
          ),
          SizedBox(height: 10),
          Container(
            child: Text('Objectivo',
                style: GoogleFonts.nunito(fontSize: 21, fontWeight: FontWeight.w600, color: Color(0xff333333))),
          ),
          SizedBox(height: 5),
          Container(
            child: Text(objectiveLabel[objective],
                style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.normal, color: Color(0xff333333).withOpacity(0.6))),
          ),
        ],
      ),
    );
  }

  Widget _workoutItem() {
    final width = MediaQuery.of(context).size.width-40;
    return InkWell(
        child: Container(
          child:Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 52.0,
                height: 52.0,
                decoration: BoxDecoration(
                  color: Color(0xffD4ED6F).withOpacity(0.4),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Icon(
                  Icons.favorite_border,
                  color: Color(0xffAFCA32),
                  size: 30.0,
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
                      child: RichText(
                          textAlign: TextAlign.left,
                          text: TextSpan(
                              text: combineVal,
                              style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.normal, color: Color(0xff333333)))),
                    ),
                    SizedBox(height: 5),
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

  Widget _ProgressItem() {
    final width = MediaQuery.of(context).size.width;
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: width,
        height: 180,
        child: BezierChart(
          bezierChartScale: BezierChartScale.CUSTOM,
          xAxisCustomValues: chartAxis,
          series: [
            BezierLine(
              lineColor: Color(0xffAFCA32),
              lineStrokeWidth: 4.0,
              data: chartData ,
            ),
          ],
          config: BezierChartConfig(
            showDataPoints: false,
            backgroundColor: Colors.white,
            snap: false,
          ),
        ),
      ),
    );
  }

  Widget _profileWorkout() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric( horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 16),
            child: Text('Workouts',
                style: GoogleFonts.nunito(fontSize: 21, fontWeight: FontWeight.w700, color: Color(0xff333333))),
          ),
          SizedBox(height: 20),
          _workoutItem(),
        ],
      ),
    );
  }

  Widget _profileProgress() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric( horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                child: Text('Progreso',
                    style: GoogleFonts.nunito(fontSize: 21, fontWeight: FontWeight.w700, color: Color(0xff333333))),
              ),
              Container(
                child: Text(chartProgress,
                    style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.normal, color: Color(0xff333333).withOpacity(0.5))),
              ),
            ]
          ),
          _ProgressItem(),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 100),
                      _profileHeader(),
                      SizedBox(height: 20),
                      _profileBody(),
                      SizedBox(height: 10),
                      _profileWorkout(),
                      SizedBox(height: 20),
                      _profileProgress(),
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