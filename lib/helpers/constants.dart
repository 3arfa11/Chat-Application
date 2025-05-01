import 'package:flutter/material.dart';

const primaryColor = Color(0xff2B475E);
const appName = "Scholar Chat";
const appLogo = "assets/images/scholar.png";
const messagesCollection = 'messages';
const messageDocument = 'message';
const sentAtTime = 'sentTime';
getDeviceWidth(BuildContext context) {
  var deviceWidth = MediaQuery.of(context).size.width;
  return deviceWidth;
}

getDeviceHeight(BuildContext context) {
  var deviceHeight = MediaQuery.of(context).size.height;
  return deviceHeight;
}
