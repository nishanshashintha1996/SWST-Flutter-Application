import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_ibm_watson/flutter_ibm_watson.dart';
import 'package:flutter_ibm_watson/services/textToSpeech.dart';
import 'package:flutter_ibm_watson/utils/IamOptions.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Voice',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.cyan,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SpeechScreen(),
    );
  }
}

class SpeechScreen extends StatefulWidget {
  @override
  _SpeechScreenState createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  final Map<String, HighlightedWord> _highlights = {};

  stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = 'Press the button and start speaking';

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        // title: new FlutterLogo(
        //   colors: Colors.green,
        //   size: 25.0,
        // ),
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.arrow_back),
          color: Colors.grey,
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.menu),
            color: Colors.grey,
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: _isListening,
        glowColor: Theme.of(context).primaryColor,
        endRadius: 75.0,
        duration: const Duration(milliseconds: 2000),
        repeatPauseDuration: const Duration(milliseconds: 100),
        repeat: true,
        child: FloatingActionButton(
          onPressed: _listen,
          child: Icon(_isListening ? Icons.mic : Icons.mic_none),
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                alignment: Alignment(0.0, -0.40),
                padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                height: 100.0,
                color: Colors.white,
                child: TextHighlight(
                  text: _text,
                  words: _highlights,
                  textStyle: const TextStyle(
                    fontSize: 15.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(25.0, 130.0, 25.0, 0.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(blurRadius: 10.0, color: Colors.grey)
                    ]),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.fromLTRB(25.0, 25.0, 5.0, 5.0),
                          child: Text(
                            'Stress Level',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14.0,
                              fontFamily: 'Quickstand',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(25.0, 40.0, 5.0, 25.0),
                          child: Text(
                            '10%',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 35.0,
                              fontFamily: 'Quickstand',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      width: 125.0,
                    ),
                    Container(
                      height: 50.0,
                      width: 125.0,
                      decoration: BoxDecoration(
                          color: Colors.greenAccent[100],
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Center(
                        child: Text(
                          'Good Mentality',
                          style: TextStyle(
                              fontFamily: 'Quickstand',
                              fontWeight: FontWeight.bold,
                              color: Colors.green),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _listen() async {
    final FlutterTts flutterTts = FlutterTts();
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            if (val.recognizedWords == "") {
              _text = "Say Hello";
            }
            if (val.recognizedWords == "hello") {
              _text = "Listning.....";
              flutterTts.speak(
                  "How Are You ,What is your name and how can I help you?");
            }
            if (val.recognizedWords == "how are you" ||
                val.recognizedWords == "I am fine how are you" ||
                val.recognizedWords == "I am ok how are you" ||
                val.recognizedWords == "fine" ||
                val.recognizedWords == "I am good how are you") {
              _text = "Listning.....";
              flutterTts.speak("Cool, So how can I help you");
            }
            if (val.recognizedWords == "I need a help from you" ||
                val.recognizedWords == "I need a help" ||
                val.recognizedWords == "Can you help me" ||
                val.recognizedWords == "help" ||
                val.recognizedWords == "help me") {
              _text = "Listning.....";
              flutterTts.speak("How can I help you");
            }
            if (val.recognizedWords == "I can't  understand some notes" ||
                val.recognizedWords == "I have lost motivation for the exam." ||
                val.recognizedWords == "I got a low-grade last semester." ||
                val.recognizedWords == "I haven't time to study." ||
                val.recognizedWords == "I don't feel prepared.") {
              _text = "Listning.....";
              flutterTts.speak("How are your studies going?");
            }
            if (val.recognizedWords == "I am fine" ||
                val.recognizedWords == "I am good" ||
                val.recognizedWords == "Not bad" ||
                val.recognizedWords == "I am really good" ||
                val.recognizedWords == "All right") {
              _text = "Listning.....";
              flutterTts.speak(
                  "All right. what are the problems do you have related to the exam?");
            }
            if (val.recognizedWords == "Fine" ||
                val.recognizedWords == "They’re going fine." ||
                val.recognizedWords == "I’m doing well." ||
                val.recognizedWords == "Hard to do" ||
                val.recognizedWords == "I have some doubts") {
              _text = "Listning.....";
              flutterTts.speak("I got it. Your have lots of works");
            }
            if (val.hasConfidenceRating && val.confidence > 0) {}
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _text = "Say Hello.....";
      _speech.stop();
    }
  }
}
