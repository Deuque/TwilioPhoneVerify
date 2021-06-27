import 'package:twilio_phone_verify/src/helpers.dart';

enum VerificationStatus { pending, approved, cancelled }
class Verification {
  String to;
  String channel;
  VerificationStatus status;
  String dateCreated;
  String dateUpdated;

  Verification(
      {this.to, this.channel, this.status, this.dateCreated, this.dateUpdated});

  Verification.fromMap(Map<String, dynamic> data)
      : this.to = data['to'],
        this.channel = data['channel'],
        this.status = statusFromString(data['status']),
        this.dateUpdated = data['date_updated'],
        this.dateCreated = data['date_created'];
}
