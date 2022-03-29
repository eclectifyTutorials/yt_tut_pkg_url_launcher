import 'dart:io';
import 'package:url_launcher/url_launcher.dart';

/*
For iOS in Info.plist:
<key>LSApplicationQueriesSchemes</key>
<array>
  <string>https</string>
  <string>http</string>
  <string>mailto</string>
  <string>tel</string>
  <string>sms</string>
  <string>facetime</string>
</array>
*/

// For Android in AndroidManifest.xml (child of root element):
// <queries>
//   <!-- If your app opens https URLs -->
//   <intent>
//     <action android:name="android.intent.action.VIEW" />
//     <data android:scheme="https" />
//   </intent>
//   <!-- If your app makes calls -->
//   <intent>
//     <action android:name="android.intent.action.DIAL" />
//     <data android:scheme="tel" />
//   </intent>
//   <!-- If your sends SMS messages -->
//   <intent>
//     <action android:name="android.intent.action.SENDTO" />
//     <data android:scheme="smsto" />
//   </intent>
//   <!-- If your app sends emails -->
//   <intent>
//     <action android:name="android.intent.action.SEND" />
//     <data android:mimeType="*/*" />
// </intent>
// </queries>

/// opens http or https URL with browser
void launchBrowser() async {
  String url = 'https://flutter.dev';
  if (!await launch(url)) {
    print('Could not launch $url');
  }
}

/// opens mail app with recipient, subject, body
void launchMail() async {
  final Uri emailLaunchUri = Uri(
    scheme: 'mailto',
    path: 'smith@example.com', // TODO: change recipient
    query: encodeQueryParameters(<String, String>{
      'subject': 'Example Subject & Symbols are allowed!', // TODO: change subject
      'body': 'This is an awesome body', // TODO: change body
    }),
  );

  if (!await launch(emailLaunchUri.toString())) {
    print('Could not launch ${emailLaunchUri.toString()}');
  }
}

/// helper function
String? encodeQueryParameters(Map<String, String> params) {
  return params.entries
      .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
      .join('&');
}

/// opens SMS app with body
void launchSMS() async {
  String phoneNumber = "123456789"; // TODO: change number
  Uri uri = Uri(
    scheme: 'sms',
    path: phoneNumber,
    query: encodeQueryParameters(<String, String>{
      'body': 'Hey this is message body', // TODO: change body
    }),
  );

  if (await canLaunch(uri.toString())) {
    await launch(uri.toString());
  } else {
    print('Could not launch ${uri.toString()}');
  }
}

/// opens the phone dialer
void launchPhone() async {
  String phoneNumber = "123456789"; // TODO: change number
  String url = "tel:$phoneNumber";
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    print('Could not launch $url');
  }
}

/// Opens Facetime on iOS.
/// For Android, use another package.
void launchVideoCall() async {
  if (Platform.isAndroid) {
    /// use: https://pub.dev/packages/android_intent_plus
  } else if (Platform.isIOS) {
    String phoneNumber = "123456789"; // TODO: change number
    final String url = 'facetime:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }
}

/// opens file on Windows, macOS, Linux
void launchFile() async {
  var filePath = '/path/to/file'; // TODO: change file path
  final Uri uri = Uri.file(filePath);

  if (await File(uri.toFilePath()).exists()) {
    if (!await launch(uri.toString())) {
      print('Could not launch $uri');
    }
  }
}



