# Twilio_Phone_Verify

A Package that helps in verifying phone numbers and email addresses using Twilio.

## Usage

To use this package :

- add the dependency to your pubspec.yaml file.

```yaml
dependencies:
  flutter:
    sdk: flutter
  twilio_phone_verify:
```

### How to use


#### Create a new Object
```dart
TwilioPhoneVerify _twilioPhoneVerify; 
```

#### Initialize with values
```dart
_twilioPhoneVerify = new TwilioPhoneVerify(
        accountSid: '*************************', // replace with Account SID
        authToken: 'xxxxxxxxxxxxxxxxxx',  // replace with Auth Token
        serviceSid: 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx' // replace with Service SID
        );
```
#### Send code to phone through sms
```dart
var result = await _twilioPhoneVerify.sendSmsCode(phoneNumber);

if(result['message'] == 'success'){
  // code sent
}else{
  // error
  //print('${result['statusCode']} : ${result['message']}');
}
```

#### Verify code
```dart
var result = await _twilioPhoneVerify.verifySmsCode(phoneNumber, code);

if (result['message'] == 'approved'){
  // code sent
}else{
  // error
  //print('${result['statusCode']} : ${result['message']}');
}
```

# Features

- [x] Phone verification
- [ ] Email verification - Coming soon.

## Getting Started

For help getting started with Flutter, view our online [documentation](https://flutter.io/).

For help on editing package code, view the [documentation](https://flutter.io/developing-packages/).