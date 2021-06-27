import 'package:flutter/material.dart';
import 'package:twilio_phone_verify/twilio_phone_verify.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Twilio Phone Verify',
      theme: ThemeData(
        primaryColor: Color(0xFF233659),
      ),
      home: PhoneVerification(),
    );
  }
}

enum VerificationState { enterPhone, enterSmsCode }

class PhoneVerification extends StatefulWidget {
  @override
  _PhoneVerificationState createState() => _PhoneVerificationState();
}

class _PhoneVerificationState extends State<PhoneVerification> {
  TwilioPhoneVerify _twilioPhoneVerify;

  var verificationState = VerificationState.enterPhone;
  var phoneNumberController = TextEditingController();
  var smsCodeController = TextEditingController();
  bool loading = false;
  String errorMessage;
  String successMessage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _twilioPhoneVerify = TwilioPhoneVerify(
        accountSid: '',
        serviceSid: '',
        authToken: '');
  }

  @override
  Widget build(BuildContext context) {
    return verificationState == VerificationState.enterPhone
        ? _buildEnterPhoneNumber()
        : _buildEnterSmsCode();
  }

  void changeErrorMessage(var message) =>
      setState(() => errorMessage = message);

  void changeSuccessMessage(var message) =>
      setState(() => successMessage = message);

  void changeLoading(bool status) => setState(() => loading = status);

  void switchToSmsCode() async {
    changeSuccessMessage(null);
    changeErrorMessage(null);
    changeLoading(false);
    setState(() {
      verificationState = VerificationState.enterSmsCode;
    });
  }

  void switchToPhoneNumber() {
    if (loading) return;
    changeSuccessMessage(null);
    changeErrorMessage(null);
    setState(() {
      verificationState = VerificationState.enterPhone;
    });
  }

  void sendCode() async {
    if (phoneNumberController.text.isEmpty || loading) return;
    changeLoading(true);
    TwilioResponse twilioResponse =
        await _twilioPhoneVerify.sendSmsCode(phoneNumberController.text);

    if (twilioResponse.successful) {
      changeSuccessMessage('Code sent to ${phoneNumberController.text}');
      await Future.delayed(Duration(seconds: 1));
      switchToSmsCode();
    } else {
      changeErrorMessage(twilioResponse.errorMessage);
    }
    changeLoading(false);
  }

  void verifyCode() async {
    if (phoneNumberController.text.isEmpty ||
        smsCodeController.text.isEmpty ||
        loading) return;
    changeLoading(true);
    TwilioResponse twilioResponse = await _twilioPhoneVerify.verifySmsCode(
        phone: phoneNumberController.text, code: smsCodeController.text);
    if (twilioResponse.successful) {
      if (twilioResponse.verification.status == VerificationStatus.approved) {
        changeSuccessMessage('Phone number is approved');
      } else {
        changeSuccessMessage('Invalid code');
      }
    } else {
      changeErrorMessage(twilioResponse.errorMessage);
    }
    changeLoading(false);
  }

  _buildEnterPhoneNumber() {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: phoneNumberController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(labelText: 'Enter Phone Number'),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: double.infinity,
              height: 40,
              child: TextButton(
                  onPressed: sendCode,
                  style: TextButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor),
                  child: loading
                      ? _loader()
                      : Text(
                          'Send code',
                          style: TextStyle(color: Colors.white),
                        )),
            ),
            if (errorMessage != null) ...[
              SizedBox(
                height: 30,
              ),
              _errorWidget()
            ],
            if (successMessage != null) ...[
              SizedBox(
                height: 30,
              ),
              _successWidget()
            ]
          ],
        ),
      ),
    );
  }

  _buildEnterSmsCode() {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 18,
            color: Theme.of(context).primaryColor,
          ),
          onPressed: switchToPhoneNumber,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: smsCodeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Enter Sms Code'),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: double.infinity,
              height: 40,
              child: TextButton(
                  onPressed: verifyCode,
                  style: TextButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor),
                  child: loading
                      ? _loader()
                      : Text(
                          'Verify',
                          style: TextStyle(color: Colors.white),
                        )),
            ),
            if (errorMessage != null) ...[
              SizedBox(
                height: 30,
              ),
              _errorWidget()
            ],
            if (successMessage != null) ...[
              SizedBox(
                height: 30,
              ),
              _successWidget()
            ]
          ],
        ),
      ),
    );
  }

  _loader() => SizedBox(
        height: 15,
        width: 15,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation(Colors.white),
        ),
      );

  _errorWidget() => Material(
        borderRadius: BorderRadius.circular(5),
        color: Colors.red.withOpacity(.1),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Row(
            children: [
              Expanded(
                  child: Text(
                errorMessage,
                style: TextStyle(color: Colors.red),
              )),
              IconButton(
                  icon: Icon(
                    Icons.close,
                    size: 16,
                  ),
                  onPressed: () => changeErrorMessage(null))
            ],
          ),
        ),
      );

  _successWidget() => Material(
        borderRadius: BorderRadius.circular(5),
        color: Colors.green.withOpacity(.1),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Row(
            children: [
              Expanded(
                  child: Text(
                successMessage,
                style: TextStyle(color: Colors.green),
              )),
              IconButton(
                  icon: Icon(
                    Icons.close,
                    size: 16,
                  ),
                  onPressed: () => changeSuccessMessage(null))
            ],
          ),
        ),
      );
}
