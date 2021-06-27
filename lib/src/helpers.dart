import 'package:flutter/foundation.dart';
import 'package:twilio_phone_verify/src/model/verification.dart';

String stringFromEnum(val) => val.toString().split('.').last;

VerificationStatus statusFromString(String status) =>
    VerificationStatus.values.firstWhere((e) => stringFromEnum(e) == status);
