/*===================================================================================

	NOTE FROM DAWSON: I LEFT THE GROUP. I DIDN'T THINK THAT THE PROJECT
	WAS BIG ENOUGH FOR 6 PEOPLE. SORRY FOR ANY PROBLEMS THIS CREATES.

	Author: Bryan Newsom, Ali Hakimi, Colin Zohoori, Parker Evans, Evan Roncevich... (Fill in your names)

	Date: 4/22/2013

	Purpose: Final Game project for CSCI-2400 with Gabe Johnson
				At CU Boulder Spring Semester 2013

	Description: This is the classic hangman game. One user enters
	the word which they would like their friend to be guessing and
	for the rest of the game the friend tries to guess one character
	at a time until he has won	


====================================================================================*/	





using namespace std;
#include <iostream>
//#include <ctype.h>
//#include <stdio.h>
#include "hangman.hpp"



//Here are the functions we are making:
//The main is at the bottom of this file
//Constructor
Hangman::Hangman(){
	hasWon = false;
	wrongNum = 0;
	max_wrong = 6;
	deathType = 1;
	ai = false;
	Parker = new AI();
}


void Hangman::clearDisplay(){
	for(int i=0;i<75;++i){
		cout << endl;
	}
}
//asks player to enter a word
void Hangman::askWord(){
	 getline (cin, answer);//answer is now the word they entered
	
	for(int i=0; i<answer.size();++i){
		answer.at(i)=tolower(answer.at(i));
	}display = answer;
	for(int i=0; i<display.size();++i){
		if(isalpha(display.at(i))!=0){
			display.replace(i,1,"_");
		}
	}
	clearDisplay();
}
//displays word with letters if known, or underscores otherwise with spaces in between
void Hangman::displayWord(){
	for(int i=0;i<display.size();++i){
		cout << display.at(i) << + " ";
	}cout << "!" << endl;
	cout << "Number of wrong guesses: " << wrongNum<< endl;
	if(answer.compare(display)==0){
		cout <<"A winner is You!" << endl;
		hasWon =true;
		cout << "  \\O/ " << endl;
		cout << "   |" << endl;
		cout << "  / \\" << endl;
	}
}

void Hangman::askAI()
{
   int value;
   cout << "Would you like to use the AI or play yourself? " << endl;
   cout << "Enter 1 for AI or 2 for player " << endl;

	cin >> value;
	if(value == 1)
		ai = true;
	else
		ai = false;
}

void Hangman::askChar(){
	//clearDisplay();
	char guess;

	if(ai == false) //if NOT AI
	{
	cout << "Enter a letter: ";
	cin >> guess;
	}
	else //Using the AI
	{
		guess = Parker->nextLetter(display);
	}
	guess = tolower(guess);
	if(isalpha(guess)==0){
		cout << "That isn't a letter! Try again" << endl;
		askChar();
		return;
	}
	cout << "You guessed: "<< guess << endl;
	checkLetter(guess);

}

void Hangman::checkLetter(char letter){
	bool isThere =false;
	for(int i=0;i<guessed.size();++i){
		if(guessed[i] == letter){
			cout << "You already guessed " << letter << endl;
			isThere = true;
		}
	}
	if(!isThere){
		bool found =false;
		guessed.push_back(letter);
		for(int i=0; i<answer.size();++i){
			if(answer.at(i)== letter){
				display.at(i)=letter;
				found=true;
			}
		}
		if(!found){
			++wrongNum;
		}
		clearDisplay();
		displayWord();


	}else{
		askChar();
	}
}

void Hangman::setDeathType(){
  int death;
  cout << "Enter the way in which you would like this man to die:" << endl;
  cout << "1: Death by Hanging" << endl;
  cout << "2: Death by Guillotine" << endl;
  cin >> death;
  this->deathType = death;
}

