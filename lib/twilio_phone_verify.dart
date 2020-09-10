library twilio_phone_verify;

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';

class TwilioPhoneVerify{
  String accountSid, serviceSid, authToken, baseUrl;

  TwilioPhoneVerify({@required this.accountSid, @required this.authToken, @required this.serviceSid}){
    baseUrl = 'https://verify.twilio.com/v2/Services/$serviceSid';
  }


  Future sendSmsCode(String phone) async {
    var authn = 'Basic ' + base64Encode(utf8.encode('$accountSid:$authToken'));
    String url = '$baseUrl/Verifications';
    var response = await http.post(
        url, body: {'To': phone, 'Channel': 'sms'},
        headers: {'Authorization': authn});

    if (response.statusCode == 200||response.statusCode == 201) {
      return {'statusCode':response.statusCode.toString(), 'message': 'success'};
    } else {
      return {'statusCode':response.statusCode.toString(), 'message':'${jsonDecode(response.body)['message']}'};
    }
  }

  Future verifySmsCode(String phone, String code) async {
    var authn = 'Basic ' + base64Encode(utf8.encode('$accountSid:$authToken'));
    String url = '$baseUrl/VerificationCheck';
    var response = await http.post(
        url, body: {'To': phone, 'Code': code},
        headers: {'Authorization': authn});

    if (response.statusCode == 200||response.statusCode == 201) {
      return {'statusCode':response.statusCode.toString(), 'message': 'approved'};
    } else {
      return {'statusCode':response.statusCode.toString(), 'message':'${jsonDecode(response.body)['message']}'};
    }
  }
}
