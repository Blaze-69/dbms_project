class Song {
  final String songName;
  final String artist;
  final String image;
  final int id;

  Song({this.id, this.songName, this.artist, this.image});
}

List<Song> songs = [
  Song(
      id: 1,
      songName: 'Back to Life',
      image: "assets/G.jpg",
      artist: 'DubVision'),
  Song(
      id: 2,
      songName: 'Help me lose my mind',
      image: "assets/G.jpg",
      artist: 'Disclosure'),
  Song(
      id: 3,
      songName: 'A million dreams',
      image: "assets/G.jpg",
      artist: 'Ziv Zaifman'),
  Song(
      id: 4,
      songName: 'Treat you better',
      image: "assets/G.jpg",
      artist: 'Paperwhite'),
  Song(id: 5, songName: 'Let it go', image: "assets/G.jpg", artist: 'Demi'),
  Song(id: 6, songName: 'Found you', image: "assets/G.jpg", artist: 'Austin'),
  Song(id: 7, songName: 'Shallow', image: "assets/G.jpg", artist: 'Lady Gaga'),
  Song(id: 8, songName: 'Photograph', image: "assets/G.jpg", artist: 'Peter'),
];
