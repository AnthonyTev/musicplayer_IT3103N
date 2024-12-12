import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:music_playlist/components/my_drawer.dart';
import 'package:music_playlist/models/playlist_provider.dart';
import 'package:music_playlist/models/song.dart';
import 'package:music_playlist/pages/song_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final PlaylistProvider playlistProvider;

  @override
  void initState() {
    super.initState();
    playlistProvider = Provider.of<PlaylistProvider>(context, listen: false);
  }

  void goToSong(int songIndex) {
    playlistProvider.currentSongIndex = songIndex;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SongPage(),
      ),
    );
  }

  Future<List<Song>> searchSpotify(String query) async {
    final String clientId = dotenv.env['SPOTIFY_CLIENT_ID']!;
    final String clientSecret = dotenv.env['SPOTIFY_CLIENT_SECRET']!;

    // Obtain Spotify API token
    final tokenResponse = await http.post(
      Uri.parse('https://accounts.spotify.com/api/token'),
      headers: {
        'Authorization': 'Basic ${base64Encode(utf8.encode('$clientId:$clientSecret'))}',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {'grant_type': 'client_credentials'},
    );

    final token = json.decode(tokenResponse.body)['access_token'];

    // Search for tracks on Spotify
    final response = await http.get(
      Uri.parse('https://api.spotify.com/v1/search?q=$query&type=track&limit=10'),
      headers: {'Authorization': 'Bearer $token'},
    );

    final tracks = json.decode(response.body)['tracks']['items'] as List;

    // Map Spotify tracks to Song objects
    return tracks.map<Song>((track) {
      return Song(
        songName: track['name'],
        artistName: track['artists'][0]['name'],
        albumArtImagePath: track['album']['images'][0]['url'],
        audioPath: "", // Placeholder; Spotify doesn't provide direct audio paths
      );
    }).toList();
  }

  void addSpotifySongs() async {
    final searchQuery = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        String query = "";
        return AlertDialog(
          title: const Text("Search Spotify"),
          content: TextField(
            onChanged: (value) => query = value,
            decoration: const InputDecoration(hintText: "Enter song or artist name"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, query),
              child: const Text("Search"),
            ),
          ],
        );
      },
    );

    if (searchQuery != null && searchQuery.isNotEmpty) {
      try {
        final songs = await searchSpotify(searchQuery);
        setState(() {
          playlistProvider.addSongs(songs);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Songs added to playlist")),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to fetch songs from Spotify")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text("P L A Y L I S T"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: addSpotifySongs,
          ),
        ],
      ),
      drawer: const MyDrawer(),
      body: Consumer<PlaylistProvider>(
        builder: (context, value, child) {
          final List<Song> playlist = value.playlist;

          return ListView.builder(
            itemCount: playlist.length,
            itemBuilder: (context, index) {
              final Song song = playlist[index];

              return ListTile(
                title: Text(song.songName),
                subtitle: Text(song.artistName),
                leading: Image.network(
                  song.albumArtImagePath,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.music_note),
                ),
                onTap: () => goToSong(index),
              );
            },
          );
        },
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:music_playlist/components/my_drawer.dart';
// import 'package:music_playlist/models/playlist_provider.dart';
// import 'package:music_playlist/models/song.dart';
// import 'package:music_playlist/pages/song_page.dart';
// import 'package:provider/provider.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   late final dynamic playlistProvider;

//   @override
//   void initState() {
//     super.initState();
//     playlistProvider = Provider.of<PlaylistProvider>(context, listen: false);
//   }

//   // Function to search Spotify
//   Future<List<Song>> searchSpotify(String query) async {
//     final String clientId = dotenv.env['SPOTIFY_CLIENT_ID']!;
//     final String clientSecret = dotenv.env['SPOTIFY_CLIENT_SECRET']!;

//     // Get Spotify API token
//     final tokenResponse = await http.post(
//       Uri.parse('https://accounts.spotify.com/api/token'),
//       headers: {
//         'Authorization': 'Basic ${base64Encode(utf8.encode('$clientId:$clientSecret'))}',
//         'Content-Type': 'application/x-www-form-urlencoded',
//       },
//       body: {'grant_type': 'client_credentials'},
//     );

//     final token = json.decode(tokenResponse.body)['access_token'];

//     // Search Spotify
//     final response = await http.get(
//       Uri.parse('https://api.spotify.com/v1/search?q=$query&type=track&limit=10'),
//       headers: {'Authorization': 'Bearer $token'},
//     );

//     final tracks = json.decode(response.body)['tracks']['items'] as List;

//     // Map Spotify tracks to Song objects
//     return tracks.map((track) {
//       return Song(
//         songName: track['name'],
//         artistName: track['artists'][0]['name'],
//         albumArtImagePath: track['album']['images'][0]['url'], // Spotify album art
//       );
//     }).toList();
//   }

//   // Add music from Spotify
//   void addMusicFromSpotify() async {
//     showDialog(
//       context: context,
//       builder: (context) {
//         String query = "";
//         List<Song> searchResults = [];

//         return StatefulBuilder(
//           builder: (context, setState) {
//             return AlertDialog(
//               title: const Text("Search Spotify"),
//               content: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   TextField(
//                     decoration: const InputDecoration(labelText: "Search for a song"),
//                     onChanged: (value) => query = value,
//                   ),
//                   ElevatedButton(
//                     onPressed: () async {
//                       final results = await searchSpotify(query);
//                       setState(() {
//                         searchResults = results;
//                       });
//                     },
//                     child: const Text("Search"),
//                   ),
//                   if (searchResults.isNotEmpty)
//                     Expanded(
//                       child: ListView.builder(
//                         shrinkWrap: true,
//                         itemCount: searchResults.length,
//                         itemBuilder: (context, index) {
//                           final song = searchResults[index];
//                           return ListTile(
//                             title: Text(song.songName),
//                             subtitle: Text(song.artistName),
//                             leading: Image.network(song.albumArtImagePath),
//                             onTap: () {
//                               playlistProvider.addSong(song);
//                               Navigator.pop(context); // Close dialog
//                             },
//                           );
//                         },
//                       ),
//                     ),
//                 ],
//               ),
//               actions: [
//                 TextButton(
//                   onPressed: () => Navigator.pop(context),
//                   child: const Text("Close"),
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }

