/*===================================================================================

	Author: Brian Newsom, ... (Fill in your names)

	Date: 4/22/2013

    Purpose: Final Game project for CSCI-2270 with Gabe Johnson
				At CU Boulder Spring Semester 2013

	Description: This is the classic hangman game. One user enters
	the word which they would like their friend to be guessing and
	for the rest of the game the friend tries to guess one character
	at a time until he has won	


====================================================================================*/	


#ifndef HANGMAN_HPP_
#define HANGMAN_HPP_
#define HANGING 1
#define GUILLOTINE 2

#include <vector>
#include <iostream>

//This will be the header file for the whole project

using namespace std;

class AI;
class Hangman;


//The master class for the Hangman manipulation
class Hangman{

//private and public declarations
private:

	int wrongNum;//whether the user has used all of it's guesses	
	string answer;
	vector<char> guessed;
    bool ai;	
	bool hasWon;
	int deathType;

public:
	
	Hangman();//class constructor
	
	//Member variables
	int wrong_answers;//the amount of wrong answers the user has guessed
	int max_wrong;//the max amount of wrong answers we are going to allow

	//Member functions
	void clearDisplay();
	void askWord();
	void askChar();
	void checkLetter(char letter);
	string getAnswer();
	bool isWinner();
	bool isDead();
	void displayWord();
	void askAI();
	void setDeathType();
	bool getDead();
	string display;
	AI* Parker;
	


};

class AI{
private:
	string firstGuess;
	string letterPairs;
	char lastGuess;
	
public:
	AI();
	char nextLetter(string display);
	char simpleNL();
//

};



#endif 
