import 'package:flutter/material.dart';
import 'package:music_playlist/models/playlist_provider.dart';
import 'package:music_playlist/themes/theme_provider.dart';
import 'package:provider/provider.dart';
import 'pages/home_page.dart';
import 'package:music_playlist/components/authentication.dart'; // Import the authentication service
import 'package:music_playlist/components/playlist_service.dart'; // Import playlist service
import 'package:spotify_sdk/spotify_sdk.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => PlaylistProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: themeProvider.themeData,
          home: LoginPage(), // Changed to LoginPage for authentication flow
        );
      },
    );
  }
}

class LoginPage extends StatelessWidget {
  final AuthenticationService authService = AuthenticationService();

  void _login(BuildContext context) async {
    try {
      // Connect to Spotify using Spotify SDK
      await SpotifySdk.connectToSpotifyRemote(
        clientId: 'cd9d135f7a064c3ab2db5d290c35e241', // Replace with your actual Client ID
        redirectUri: 'musicplayer://callback', // Replace with your registered Redirect URI
      );
      print("Connected to Spotify");

      // After connecting, subscribe to the player state to handle changes
      SpotifySdk.subscribePlayerState();

      // Optionally, get the access token for API calls
      final accessToken = await SpotifySdk.getAccessToken(
        clientId: 'cd9d135f7a064c3ab2db5d290c35e241', 
        redirectUri: 'musicplayer://callback',
        scope: 'user-library-read,playlist-read-private', // Add your desired scopes
      );

      if (accessToken != null) {
        print("Access token: $accessToken");

        // Use the access token with PlaylistService
        final playlistService = PlaylistService(accessToken);

        // Fetch playlists and top tracks
        await playlistService.fetchPlaylists();
        await playlistService.fetchTopTracks();

        // Navigate to HomePage after successful login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        print("Failed to retrieve access token");
        _showErrorDialog(context, "Failed to retrieve access token.");
      }
    } catch (e) {
      print("Error: $e");
      _showErrorDialog(context, "Authentication failed. Please try again.");
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login to Spotify")),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _login(context),
          child: const Text("Login with Spotify"),
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:music_playlist/models/playlist_provider.dart';
// import 'package:music_playlist/themes/theme_provider.dart';
// import 'package:provider/provider.dart';
// import 'pages/home_page.dart';
// import 'package:music_playlist/components/authentication.dart'; // Import the authentication service
// import 'package:music_playlist/components/playlist_service.dart'; // Import playlist service
// import 'package:spotify_sdk/spotify_sdk.dart';

// void main() {
//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (context) => ThemeProvider()),
//         ChangeNotifierProvider(create: (context) => PlaylistProvider()),
//       ],
//       child: const MyApp(),
//     ),
//   );
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<ThemeProvider>(
//       builder: (context, themeProvider, child) {
//         return MaterialApp(
//           debugShowCheckedModeBanner: false,
//           theme: themeProvider.themeData,
//           home: LoginPage(), // Changed to LoginPage for authentication flow
//         );
//       },
//     );
//   }
// }

// class LoginPage extends StatelessWidget {
//   final AuthenticationService authService = AuthenticationService();

//   void _login(BuildContext context) async {
//     final code = await authService.authenticateSpotify();
//     if (code != null) {
//       // Exchange the authorization code for an access token
//       final accessToken = await authService.getAccessToken(code);
//       if (accessToken != null) {
//         // Successfully retrieved access token
//         print("Access token: $accessToken");

//         // Use the access token with the PlaylistService
//         final playlistService = PlaylistService(accessToken);

//         // Fetch playlists and top tracks
//         await playlistService.fetchPlaylists();
//         await playlistService.fetchTopTracks();

//         // Optionally navigate to the HomePage or update the app state
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const HomePage()),
//         );
//       } else {
//         // Handle failure in token exchange
//         print("Failed to retrieve access token");
//         _showErrorDialog(context, "Failed to retrieve access token.");
//       }
//     } else {
//       // Handle authentication failure
//       print("Authentication failed!");
//       _showErrorDialog(context, "Authentication failed. Please try again.");
//     }
//   }

//   void _showErrorDialog(BuildContext context, String message) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text("Error"),
//           content: Text(message),
//           actions: [
//             TextButton(
//               child: const Text("OK"),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Login to Spotify")),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () => _login(context),
//           child: const Text("Login with Spotify"),
//         ),
//       ),
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:music_playlist/models/playlist_provider.dart';
// import 'package:music_playlist/themes/theme_provider.dart';
// import 'package:provider/provider.dart';
// import 'pages/home_page.dart';
// import 'package:music_playlist/components/authentication.dart'; // Import the authentication service

// void main() {
//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (context) => ThemeProvider()),
//         ChangeNotifierProvider(create: (context) => PlaylistProvider()),
//       ],
//       child: const MyApp(),
//     ),
//   );
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<ThemeProvider>(
//       builder: (context, themeProvider, child) {
//         return MaterialApp(
//           debugShowCheckedModeBanner: false,
//           theme: themeProvider.themeData,
//           home: const HomePage(), // HomePage could contain a login button for Spotify
//         );
//       },
//     );
//   }
// }

// class LoginPage extends StatelessWidget {
//   final AuthenticationService authService = AuthenticationService();

//   void _login(BuildContext context) async {
//     final code = await authService.authenticateSpotify();
//     if (code != null) {
//       // Now exchange the code for an access token
//       final accessToken = await authService.getAccessToken(code);
//       if (accessToken != null) {
//         // You now have the access token. Proceed with fetching playlists or interacting with Spotify.
//         print("Access token: $accessToken");
//         // Store the access token or update app state as needed
//       }
//     } else {
//       // Handle authentication failure
//       print("Authentication failed!");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Login to Spotify")),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () => _login(context),
//           child: const Text("Login with Spotify"),
//         ),
//       ),
//     );
//   }
// }





























// import 'package:flutter/material.dart';
// import 'package:music_playlist/models/playlist_provider.dart';
// import 'package:music_playlist/themes/theme_provider.dart';
// import 'package:provider/provider.dart';
// import 'pages/home_page.dart';

// void main() {
//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (context) => ThemeProvider()),
//         ChangeNotifierProvider(create: (context) => PlaylistProvider()),
//       ],
//       child: const MyApp(),
//     ),
//   );
// }

// class MyApp extends StatelessWidget { // Ensured the name here matches the instance in main()
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<ThemeProvider>(
//       builder: (context, themeProvider, child) {
//         return MaterialApp(
//           debugShowCheckedModeBanner: false,
//           theme: themeProvider.themeData,
//           home: const HomePage(),
//         );
//       },
//     );
//   }
// }

