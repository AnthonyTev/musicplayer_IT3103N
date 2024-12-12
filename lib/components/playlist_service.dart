import 'dart:convert';
import 'package:http/http.dart' as http;

class PlaylistService {
  final String accessToken;

  PlaylistService(this.accessToken);

  Future<void> fetchPlaylists() async {
    final url = 'https://api.spotify.com/v1/me/playlists'; 

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Fetched playlists: $data');
      } else {
        print('Failed to fetch playlists: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error fetching playlists: $e');
    }
  }

  Future<void> fetchTopTracks() async {
    final url = 'https://api.spotify.com/v1/me/top/tracks';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Fetched top tracks: $data');
      } else {
        print('Failed to fetch top tracks: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error fetching top tracks: $e');
    }
  }
}


// // playlist_service.dart
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class PlaylistService {
//   final String accessToken;

//   PlaylistService({required this.accessToken});

//   Future<void> fetchPlaylists() async {
//   final response = await http.get(
//     Uri.parse('https://api.spotify.com/v1/me/top/artists'), // Or any endpoint
//     headers: {
//       'Authorization': 'Bearer $accessToken',
//     },
//   );

//   if (response.statusCode == 200) {
//     final data = jsonDecode(response.body);
//     print('Fetched playlists: $data');
//   } else {
//     print('Failed to fetch music: ${response.statusCode} - ${response.body}');
//   }
// }

  // // Fetch playlists (you can extend this to fetch different data like songs, artists, etc.)
  // Future<void> fetchPlaylists() async {
  //   final response = await http.get(
  //     Uri.parse('https://api.spotify.com/v1/me/top/artists'),
  //     headers: {
  //       'Authorization': 'Bearer $accessToken',
  //     },
  //   );

  //   if (response.statusCode == 200) {
  //     final data = jsonDecode(response.body);
  //     print('Fetched playlists: $data');
  //   } else {
  //     print('Error fetching playlists');
  //   }
  // }
  
//}
