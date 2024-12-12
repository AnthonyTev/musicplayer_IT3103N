import 'package:flutter/material.dart';
import 'authentication.dart';
import 'playlist_service.dart';
import 'pages/home_page.dart'; // Import the HomePage to navigate after authentication

class SpotifyAuthScreen extends StatefulWidget {
  @override
  _SpotifyAuthScreenState createState() => _SpotifyAuthScreenState();
}

class _SpotifyAuthScreenState extends State<SpotifyAuthScreen> {
  String? accessToken;
  bool isAuthenticated = false;
  bool isLoading = false;

  Future<void> authenticate() async {
    final authService = AuthenticationService();
    setState(() {
      isLoading = true; // Show loading state
    });

    try {
      final code = await authService.authenticateSpotify();
      if (code != null) {
        final token = await authService.getAccessToken(code);
        if (token != null) {
          setState(() {
            accessToken = token;
            isAuthenticated = true;
          });

          // Fetch playlists after successful authentication
          final playlistService = PlaylistService(accessToken!);
          await playlistService.fetchPlaylists();

          // Navigate to HomePage or another screen to display playlists
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        } else {
          _showErrorDialog("Failed to retrieve access token.");
        }
      } else {
        _showErrorDialog("Authentication failed. Please try again.");
      }
    } catch (e) {
      _showErrorDialog("An error occurred during authentication: $e");
    } finally {
      setState(() {
        isLoading = false; // Hide loading state
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Spotify Authentication')),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator() // Show a loader during authentication
            : isAuthenticated
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Authenticated successfully!'),
                      ElevatedButton(
                        onPressed: () {
                          // Navigate to a playlist display screen
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const HomePage()),
                          );
                        },
                        child: const Text('Go to Playlists'),
                      ),
                    ],
                  )
                : ElevatedButton(
                    onPressed: authenticate,
                    child: const Text('Authenticate with Spotify'),
                  ),
      ),
    );
  }
}


// // spotify_auth_screen.dart
// import 'package:flutter/material.dart';
// import 'authentication.dart';
// import 'playlist_service.dart';

// class SpotifyAuthScreen extends StatefulWidget {
//   @override
//   _SpotifyAuthScreenState createState() => _SpotifyAuthScreenState();
// }

// class _SpotifyAuthScreenState extends State<SpotifyAuthScreen> {
//   String? accessToken;
//   bool isAuthenticated = false;

//   Future<void> authenticate() async {
//     final authService = AuthenticationService();
//     final code = await authService.authenticateSpotify();

//     if (code != null) {
//       final token = await authService.getAccessToken(code);
//       if (token != null) {
//         setState(() {
//           accessToken = token;
//           isAuthenticated = true;
//         });
//         // After authentication, you can fetch playlists
//         final playlistService = PlaylistService(accessToken: accessToken!);
//         await playlistService.fetchPlaylists();
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Spotify Authentication')),
//       body: Center(
//         child: isAuthenticated
//             ? Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text('Authenticated successfully!'),
//                   ElevatedButton(
//                     onPressed: () {
//                       // You can now navigate to other screens to show data
//                     },
//                     child: Text('Go to Playlists'),
//                   ),
//                 ],
//               )
//             : ElevatedButton(
//                 onPressed: authenticate,
//                 child: Text('Authenticate with Spotify'),
//               ),
//       ),
//     );
//   }
// }


