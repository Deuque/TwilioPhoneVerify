import 'package:flutter/material.dart';

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
  var verificationState = VerificationState.enterPhone;
  var phoneNumberController = TextEditingController();
  var smsCodeController = TextEditingController();
  bool loading = false;
  String errorMessage;
  String successMessage;

  @override
  Widget build(BuildContext context) {
    return verificationState == VerificationState.enterPhone
        ? _buildEnterPhoneNumber()
        : _buildEnterSmsCode();
  }

  void resetErrorMessage() => setState(() => errorMessage = null);

  void resetSuccessMessage() => setState(() => successMessage = null);

  void changeLoading(bool status) => setState(() => loading = status);

  void switchToSmsCode() async {
    changeLoading(true);
    await Future.delayed(Duration(seconds: 1));
    resetSuccessMessage();
    resetErrorMessage();
    changeLoading(false);
    setState(() {
      verificationState = VerificationState.enterSmsCode;
    });
  }

  void switchToPhoneNumber() {
    if (loading) return;
    resetSuccessMessage();
    resetErrorMessage();
    setState(() {
      verificationState = VerificationState.enterPhone;
    });
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
                  onPressed: switchToSmsCode,
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
                  onPressed: () {},
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
                  onPressed: resetErrorMessage)
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
                  onPressed: resetSuccessMessage)
            ],
          ),
        ),
      );
}
