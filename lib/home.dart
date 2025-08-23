import 'dart:math';
import 'package:flutter/material.dart';

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

  // Generate new random number
  @override
  void initState() {
    super.initState();
    randomNumber = Random().nextInt(100) + 1;
    resultText ="Guess the right number";
    guessNumberController.clear;
  }
  void generateNewNumber() {
    setState(() {
      randomNumber = Random().nextInt(100) + 1;
      attempts=0;
      resultText = "New Number generated";
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
        if (highScore<attempts){
          highScore =attempts;
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

            // TextField + Guess Button Row
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: guessNumberController,
                    decoration: const InputDecoration(
                      labelText: "Guess The Number",
                      hintText: "Enter a number between 1 and 100",
                      hintStyle: TextStyle(color: Colors.black38, fontSize: 16),
                      border: OutlineInputBorder(),
                    ),
                    style: const TextStyle(fontSize: 20),
                    keyboardType: TextInputType.number,
                  ),
                ),

 /*
 //Show Number Button
                SizedBox(width: 10),
                Container(
                  height:60,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black, width: 1),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: ElevatedButton(
                    onPressed: showNumber,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text(
                      "Show Number",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black
                      ),
                    ),
                  ),
                ),
                */
              ],
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
            SizedBox(
              width: double.infinity,
              height: 50,
              child: SingleChildScrollView(
                child: Row(
                  children: [
                    ElevatedButton(
                      onPressed: generateNewNumber,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text(
                        "Generate New\n Number",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                    SizedBox(width: 2,),
                    ElevatedButton(
                      onPressed: showNumber,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)
                        ),
                      ),
                      child: const Text(
                        "Generate New\n Number",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),

                  ],
                ),
              ),
            ),


          ],
        ),
      ),
    );
  }
}
