import 'package:flutter/material.dart';
import 'package:fitemos/src/account/modifierPage.dart';
import 'package:fitemos/src/utils/apiDataSource.dart';
import 'package:fitemos/src/model/apisModal.dart';
import 'package:localstorage/localstorage.dart';
import 'package:google_fonts/google_fonts.dart';

class Configure extends StatefulWidget {
  dynamic userData;
  Configure({Key key, this.userData}) : super(key: key);

  @override
  _configureState createState() => _configureState();
}

class _configureState extends State<Configure> {
  get userData => widget.userData;
  RestDatasource api = new RestDatasource();
  final LocalStorage storage = new LocalStorage('fitemos_store');

  bool isUpdated = false;
  bool notificationSwitchVal = true;
  bool postSwitchVal = true;

  List<String> selectItems = new List();

  String equipmentVal = 'sin pesas';
  dynamic equipmentLabel = {'con pesas': 'Con mancuernas', 'sin pesas': 'Sin mancuernas'};
  String level = '';
  String objective = '';
  dynamic objectiveLabel = {'cardio': 'Perder peso', 'fit': 'Ponerte en forma', 'strong': 'Ganar musculatura'};
  int weightSwitch = 0;
  int blogSwitch = 0;
  bool clickFlag = true;

  @override
  void initState() {
    super.initState();
    if(userData['customer']['current_condition'] != null) level = 'Nivel Físico ' + userData['customer']['current_condition'].toString();
    else level = 'Nivel Físico ' + userData['customer']['initial_condition'].toString();
    if(userData['customer']['objective'] != null) {
      objective = userData['customer']['objective'];
      if(objective == 'auto'){
        if(double.parse('${userData['customer']['imc']}') >= 25) objective = 'cardio';
        else if(double.parse('${userData['customer']['imc']}') <= 18.5) objective = 'strong';
        else objective = 'fit';
      }
    }
    /*Adding elements to data list*/
    selectItems.add('Perder peso - Quema la grasa corporal');
    selectItems.add('Ponerte en forma - Mejora tu condición física');
    selectItems.add('Ganar musculatura - Desarrolla tus músculos');
    if(userData['customer']['active_whatsapp'] != null){
      if(int.parse(userData['customer']['active_whatsapp'].toString()) == 0) notificationSwitchVal = false;
      else notificationSwitchVal = true;
    }
    if(userData['customer']['notifiable'] != null) {
      if(int.parse(userData['customer']['notifiable'].toString()) == 0) postSwitchVal = false;
      else postSwitchVal = true;
    }
  }

  _updateUserInfor() async {
    String accessToken = storage.getItem('accessToken')['authentication']['accessToken'];
    api.updateUserInfor(accessToken).then((Account returnVal) {
      Navigator.pop(context, isUpdated);
    }).catchError(( error) {
    });
  }

  _switchWorkout() async {
    String accessToken = storage.getItem('accessToken')['authentication']['accessToken'];
    api.switchWorkout(accessToken).then((Account returnVal) {
      setState(() {
        isUpdated = true;
      });
    }).catchError(( error) {
    });
  }

  _switchNotify() async {
    String accessToken = storage.getItem('accessToken')['authentication']['accessToken'];
    api.switchNotify(accessToken).then((Account returnVal) {
      setState(() {
        isUpdated = true;
      });
    }).catchError(( error) {
    });
  }

  _setEquipment(String equipmentVal) async {
    String accessToken = storage.getItem('accessToken')['authentication']['accessToken'];
    api.setEquipment(equipmentVal, accessToken).then((Account returnVal) {
      setState(() {
        isUpdated = true;
      });
    }).catchError(( error) {
    });
  }

  _setObjective(String objectiveVal) async {
    String accessToken = storage.getItem('accessToken')['authentication']['accessToken'];
    api.setObjective(objectiveVal, accessToken).then((Account returnVal) {
      setState(() {
        isUpdated = true;
      });
    }).catchError(( error) {
    });
  }

  _getCurrentLevel(String pageSize, String pageNumber) async {
    String accessToken = storage.getItem('accessToken')['authentication']['accessToken'];
    api.getCurrentLevel(pageSize, pageNumber, accessToken).then((Account levels) async {
      var result = await Navigator.push(
          context, MaterialPageRoute(builder: (context) => Modifier(currentLevel: levels.returnData)));
      if(result[0]){
        setState(() {
          isUpdated = true;
          level = 'Nivel Físico ' + result[1].toString();
        });
      }
      if(result[0] != null){
        setState(() {
          clickFlag = true;
        });
      }
    }).catchError(( error) {
    });
  }

  showConfirmDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text('Cancelar',
          style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xff333333))
      ),
      onPressed:  () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text('OK',
          style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xff333333))
      ),
      onPressed:  () {
        if(equipmentVal == "con pesas"){
          setState(() {
            equipmentVal = "sin pesas";
          });
        }else{
          setState(() {
            equipmentVal = "con pesas";
          });
        }
        _setEquipment(equipmentVal);
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
      title: Text('Confirmación',
          style: GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xff333333))
      ),
      content: Text('¿Le gustaría continuar cambiando la configuración?',
        style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xff333333))
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showSelectDialog(BuildContext context) {
    // set up the SimpleDialog
    SimpleDialog dialog = SimpleDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
      title: Text('Elige tu objetivo',
          style: GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xff333333))
      ),
      children: selectItems.map((value) {
        return new SimpleDialogOption(
          onPressed: () {
            setState(() {
              if(value == 'Perder peso - Quema la grasa corporal') objective = 'cardio';
              else if(value == 'Ponerte en forma - Mejora tu condición física') objective = 'fit';
              else objective = 'strong';
            });
            _setObjective(objective);
            Navigator.pop(context, selectItems.indexOf(value));
          },
          child: Text(value,
              style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xff333333))
          ),// value
        );
      }).toList(),
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return dialog;
      },
    );
  }

  Widget _backButton() {
    return  Container(
      padding: EdgeInsets.only(top: 30),
      height: 90,
      child: Row(
        children: <Widget>[
          InkWell(
              onTap: () {
                if(isUpdated) _updateUserInfor();
                else Navigator.pop(context, isUpdated);
              },
              child: Container(
                padding: EdgeInsets.only(left: 15, top: 12, bottom: 10),
                child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
              )),
          Container(
              padding: EdgeInsets.only(left: 6, top: 11, bottom: 10),
              child: Text('Configuración',
                  style: GoogleFonts.nunito(fontSize: 21, fontWeight: FontWeight.bold, color: Color(0xff333333))
              )
          ),
        ],
      ),
    );
  }

  Widget _bodyConfigure() {
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
                "Intensidad",
                style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.normal, color: Color(0xffB9B7B7))
              ),
              subtitle: Text(
                level,
                style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xff333333))
              ),
              trailing: Icon(
                Icons.keyboard_arrow_right,
                color: Colors.grey.shade400,
              ),
              onTap: () {
                if(clickFlag){
                  setState(() {
                    clickFlag = false;
                  });
                  _getCurrentLevel('100', '0');
                }
              },
            ),
            SizedBox(height: 5),
            ListTile(
              title: Text(
                  "Equipo",
                  style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.normal, color: Color(0xffB9B7B7))
              ),
              subtitle: Text(
                  equipmentLabel[equipmentVal],
                  style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xff333333))
              ),
              trailing: Icon(
                Icons.keyboard_arrow_right,
                color: Colors.grey.shade400,
              ),
              onTap: () {
                showConfirmDialog(context);
              },
            ),
            SizedBox(height: 5),
            ListTile(
              title: Text(
                  "Objetivo",
                  style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.normal, color: Color(0xffB9B7B7))
              ),
              subtitle: Text(
                  objectiveLabel[objective],
                  style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xff333333))
              ),
              trailing: Icon(
                Icons.keyboard_arrow_right,
                color: Colors.grey.shade400,
              ),
              onTap: () {
                showSelectDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _bodyNotification() {
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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Text( "Emails",
                  style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xff333333))
              ),
            ),
            SwitchListTile(
              title: Text(
                "Workouts",
                style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xff333333))
              ),
              value: notificationSwitchVal,
              activeColor: Color(0xff51AB80),
              onChanged: (val) {
                setState(() {
                  notificationSwitchVal = val;
                });
                _switchWorkout();
              },
            ),
            SwitchListTile(
              title: Text(
                "Blog y Promociones",
                style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xff333333))
              ),
              value: postSwitchVal,
              activeColor: Color(0xff51AB80),
              onChanged: (val) {
                setState(() {
                  postSwitchVal = val;
                });
                _switchNotify();
              },
            ),
          ],
        ),
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
                      SizedBox(height: 90),
                      _bodyConfigure(),
                      SizedBox(height: 20),
                      _bodyNotification(),
                      SizedBox(height: 10),
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