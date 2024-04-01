import 'package:audio2text/utils/shared.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _speechController = TextEditingController();

  final SpeechToText _speech2Text = SpeechToText();

  final GlobalKey<State<StatefulWidget>> _recordKey = GlobalKey<State<StatefulWidget>>();
  final GlobalKey<State<StatefulWidget>> _speechKey = GlobalKey<State<StatefulWidget>>();

  bool _isRecording = false;

  bool _isAble = true;

  Future<bool> _init() async {
    if (await _speech2Text.initialize()) {
      _isAble = true;
      return true;
    }
    return false;
  }

  @override
  void dispose() {
    _speechController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Stack(
          children: <Widget>[
            Center(
              child: FutureBuilder<bool>(
                future: _init(),
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}", style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor));
                  } else if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      StatefulBuilder(
                        key: _recordKey,
                        builder: (BuildContext context, void Function(void Function()) _) {
                          return InkWell(
                            hoverColor: transparentColor,
                            highlightColor: transparentColor,
                            splashColor: transparentColor,
                            onTap: () async {
                              if (_isAble) {
                                if (_isRecording) {
                                  await _speech2Text.cancel();
                                  _isRecording = false;
                                } else {
                                  await _speech2Text.listen(
                                    onResult: (SpeechRecognitionResult result) => _speechKey.currentState!.setState(
                                      () => _speechController.text = result.recognizedWords,
                                    ),
                                    // ignore: deprecated_member_use
                                    listenMode: ListenMode.dictation,
                                  );
                                  _isRecording = true;
                                }
                                _(() {});
                              }
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                LottieBuilder.asset("assets/lotties/record.json", width: 200, height: 200, reverse: true, animate: _isAble && _isRecording),
                                Text(_isRecording ? "TAP TO STOP" : "TAP TO START", style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor)),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 20),
                      InkWell(
                        hoverColor: transparentColor,
                        highlightColor: transparentColor,
                        splashColor: transparentColor,
                        onTap: () async {
                          await _speech2Text.cancel();
                          _isRecording = false;
                          _recordKey.currentState!.setState(() {});
                          showModalBottomSheet(
                            // ignore: use_build_context_synchronously
                            context: context,
                            backgroundColor: darkColor,
                            builder: (BuildContext context) => Container(
                              padding: const EdgeInsets.all(16),
                              child: Container(
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: darkColor, border: Border.all(width: 2, color: purpleColor)),
                                child: TextField(
                                  style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor),
                                  controller: _speechController,
                                  onChanged: (String value) => _speechKey.currentState!.setState(() {}),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Speech to Text",
                                    hintStyle: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor),
                                    contentPadding: const EdgeInsets.all(4),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: darkColor, border: Border.all(width: 2, color: purpleColor)),
                          constraints: const BoxConstraints(maxWidth: 300),
                          child: StatefulBuilder(
                            key: _speechKey,
                            builder: (BuildContext context, void Function(void Function()) _) {
                              return Text(_speechController.text.trim(), style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor));
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Row(
              children: <Widget>[
                Image.asset("assets/images/logo.png", width: 100, height: 100),
                const Spacer(),
                Text("ELITE SQUAD", style: GoogleFonts.itim(fontSize: 32, fontWeight: FontWeight.w500, color: whiteColor)),
              ],
            )
          ],
        ),
      ),
    );
  }
}
