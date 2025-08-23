import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GuessTheNumber extends StatefulWidget {
  const GuessTheNumber({super.key});

  @override
  State<GuessTheNumber> createState() => _GuessTheNumberState();
}

class _GuessTheNumberState extends State<GuessTheNumber> {
  final TextEditingController guessNumberController = TextEditingController();
  int randomNumber = 0; // Stored random number
  String resultText = "";
  int attempts = 0;
  int highScore =0;
  bool isNumberVisible= false;

// Generate new random number
  @override
  void initState() {
    super.initState();
    randomNumber = Random().nextInt(100) + 1;
    resultText ="Guess the right number";
    guessNumberController.clear();
    _loadHighScore();
  }

// Load high score from SharedPreferences
  void _loadHighScore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      highScore = prefs.getInt('highScore') ?? 0;
    });
  }

  // Save high score to SharedPreferences
  void _saveHighScore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('highScore', highScore);
  }

 //generate new number
  void generateNewNumber() {
    setState(() {
      randomNumber = Random().nextInt(100) + 1;
      attempts=0;
      resultText = "New Number generated";
      isNumberVisible =false;
      guessNumberController.clear(); // Clear input field
    });
  }

// Compare user's guess with random number
  void compareNumbers() {
    String input = guessNumberController.text;
    if (input.isEmpty) return;

    int guessedNumber = int.tryParse(input) ?? 0;

    setState(() {
      attempts ++;
      if (guessedNumber < randomNumber) {
        if (randomNumber - guessedNumber <= 2) {
          resultText = " low! You are very close!\n Attempts:$attempts";
        } else if (randomNumber - guessedNumber <= 4) {
          resultText = "Low! You are close!\n Attempts:$attempts";
        } else {
          resultText = " Too low! Try again.\n Attempts:$attempts";
        }
      } else if (guessedNumber > randomNumber) {
        if (guessedNumber - randomNumber <= 2) {
          resultText = "high! You are very close!\n Attempts:$attempts";
        } else if (guessedNumber - randomNumber <= 4) {
          resultText = "High! You are close!\n Attempts:$attempts";
        } else {
          resultText = "Too high! Try again.\n Attempts:$attempts";

        }
      } else {
        resultText = "Correct! You guessed it in\n $attempts attempts!";
        if (highScore==0|| highScore>attempts){
          highScore =attempts;
          _saveHighScore();
        }
      }
    });

    guessNumberController.clear();
  }

// Show the current random number
  void showNumber() {
    setState(() {
      resultText = "Generated number: $randomNumber";
    });
  }

//Reset high score.
void resetHighScore()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('highScore');
    setState(() {
      highScore=0;
    });
}

//toggle button
  void toggleVisibility(){
    setState(() {
      isNumberVisible =! isNumberVisible;
      if(isNumberVisible){
        resultText="Generated Nummber: $randomNumber";
      }
      else {
        resultText = "Guess the right number";
      }
    });
  }

  @override
  void dispose() {
    guessNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
              children: [
                const SizedBox(height: 40),
                Image.asset(
                  'images/logo.png',
                  height: 250,
                  width: double.infinity,
                ),
                const SizedBox(height: 10),
                const Text(
                  "Guess The Number",
                  style: TextStyle(fontSize: 30, color: Colors.black),
                ),
                const SizedBox(height: 20),

// TextField
                TextField(
                  controller: guessNumberController,
                  decoration: InputDecoration(
                    labelText: "Guess The Number",
                    labelStyle: const TextStyle( color: Colors.black,fontSize: 15),
                    floatingLabelStyle:  const TextStyle( color: Colors.black,fontSize: 15),

                    hintText: "Enter a number between 1 and 100",
                    hintStyle: const TextStyle(color: Colors.black38, fontSize: 16),

                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.black,width: 01),
                    ),

                    focusedBorder:OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.black,width: 01),
                    ),

                  ),
                  style: const TextStyle(fontSize: 20),
                  keyboardType: TextInputType.number,

                ),


                const SizedBox(height: 10),
// guess button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: TextButton(
                    onPressed: compareNumbers,
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text(
                      "Guess",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

// Result Box
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          resultText,
                          style: const TextStyle(fontSize: 20, color: Colors.black),
                          textAlign: TextAlign.center,
                        ),

                        SizedBox(height: 30,),
                        RichText(
                            text: TextSpan(
                                children: [
                                  TextSpan(
                                      text: "High Score:",
                                      style: TextStyle(
                                        fontSize: 30,
                                        color: Colors.black,

                                      )
                                  ),

                                  TextSpan(
                                    text: " $highScore",
                                    style: TextStyle(
                                      fontSize: 30,
                                      color: Colors.red,
                                    ),

                                  ),
                                ]
                            )
                        )

                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

// Generate New Number Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: generateNewNumber,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)
                          ),
                          padding:EdgeInsets.symmetric(horizontal: 10)
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: const Text(
                            "Generate New Number",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ),
                    ),
/*
//Show The Number
                    SizedBox(width: 2,),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: showNumber,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: const Text(
                            "Show The Number",
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white

                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ),
                    ),*/
//toggle button
                    SizedBox(width: 3,),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: toggleVisibility,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            isNumberVisible? "Hide The Number" : "Show The Number",
                            style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white

                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
//"Reset High Score"
                    ElevatedButton(
                      onPressed: resetHighScore,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: const Text(
                          "Reset High Score",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white

                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),
                  ],
                )



              ]
          ),
        )
    );
  }
}
