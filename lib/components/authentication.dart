import 'dart:convert';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:http/http.dart' as http;

class AuthenticationService {
  // Spotify Developer App Credentials
  static const String clientId = 'cd9d135f7a064c3ab2db5d290c35e241'; 
  static const String clientSecret = '2e4f279726a949d2847c69bce02517a5'; 
  static const String redirectUri = 'musicplayer://callback'; 
  static const String callbackUrlScheme = 'musicplayer'; 

  // Authenticate Spotify and get authorization code
  Future<String?> authenticateSpotify() async {
    final authUrl =
        'https://accounts.spotify.com/authorize?response_type=code&client_id=$clientId&redirect_uri=$redirectUri&scope=playlist-read-private user-top-read';

    try {
      final result = await FlutterWebAuth2.authenticate(
          url: authUrl, callbackUrlScheme: callbackUrlScheme);
      final code = Uri.parse(result).queryParameters['code'];
      print("Authorization code: $code");
      return code;
    } catch (e) {
      print("Authentication error: $e");
      return null;
    }
  }

  // Exchange the authorization code for an access token
  Future<String?> getAccessToken(String code) async {
    final url = 'https://accounts.spotify.com/api/token';
    final headers = {
      'Authorization': 'Basic ' + base64Encode(utf8.encode('$clientId:$clientSecret')),
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    final body = {
      'grant_type': 'authorization_code',
      'code': code,
      'redirect_uri': redirectUri,
    };

    try {
      final response = await http.post(Uri.parse(url), headers: headers, body: body);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("Access token: ${data['access_token']}");
        return data['access_token'];
      } else {
        print("Failed to get access token: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Error exchanging token: $e");
      return null;
    }
  }
}


// // authentication.dart
// import 'dart:convert';
// import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
// import 'package:http/http.dart' as http;

// class AuthenticationService {
//   // Spotify Developer App Credentials
//   static const String clientId = 'cd9d135f7a064c3ab2db5d290c35e241'; 
//   static const String clientSecret = '2e4f279726a949d2847c69bce02517a5'; // Spotify client secret
//   static const String redirectUri = 'musicplayer://callback'; // The redirect URI registered on Spotify
//   static const String callbackUrlScheme = 'musicplayer'; // The callback URL scheme registered on Spotify

//   // This function initiates the login flow and returns the authorization code
//   Future<String?> authenticateSpotify() async {
//     final authUrl =
//         'https://accounts.spotify.com/authorize?response_type=code&client_id=$clientId&redirect_uri=$redirectUri&scope=playlist-read-private';

//     try {
//       final result = await FlutterWebAuth2.authenticate(url: authUrl, callbackUrlScheme: callbackUrlScheme);
//       final code = Uri.parse(result).queryParameters['code'];
//       return code;
//     } catch (e) {
//       print("Authentication error: $e");
//       return null;
//     }
//   }

//   // This function exchanges the authorization code for an access token
//   Future<String?> getAccessToken(String code) async {
//     final url = 'https://accounts.spotify.com/api/token';
//     final headers = {
//       'Authorization': 'Basic ' + base64Encode(utf8.encode('$clientId:$clientSecret')),
//       'Content-Type': 'application/x-www-form-urlencoded',
//     };

//     final body = {
//       'grant_type': 'authorization_code',
//       'code': code,
//       'redirect_uri': redirectUri,
//     };

//     try {
//       final response = await http.post(Uri.parse(url), headers: headers, body: body);
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         return data['access_token']; // Return the access token
//       } else {
//         print("Failed to get access token: ${response.body}");
//         return null;
//       }
//     } catch (e) {
//       print("Error exchanging token: $e");
//       return null;
//     }
//   }
// }


// import 'dart:convert';
// import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
// import 'package:http/http.dart' as http;

// class AuthenticationService {
//   // Spotify Developer App Credentials
//   static const String clientId = 'cd9d135f7a064c3ab2db5d290c35e241'; 
//   static const String clientSecret = '2e4f279726a949d2847c69bce02517a5'; // Spotify client secret
//   static const String redirectUri = 'musicplayer://callback'; // The redirect URI registered on Spotify
//   static const String callbackUrlScheme = 'musicplayer'; // The callback URL scheme registered on Spotify

//   // This function initiates the login flow and returns the authorization code
//   Future<String?> authenticateSpotify() async {
//     final authUrl =
//         'https://accounts.spotify.com/authorize?response_type=code&client_id=$clientId&redirect_uri=$redirectUri&scope=playlist-read-private';

//     try {
//       final result = await FlutterWebAuth2.authenticate(url: authUrl, callbackUrlScheme: callbackUrlScheme);
//       final code = Uri.parse(result).queryParameters['code'];
//       return code;
//     } catch (e) {
//       print("Authentication error: $e");
//       return null;
//     }
//   }

//   // This function exchanges the authorization code for an access token
//   Future<String?> getAccessToken(String code) async {
//     final url = 'https://accounts.spotify.com/api/token';
//     final headers = {
//       'Authorization': 'Basic ' + base64Encode(utf8.encode('$clientId:$clientSecret')),
//       'Content-Type': 'application/x-www-form-urlencoded',
//     };

//     final body = {
//       'grant_type': 'authorization_code',
//       'code': code,
//       'redirect_uri': redirectUri,
//     };

//     try {
//       final response = await http.post(Uri.parse(url), headers: headers, body: body);
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         return data['access_token']; // Return the access token
//       } else {
//         print("Failed to get access token: ${response.body}");
//         return null;
//       }
//     } catch (e) {
//       print("Error exchanging token: $e");
//       return null;
//     }
//   }
// }