bool Hangman::getDead(){
  if (wrongNum == max_wrong){
    if (deathType == HANGING){
      cout << "________ " << endl;
      cout << "|   | " << endl;
      cout << "|   O " << endl;
      cout << "|  /|\\" << endl;
      cout << "|  / \\" << endl;
      cout << "|" << endl;
      cout << "-" << endl;
    }
    if (deathType == GUILLOTINE){
      cout << "   | " << endl;
      cout << "   | " << endl;
      cout << "   |  " << endl;
      cout << "   |   " << endl;
      cout << "   |  " << endl;
      cout << " __|__   o  " << endl;
      cout << "|_____|" << endl;
    }
    cout << " He dead." << endl;
    return true;
  }
  if (wrongNum == max_wrong-1){
    if(deathType == HANGING){
      cout << "________ " << endl;
      cout << "|   | " << endl;
      cout << "|   O " << endl;
      cout << "|  /|\\" << endl;
      cout << "|  / " << endl;
      cout << "|" << endl;
      cout << "-" << endl;
    }
    if (deathType == GUILLOTINE){
      cout << "   | " << endl;
      cout << "   | " << endl;
      cout << "   |  " << endl;
      cout << "   |   " << endl;
      cout << "   |  " << endl;
      cout << " __o__     " << endl;
      cout << "|_____|" << endl;
    }
    return false;
  }
  if (wrongNum == max_wrong-2){
    if(deathType == HANGING){
      cout << "________ " << endl;
      cout << "|   | " << endl;
      cout << "|   O " << endl;
      cout << "|  /|\\" << endl;
      cout << "| " << endl;
      cout << "|" << endl;
      cout << "-" << endl;
    }
    if(deathType == GUILLOTINE){
      cout << "   | " << endl;
      cout << "   | " << endl;
      cout << "   |  " << endl;
      cout << "   |   " << endl;
      cout << "     " << endl;
      cout << " __o__     " << endl;
      cout << "|_____|" << endl;
    }      
    return false;
  }
  if (wrongNum== max_wrong-3){
    if (deathType == HANGING){
      cout << "________ " << endl;
      cout << "|   | " << endl;
      cout << "|   O " << endl;
      cout << "|  /|" << endl;
      cout << "| " << endl;
      cout << "|" << endl;
      cout << "-" << endl;
    }
    if(deathType == GUILLOTINE){
      cout << "   | " << endl;
      cout << "   | " << endl;
      cout << "   |  " << endl;
      cout << "      " << endl;
      cout << "     " << endl;
      cout << " __o__     " << endl;
      cout << "|_____|" << endl;
    }      
    return false;
  }
  if (wrongNum == max_wrong-4){
    if(deathType == HANGING){
      
      cout << "________ " << endl;
      cout << "|   | " << endl;
      cout << "|   O " << endl;
      cout << "|   |" << endl;
      cout << "| " << endl;
      cout << "|" << endl;
      cout << "-" << endl;
    }
    if(deathType == GUILLOTINE){
      cout << "   | " << endl;
      cout << "   | " << endl;
      cout << "     " << endl;
      cout << "      " << endl;
      cout << "     " << endl;
      cout << " __o__     " << endl;
      cout << "|_____|" << endl;
    }      
    return false;
  }
  if (wrongNum== max_wrong-5){
    if (deathType == HANGING){
      cout << "________ " << endl;
      cout << "|   | " << endl;
      cout << "|   O " << endl;
      cout << "| " << endl;
      cout << "| " << endl;
      cout << "|" << endl;
      cout << "-" << endl;
    }
    if(deathType == GUILLOTINE){
      cout << "   | " << endl;
      cout << "    " << endl;
      cout << "     " << endl;
      cout << "      " << endl;
      cout << "     " << endl;
      cout << " __o__     " << endl;
      cout << "|_____|" << endl;
    }      

    return false;
  }
  if (wrongNum <= max_wrong-6){
    if(deathType == HANGING){
      cout << "________ " << endl;
      cout << "|   | " << endl;
      cout << "|    " << endl;
      cout << "|  " << endl;
      cout << "|  " << endl;
      cout << "|" << endl;
      cout << "-" << endl;
    }
    if(deathType == GUILLOTINE){
      cout << "    " << endl;
      cout << "    " << endl;
      cout << "     " << endl;
      cout << "      " << endl;
      cout << "     " << endl;
      cout << " __o__     " << endl;
      cout << "|_____|" << endl;
    }      

    return false;
  }
    
  return true;
}


string Hangman::getAnswer(){
	return answer;
}
bool Hangman::isWinner(){
	return hasWon;
}
bool Hangman::isDead(){
	return (wrongNum>=6);
}

//THIS IS ALL AI STUFF BIZNITCH


AI::AI(){
	firstGuess = "zqxjkvbwpygumcfldhsirnoate";
	letterPairs = "thheanineronreedndhaatenesofnteatitoioleisouarasdertveseoralteco";
	lastGuess = NULL;
}


/*
char AI::nextLetter(){
/*	if (this.currentGuess==NULL)	
	for (int i = 0 ; i < display.size() ; i++ ){
		if (this.currentGuess == display[i])
			//iterate thru letter pairs

	//cout << "I AM PARKER AI" << endl;	
	//cout << "First guess:" << firstGuess << endl;
	char guess = firstGuess[firstGuess.size()-1];
	//cout << " I AM THE SECOND VERSION OF PARKER AI " <<endl;
	firstGuess.erase(firstGuess.size()-1);
	return guess;
}

*/

char AI::nextLetter(string display){	
	if(lastGuess == NULL){
		return simpleNL();
	}
	for (int i = 0 ; i < display.size() ; i++ ){
		if (lastGuess == display[i]){
			//iterate thru letter pairs
			for(int n = 0 ; n < letterPairs.size() ; n++){
				if(lastGuess == letterPairs[n]){
					if(n % 2 == 0 || n == 0){
						if (i == display.size()-1){
							return simpleNL();
						}
						lastGuess = letterPairs[n+1];
						return letterPairs[n+1];
					}
					else{
						if (i == 0)
							return simpleNL();
						lastGuess = letterPairs[n-1];
						return letterPairs[n-1];
					}
				}
			}
		}
	}
	return simpleNL();
}

char AI::simpleNL(){
	char guess = firstGuess[firstGuess.size()-1];
	firstGuess.erase(firstGuess.size()-1);
	lastGuess = guess;
	return guess;
}



int main(){

Hangman my_game;//create an instance of the class
//mygame.askWord();
//print welcome message and take in user input
 int death = 3;

 my_game.clearDisplay();
 cout << "Welcome to hangman" << endl;
 // my_game.setDeathType();

 cout << "Enter the word you or your friend will try and guess: ";
 my_game.askWord();

 my_game.askAI();
 my_game.setDeathType();
 my_game.clearDisplay();

 my_game.displayWord();

 
 while(!(my_game.isWinner())){
   //my_game.clearDisplay();
   if(my_game.getDead()){
     //cout << "You died!" << endl;
     break;
   }
   my_game.askChar();
 }
 
 
/*
  
  Variables we will use:
	
  Vectors:
  Alphabet
  

Strings:	
	answer (The string inputted in the beginning/the word to guess)

	
Int:
	wrong_answer_count
	max_wrong_guesses_possible


Char:
	current_guess (The letter the kiddos think is in the answer)


Booleans:
	is_dead

Function names:
	get_dead (returns whether the player is dead(used up all turns))
	
	//iterates through the string answer to see if char current_guess is within it
	void contains (


*/



}










