import 'package:twilio_phone_verify/src/model/twilio_reponse.dart';

abstract class TwilioVerifyRepository {
  Future<TwilioResponse> sendSmsCode(String phone);
  Future<TwilioResponse> verifySmsCode(String phone, String code);
  Future<TwilioResponse> sendEmailCode(String email);
  Future<TwilioResponse> verifyEmailCode(String email, String code);
}