//   void goToSong(int songIndex) {
//     playlistProvider.currentSongIndex = songIndex;
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => const SongPage()),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.surface,
//       appBar: AppBar(title: const Text("P L A Y L I S T")),
//       drawer: const MyDrawer(),
//       body: Consumer<PlaylistProvider>(
//         builder: (context, value, child) {
//           final List<Song> playlist = value.playlist;
//           return ListView.builder(
//             itemCount: playlist.length,
//             itemBuilder: (context, index) {
//               final Song song = playlist[index];
//               return ListTile(
//                 title: Text(song.songName),
//                 subtitle: Text(song.artistName),
//                 leading: Image.network(song.albumArtImagePath),
//                 onTap: () => goToSong(index),
//               );
//             },
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: addMusicFromSpotify,
//         child: const Icon(Icons.add),
//         tooltip: "Add music from Spotify",
//       ),
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:music_playlist/components/my_drawer.dart';
// import 'package:music_playlist/models/playlist_provider.dart';
// import 'package:music_playlist/models/song.dart';
// import 'package:music_playlist/pages/song_page.dart';
// import 'package:provider/provider.dart';

// class HomePage extends StatefulWidget{
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {

//   // get the playlist provider
//   late final dynamic playlistProvider;

//   @override
//   void initState() {
//     super.initState();

//     // get playlist provider
//     playlistProvider = Provider.of<PlaylistProvider>(context, listen: false);
//   }

//   // goto a song
//   void goToSong(int songIndex) {
//     // update current song index
//     playlistProvider.currentSongIndex = songIndex;

//     // navigate to song page
//     Navigator.push(
//       context, 
//       MaterialPageRoute(builder: (context) => const SongPage(),),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.surface,
//       appBar: AppBar(title: const Text("P L A Y L I S T")),
//       drawer: const MyDrawer(), 
//       body: Consumer<PlaylistProvider>(
//         builder: (context, value, child) {
//           // get the playlist
//           final List<Song> playlist = value.playlist;


//           // return list view UI
//           return ListView.builder(
//             itemCount: playlist.length,
//             itemBuilder: (context, index) {
//               // get individual song
//               final Song song = playlist[index];

//               // return list tile UI
//               return ListTile(
//                 title: Text(song.songName),
//                 subtitle: Text(song.artistName),
//                 leading: Image.asset(song.albumArtImagePath),
//                 onTap: () => goToSong(index),
//               );
//             },
//           );
//         }
//       ),
//     );
//   }
// }