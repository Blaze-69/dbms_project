class Playlist {
  final String playlistName;
  final String image;
  final int id;

  Playlist({this.id, this.playlistName, this.image});
}

List<Playlist> playlists = [
  Playlist(
    id: 1,
    playlistName: 'Arjit Singh',
    image: "assets/G.jpg",
  ),
  Playlist(
    id: 2,
    playlistName: 'Shreya Ghoshal',
    image: "assets/G.jpg",
  ),
  Playlist(
    id: 3,
    playlistName: 'Jalraj',
    image: "assets/G.jpg",
  ),
  Playlist(
    id: 4,
    playlistName: 'Eminem',
    image: "assets/G.jpg",
  ),
];
