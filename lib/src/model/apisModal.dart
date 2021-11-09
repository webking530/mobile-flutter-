
import 'dart:io';

class MonitorModel {
  MonitorModel(this.id, this.unitName, this.customerName, this.location,
      this.dateTime, this.totalRunHour, this.lastDayRunHour);
  var id = "";
  var unitName = "";
  var customerName = "";
  var location = "";
  var dateTime = "";
  var totalRunHour = "";
  var lastDayRunHour = "";
}

class User {
  int _id;
  String _username;
  String _email;
  String _accessToken;

  User.map(dynamic obj) {
    this._username = obj['user']['name'];
    this._email = obj['user']['email'];
    this._id = obj['user']['id'];
    this._accessToken = obj['authentication']['accessToken'];
  }

  int get id => _id;
  String get username => _username;
  String get email => _email;
  String get accessToken => _accessToken;

}

class Workout {
  dynamic _workoutData;

  Workout.map(dynamic obj) {
    this._workoutData = obj;
  }

  dynamic get workoutData => _workoutData;

}

class CheckVal {
  dynamic _returnData;

  CheckVal.map(dynamic obj) {
    this._returnData = obj;

  }

  dynamic get returnData => _returnData;

}

class ResetPassword {
  dynamic _returnData;

  ResetPassword.map(dynamic obj) {
    this._returnData = obj;

  }

  dynamic get returnData => _returnData;

}

class GetBlog {
  dynamic _returnData;

  GetBlog.map(dynamic obj) {
    this._returnData = obj;

  }

  dynamic get returnData => _returnData;

}

class GetShop {
  dynamic _returnData;

  GetShop.map(dynamic obj) {
    this._returnData = obj;

  }

  dynamic get returnData => _returnData;

}

class GetShopItem {
  dynamic _returnData;

  GetShopItem.map(dynamic obj) {
    this._returnData = obj;

  }
  dynamic get returnData => _returnData;

}

class Account {
  dynamic _returnData;

  Account.map(dynamic obj) {
    this._returnData = obj;

  }
  dynamic get returnData => _returnData;

}

class Download {
  File _returnData;

  Download.map(File obj) {
    this._returnData = obj;

  }
  File get returnData => _returnData;

}