import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:twilio_phone_verify/src/data/repo.dart';
import 'package:twilio_phone_verify/src/endpoints.dart';
import 'package:twilio_phone_verify/src/model/email_channel_configuration.dart';
import 'package:twilio_phone_verify/src/model/twilio_reponse.dart';
import 'package:http/http.dart';
import 'package:twilio_phone_verify/src/model/verification.dart';

class TwilioVerifyRepositoryImpl implements TwilioVerifyRepository {
  final String baseUrl;
  final String authorization;

  TwilioVerifyRepositoryImpl(
      {@required this.baseUrl, @required this.authorization});

  @override
  Future<TwilioResponse> sendEmailCode(String email,
      {EmailChannelConfiguration channelConfiguration}) async {
    String url = '$baseUrl${TwilioVerifyEndpoint.verification}';

    return await resolveHttpRequest(url: url, body: {
      'To': email,
      'Channel': 'email',
      if (channelConfiguration != null)
        'ChannelConfiguration': channelConfiguration.toMap()
    }, headers: {
      'Authorization': authorization
    });
  }

  @override
  Future<TwilioResponse> sendSmsCode(String phone) async {
    // TODO: implement sendEmailCode
    String url = '$baseUrl${TwilioVerifyEndpoint.verification}';

    return await resolveHttpRequest(
        url: url,
        body: {'To': phone, 'Channel': 'sms'},
        headers: {'Authorization': authorization});
  }

  @override
  Future<TwilioResponse> verifyEmailCode(String email, String code) async{
    String url = '$baseUrl$TwilioVerifyEndpoint.verificationCheck';

    return await resolveHttpRequest(
        url: url,
        body: {'To': email, 'Code': code},
        headers: {'Authorization': authorization});
  }

  @override
  Future<TwilioResponse> verifySmsCode(String phone, String code) async {
    String url = '$baseUrl$TwilioVerifyEndpoint.verificationCheck';

    return await resolveHttpRequest(
        url: url,
        body: {'To': phone, 'Code': code},
        headers: {'Authorization': authorization});
  }

  Future<TwilioResponse> resolveHttpRequest(
      {String url,
      Map<String, dynamic> body,
      Map<String, dynamic> headers}) async {
    try {
      var response = await post(url, body: body, headers: headers);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return TwilioResponse(
            statusCode: response.statusCode,
            errorMessage: '',
            verification: Verification.fromMap(jsonDecode(response.body)));
      } else {
        return TwilioResponse(
            statusCode: response.statusCode,
            errorMessage: '${jsonDecode(response.body)['message']}',
            verification: null);
      }
    } catch (e) {
      return TwilioResponse(
          statusCode: 400, errorMessage: e.toString(), verification: null);
    }
  }
}
