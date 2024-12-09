import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

void main() => runApp(MP3PlayerApp());

class MP3PlayerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MP3 Player',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MP3PlayerScreen(),
    );
  }
}

class MP3PlayerScreen extends StatefulWidget {
  @override
  _MP3PlayerScreenState createState() => _MP3PlayerScreenState();
}

class _MP3PlayerScreenState extends State<MP3PlayerScreen> {
  final AudioPlayer _audioPlayer1 = AudioPlayer();
  final AudioPlayer _audioPlayer2 = AudioPlayer();
  bool _isPlaying1 = false;
  bool _isPaused1 = false;
  bool _isPlaying2 = false;
  bool _isPaused2 = false;
  Duration _duration1 = Duration.zero;
  Duration _position1 = Duration.zero;
  Duration _duration2 = Duration.zero;
  Duration _position2 = Duration.zero;

  @override
  void initState() {
    super.initState();

    // Listen for duration changes for song 1
    _audioPlayer1.onDurationChanged.listen((newDuration) {
      setState(() {
        _duration1 = newDuration;
      });
    });

    // Listen for position changes for song 1
    _audioPlayer1.onPositionChanged.listen((newPosition) {
      setState(() {
        _position1 = newPosition;
      });
    });

    // Listen for duration changes for song 2
    _audioPlayer2.onDurationChanged.listen((newDuration) {
      setState(() {
        _duration2 = newDuration;
      });
    });

    // Listen for position changes for song 2
    _audioPlayer2.onPositionChanged.listen((newPosition) {
      setState(() {
        _position2 = newPosition;
      });
    });
  }

  @override
  void dispose() {
    _audioPlayer1.dispose();
    _audioPlayer2.dispose();
    super.dispose();
  }

  Future<void> _playPause1() async {
    const audioPath1 = 'sounds/music.mp3';

    try {
      if (_isPlaying1) {
        if (_isPaused1) {
          // Resume the audio
          await _audioPlayer1.resume();
        } else {
          // Pause the audio
          await _audioPlayer1.pause();
          setState(() {
            _isPaused1 = true;
          });
        }
      } else {
        // Play the asset audio file
        await _audioPlayer1.play(AssetSource(audioPath1));
        setState(() {
          _isPaused1 = false;
        });
      }

      setState(() {
        _isPlaying1 = !_isPlaying1;
      });
    } catch (e) {
      print('Error: ${e.toString()}');
    }
  }

  Future<void> _playPause2() async {
    const audioPath2 = 'sounds/music2.mp3';

    try {
      if (_isPlaying2) {
        if (_isPaused2) {
          // Resume the audio
          await _audioPlayer2.resume();
        } else {
          // Pause the audio
          await _audioPlayer2.pause();
          setState(() {
            _isPaused2 = true;
          });
        }
      } else {
        // Play the asset audio file
        await _audioPlayer2.play(AssetSource(audioPath2));
        setState(() {
          _isPaused2 = false;
        });
      }

      setState(() {
        _isPlaying2 = !_isPlaying2;
      });
    } catch (e) {
      print('Error: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MP3 Player'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Song 1 UI
            Text(
              'Motivational Song',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Slider(
              min: 0,
              max: _duration1.inSeconds.toDouble(),
              value: _position1.inSeconds.toDouble().clamp(0, _duration1.inSeconds.toDouble()),
              onChanged: (value) async {
                final position = Duration(seconds: value.toInt());
                await _audioPlayer1.seek(position);
                setState(() {
                  _position1 = position;
                });
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_formatDuration(_position1)),
                Text(_formatDuration(_duration1)),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _playPause1,
              child: Text(_isPlaying1 ? 'Pause' : 'Play'),
            ),
            SizedBox(height: 40),
            // Song 2 UI
            Text(
              'Pep Talk',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Slider(
              min: 0,
              max: _duration2.inSeconds.toDouble(),
              value: _position2.inSeconds.toDouble().clamp(0, _duration2.inSeconds.toDouble()),
              onChanged: (value) async {
                final position = Duration(seconds: value.toInt());
                await _audioPlayer2.seek(position);
                setState(() {
                  _position2 = position;
                });
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_formatDuration(_position2)),
                Text(_formatDuration(_duration2)),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _playPause2,
              child: Text(_isPlaying2 ? 'Pause' : 'Play'),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to format duration
  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
