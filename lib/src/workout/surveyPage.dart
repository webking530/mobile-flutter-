import 'package:flutter/material.dart';
import 'package:fitemos/src/utils/apiDataSource.dart';
import 'package:fitemos/src/model/apisModal.dart';
import 'package:localstorage/localstorage.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:google_fonts/google_fonts.dart';

class Survey extends StatefulWidget {
  dynamic params;
  Survey({Key key, this.params}) : super(key: key);

  @override
  _surveyState createState() => _surveyState();
}

class _surveyState extends State<Survey> {
  get survey => widget.params;
  dynamic valGroup = {};
  dynamic result;
  RestDatasource api = new RestDatasource();
  final LocalStorage storage = new LocalStorage('fitemos_store');
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  dynamic selectVal = {};
  dynamic validFlag = {};
  bool showValidationFlag = false;

  _sendSurvey() async {
    String accessToken = storage.getItem('accessToken')['authentication']['accessToken'];
    api.sendSurvey(result, accessToken).then((Account returnVal) async {
      Navigator.pop(context);
    }).catchError(( error) {
      print(error);
    });
  }

  @override
  void initState() {
    super.initState();
    result = survey['items'];
  }

  String validateFirstName(String value) {
    Pattern pattern =r"^(?!\s*$).+";
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return '';
    else
      return null;
  }

  void _validateInputs() {
    setState(() {
      showValidationFlag = true;
    });
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      if(validFlag.length == result.length) _sendSurvey();
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  Widget _backButton() {
    return  Container(
      padding: EdgeInsets.only(top: 30),
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
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
              child: Text(survey['title'],
                  style: GoogleFonts.nunito(fontSize: 21, fontWeight: FontWeight.bold, color: Color(0xff333333))
              )
          ),
        ],
      ),
    );
  }

  Widget _itemContent(data, index) {
    if(data['question'] == "text"){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
              margin: EdgeInsets.only(top: 20),
              child: RichText(
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  text: TextSpan(
                      text: data['label'],
                      style: GoogleFonts.nunito(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff333333),
                      )
                  )
              )
          ),
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.all(0.0),
            child: TextFormField(
              decoration: new InputDecoration(
                fillColor: Colors.white,
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(5.0),
                  borderSide: new BorderSide(),
                ),
                //fillColor: Colors.green
              ),
              style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xff333333)),
              maxLines: 2,
              validator: validateFirstName,
              onSaved: (String val) {
                result[index]['report'] = val;
                setState(() {
                  validFlag[data['label']] = val;
                });
              },
            ),
          ),
        ],
      );
    }else if(data['question'] == "level"){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
              margin: EdgeInsets.only(top: 20),
              child: RichText(
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  text: TextSpan(
                      text: data['label'],
                      style: GoogleFonts.nunito(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff333333),
                      )
                  )
              )
          ),
          Container(
              margin: EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                border: Border.all(
                  color: showValidationFlag?validFlag[data['label']] == null? Colors.red : Colors.white : Colors.white,
                  width: showValidationFlag?validFlag[data['label']] == null? 1 : 0 : 0,
                ),
              ),
              child: RatingBar(
                initialRating: 0,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  result[index]['report'] = rating;
                  setState(() {
                    validFlag[data['label']] = rating;
                  });
                },
              ),
          ),
        ],
      );
    }else{
      List<String> _status = [];
      for (var i = 0; i < data['options'].length; i++) {
        _status.add(data['options'][i]['option_label']);
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
              margin: EdgeInsets.only(top: 20),
              child: RichText(
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  text: TextSpan(
                      text: data['label'],
                      style: GoogleFonts.nunito(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff333333),
                      )
                  )
              )
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              border: Border.all(
                color: showValidationFlag? validFlag[data['label']] == null? Colors.red : Colors.white : Colors.white,
                width: showValidationFlag? validFlag[data['label']] == null? 1 : 0 : 0,
              ),
            ),
            child: RadioGroup<String>.builder(
              groupValue: selectVal[data['label']],
              onChanged: (value) => setState(() {
                setState(() {
                  selectVal[data['label']] = value;
                  validFlag[data['label']] = value;
                });
                for (var i = 0; i < data['options'].length; i++) {
                  if(data['options'][i]['option_label'] == value)
                    result[index]['report'] = data['options'][i]['id'];
                }
              }),
              items: _status,
              itemBuilder: (item) => RadioButtonBuilder(
                item,
                textPosition: RadioButtonTextPosition.right,
              ),
            ),
          ),
        ],
      );
    }
  }

  Widget _surveyWidget() {
    if(survey['items'] != null) {
      return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          child: ListView.builder(
            padding: EdgeInsets.all(0.0),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: survey['items'].length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _itemContent(survey['items'][index], index),
                  ],
                ),
              );
            },
          )
      );
    }else{
      return Container();
    }
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 90),
                      Form(
                        key: _formKey,
                        autovalidate: _autoValidate,
                        child: _surveyWidget(),
                      ),
                      SizedBox(height: 30),
                      Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: FlatButton(
                            color: Color(0xff1A7998),
                            textColor: Colors.white,
                            padding: EdgeInsets.symmetric(horizontal: 30),
                            splashColor: Colors.cyan,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.0)),
                            onPressed: () {
                              _validateInputs();
                            },
                            child: Text(
                              "Confirmar",
                              style: GoogleFonts.nunito(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                              ),
                            ),
                          )
                      ),
                      SizedBox(height: 30),
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