import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:twilio_phone_verify/src/data/repo.dart';
import 'package:twilio_phone_verify/src/data/repo_impl.dart';
import 'package:twilio_phone_verify/src/model/email_channel_configuration.dart';
import 'package:twilio_phone_verify/src/model/twilio_reponse.dart';

class TwilioPhoneVerify {
  final String accountSid, serviceSid, authToken;
  TwilioVerifyRepository _repository;

  TwilioPhoneVerify(
      {@required this.accountSid, @required this.serviceSid, this.authToken}) {
    _repository = TwilioVerifyRepositoryImpl(
        baseUrl: 'https://verify.twilio.com/v2/Services/$serviceSid',
        authorization:
            'Basic ' + base64Encode(utf8.encode('${accountSid}:$authToken')));
  }

  Future<TwilioResponse> sendSmsCode(String phone) async {
    return _repository.sendSmsCode(phone);
  }
  Future<TwilioResponse> verifySmsCode({@required String phone, @required String code}) async {
    return _repository.verifySmsCode(phone,code);
  }

  Future<TwilioResponse> sendEmailCode(String email,{EmailChannelConfiguration channelConfiguration}) async {
    return _repository.sendEmailCode(email, channelConfiguration: channelConfiguration);
  }
  Future<TwilioResponse> verifyEmailCode({@required String email, @required String code}) async {
    return _repository.verifyEmailCode(email,code);
  }
}
