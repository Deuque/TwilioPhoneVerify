import 'package:twilio_phone_verify/src/model/verification.dart';

class TwilioResponse{
  String errorMessage;
  int statusCode;
  Verification verification;
  TwilioResponse({this.statusCode,this.errorMessage,this.verification});
}