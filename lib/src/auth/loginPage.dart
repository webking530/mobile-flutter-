import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fitemos/src/auth/forgotPasswordPage.dart';
import 'package:fitemos/src/model/apisModal.dart';
import 'package:fitemos/src/utils/apiDataSource.dart';
import 'package:fitemos/src/FitemosPage.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_fonts/google_fonts.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static final FacebookLogin facebookSignIn = new FacebookLogin();
  RestDatasource api = new RestDatasource();
  bool errorMessage = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  String _email;
  String _password;

  _loginWithFacebook(String facebookToken) async {
    api.loginWithFacebook(facebookToken).then((User user) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => FitnessNav()));
    }).catchError(( error) {
      print(error);
    });
  }

  Future<Null> _loginFacebook() async {
    final FacebookLoginResult result =
    await facebookSignIn.logIn(['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final FacebookAccessToken accessToken = result.accessToken;
        _loginWithFacebook(accessToken.token);
        break;
      case FacebookLoginStatus.cancelledByUser:
        print('Login cancelled by the user.');
        break;
      case FacebookLoginStatus.error:
        print('Something went wrong with the login process.\n'
            'Here\'s the error Facebook gave us: ${result.errorMessage}');
        break;
    }
  }

  doLogin(String username, String password) async {
    api.login(username, password).then((User user) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => FitnessNav()));
    }).catchError(( error) {
      setState(() {
        errorMessage = true;
      });
      Future.delayed(const Duration(seconds: 5), () {
        setState(() {
          errorMessage = false;
        });
      });
    });
  }

  _loginWithGoogle(String googleAccessToken) async {
    api.loginWithGoogle(googleAccessToken).then((User user) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => FitnessNav()));
    }).catchError(( error) {
      print(error);
    });
  }

  void _validateInputs() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      doLogin(_email, _password);
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  String validatePassword(String value) {
    if (value.length < 1)
      return 'Contraseña no dada';
    else
      return null;
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Inválido correo';
    else
      return null;
  }

  Widget _loginButton() {
    return InkWell(
      onTap: () {
        _validateInputs();
    },
    child: Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(vertical: 15),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(3)),
          color: Color(0xffAFCA32)),
      child: Text(
        'Inicia Sesión',
        style: TextStyle(fontSize: 16, color: Colors.white),
      ),
    ));
  }

  Widget _splashIcon() {
    return InkWell(
      child: Container(
        width: MediaQuery.of(context).size.width/3,
        padding: EdgeInsets.symmetric(vertical: 0),
        alignment: Alignment.center,
        child: Image.asset('assets/images/logo.png'),
      ),
    );
  }

  Widget _forgotPassword() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ForgotFassword()));
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.centerRight,
        child: Text('¿Olvidaste tu contraseña?',
          style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.normal, color: Color(0xffAFCA32)),
        ),
      ),
    );
  }

  Widget _showErrorMessage() {
    return Visibility (
      visible: errorMessage,
      child: Container (
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Color(0xffd8330e),
          borderRadius: BorderRadius.all(Radius.circular(3)),
        ),
        child:Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width - 100,
                child: RichText(
                  textAlign: TextAlign.left,
                  text: TextSpan(
                      text: 'El correo electrónico o la contraseña son incorrectos, intente nuevamente.',
                      style: GoogleFonts.nunito(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xffffffff),
                      ))),
              ),
              Container(
                width: 30,
                child: IconButton(
                  iconSize: 20.0,
                  padding: EdgeInsets.all(0.0),
                  icon: Icon(Icons.close),
                  color: Colors.white,
                  onPressed: () {
                    setState(() {
                      errorMessage = false;
                    });
                  },
                ),
              ),
        ]
      ),
    ),
    );
  }

  Widget _loginTitle() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'Inicia Sesión',
          style: GoogleFonts.nunito(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            color: Color(0xffffffff),
          )));
  }

  Widget formUI() {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Correo',
          style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xffFFFFFF).withOpacity(.7)),
        ),
        new TextFormField(
          keyboardType: TextInputType.emailAddress,
          style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xffFFFFFF)),
          decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xffDDDDD7), width: 1.0)),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xffFFFFFF).withOpacity(.5), width: 1.0))),
          validator: validateEmail,
          onSaved: (String val) {
            _email = val;
          },
        ),
        new SizedBox(
          height: 20.0,
        ),
        Text(
          'Contraseña',
          style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xffFFFFFF).withOpacity(.7)),
        ),
        new TextFormField(
          obscureText: true,
          style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xffFFFFFF)),
          decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xffffffff), width: 1.0)),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xffFFFFFF).withOpacity(.5), width: 1.0))),
          keyboardType: TextInputType.text,
          validator: validatePassword,
          onSaved: (String val) {
            _password = val;
          },
        ),
        new SizedBox(
          height: 10.0,
        ),
      ],
    );
  }

  Widget _socialButtons() {
    final width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GoogleSignInButton(
            text: 'Accede con Google',
              centered: true,
              onPressed: () {
                _googleSignIn.signIn().then((result){
                  result.authentication.then((googleKey){
                    debugPrint(googleKey.idToken);
                    _loginWithGoogle(googleKey.accessToken);
                  }).catchError((err){
                    print('inner error');
                  });
                }).catchError((err){
                  print('error occured');
                });
              },
            textStyle: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xff333333)),
          ),
          FacebookSignInButton(
            text: 'Accede con Facebook',
            onPressed: _loginFacebook,
            textStyle: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xffffffff)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Container(
          height: height,
          decoration: BoxDecoration(color: Color(0xff333333)),
          child: Stack(
          children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: height * .15),
                  _splashIcon(),
                  SizedBox(height: 30),
                  _loginTitle(),
                  SizedBox(height: 20),
                  _socialButtons(),
                  SizedBox(height: 20),
                  Form(
                    key: _formKey,
                    autovalidate: _autoValidate,
                    child: formUI(),
                  ),
                  _showErrorMessage(),
                  _forgotPassword(),
                  SizedBox(height: 70),
                  _loginButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
