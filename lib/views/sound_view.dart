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
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  bool _isPaused = false;

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playPause() async {
    const audioPath =
        'lib/assets/sounds/Bad Game Music_ Double Dribble (Arcade) - National Anthem.mp3';

    try {
      if (_isPlaying) {
        if (_isPaused) {
          // Resume the audio
          await _audioPlayer.resume();
        } else {
          // Pause the audio
          await _audioPlayer.pause();
          setState(() {
            _isPaused = true;
          });
        }
      } else {
        // Play the local asset audio file
        await _audioPlayer.play(DeviceFileSource(audioPath));
        setState(() {
          _isPaused = false;
        });
      }

      setState(() {
        _isPlaying = !_isPlaying;
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
            Icon(
              _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
              size: 100,
              color: Colors.blue,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _playPause,
              child: Text(_isPlaying ? 'Pause' : 'Play'),
            ),
          ],
        ),
      ),
    );
  }
}
