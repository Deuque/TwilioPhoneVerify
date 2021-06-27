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

### Phone number verification

##### Send Code to Phone
```dart
 var twilioResponse =
        await _twilioPhoneVerify.sendSmsCode('phone');

    if (twilioResponse.successful)  {
      //code sent
    } else {
      //print(twilioResponse.errorMessage);
    }
```

##### Verify Code
```dart
    var twilioResponse = await _twilioPhoneVerify.verifySmsCode(
        phone: 'phone', code: 'code');

    if (twilioResponse.successful) {
      if (twilioResponse.verification.status == VerificationStatus.approved) {
        //print('Phone number is approved');
      } else {
        //print('Invalid code');
      }
    } else {
      //print(twilioResponse.errorMessage);
    }
```

### Email Verification
Twilio Verify email channel requires additional Service configuration. Please refer to the [email channel setup documentation for detailed instructions](https://www.twilio.com/docs/verify/email "email channel setup documentation for detailed instructions").

##### Send Code to Email
```dart
 var twilioResponse =
        await _twilioPhoneVerify.sendEmailCode('email');

    if (twilioResponse.successful)  {
      //code sent
    } else {
      //print(twilioResponse.errorMessage);
    }
```

##### Verify Email Code
```dart
    var twilioResponse = await _twilioPhoneVerify.verifyEmailCode(
        email: 'email', code: 'code');

    if (twilioResponse.successful) {
      if (twilioResponse.verification.status == VerificationStatus.approved) {
        //print('Email is approved');
      } else {
        //print('Invalid code');
      }
    } else {
      //print(twilioResponse.errorMessage);
    }
```

##### Override Email configurations
```dart
 var twilioResponse =
        await _twilioPhoneVerify.sendEmailCode('email',channelConfiguration:
    EmailChannelConfiguration(
        from: "override@example.com",
        from_name: "Override Name",
        template_id: "d-4f7abxxxxxxxxxxxx",
		usernameSubstitution: "Foo Bar"
    ));

    if (twilioResponse.successful)  {
      //code sent
    } else {
      //print(twilioResponse.errorMessage);
    }
```

# Features

- [x] Phone verification
- [x] Email verification.

## Getting Started

For help getting started with Flutter, view our online [documentation](https://flutter.io/).

For help on editing package code, view the [documentation](https://flutter.io/developing-packages/).