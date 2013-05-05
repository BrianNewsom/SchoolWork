//Name- Brian Newsom
//SID- 830372483
//TA- Shaosong Li
//Lecture- White MWF 1 PM
#include<iostream>
#include<cstdlib>
#include<ctime>

using namespace std;

//Generates one of the door numbers of: 1,2,3, . . ., doors
int randGenerator();

//Generates a yes or No answer to the question of if you want to change your door choice.
// Assume that Yes == 1 and No == 0 in this case. 
int yesNoGenerator();
//Chooses a number of doors to run program with
int doors=10;

int main(){

	//Number of correct door guesses when door is not changed
	int correctDoorStay=0;
	//Number of correct door guesses when door is changed
	int correctDoorChange=0;
	//Number of iterations for the simualtion
	int iter;
	//Number of iterations stayed
	int iterStay=0;
	//Number of iterations changed
	int iterChange=0;
	//Number of the door with the prize (either 1, 2, or 3)
	int prizeDoor;
	//Number of the door the player chooses at the start (either 1, 2, or 3)
	int userChoice;
	//Number of the door Monty opens, which has no prize (either 1, 2, or 3)
	int consolationDoor;
	//Number of the door that could be chosen after the consolationDoor is revealed:
	int alternativeDoor;
	//Randomly generated yes/no (1/0) answer to the question of whether the player switches doors 
	int answer;
	//Percentage success in choosing the prize over all the simulations
	// this is the probability of winning
	double resultStay;
	double resultChange;

	// Make sure we get a different series of random values every time.
	// This command initializes the random number generation with a value taken
	// from your computer's current time, which should always be different
	srand(time(NULL));	
	
	//1. Prompt the user for the number of iterations that simulation needs to be run
		cout<< "How many times through should the simulation run? \n";
		cin>> iter;

	//2. Do the simulation for iter times by filling in this for statement.
	for (int i = 0; i < iter; ++i)
	{
		//3. Initialize prizeDoor, userChoice, and consolationDoor randomly
		prizeDoor=randGenerator();
		userChoice=randGenerator();
		consolationDoor=randGenerator();
		while(consolationDoor==prizeDoor||consolationDoor==userChoice)
		{	consolationDoor=randGenerator();
		}
		//4. Check to make sure that consolationDoor is a valid value,
		// given prizeDoor and userChoice
		
		cout << "prize Door: " << prizeDoor<<endl; 
		cout << "user Choice: " << userChoice<<endl; 
		cout << "consolation Door: " << consolationDoor<<endl; 

		//5. Choose an alternative door that we could open, given userChoice and consolationDoor
		alternativeDoor=randGenerator();
		while(alternativeDoor==consolationDoor||alternativeDoor==userChoice)
		{	alternativeDoor=randGenerator();
		}
		cout << "alternative Door: " << alternativeDoor <<endl;
		cout<<endl<<endl;
		answer=yesNoGenerator();
		//6. Choose a Yes or No answer to the question: "Do you want to change your door choice?"
		//There are 3 ways this variable may be set.
		// Either, the user randomly chooses Yes (1) to change the door or No (0) to keep her current door.
		// Or, the user always chooses Yes (1) to change the door
		// Or, the user always chooses No (1) to keep her door.
		// Begin by setting this to a random choice between 0 (No) and 1 (Yes).  
		// When you think you have the random choice answer, see what happens when 
		// you instead simulate the problem with an answer of 0 (never switch doors)
		// and an answer of 1 (always switch doors).
		if (answer==0)
		{	iterStay+=1;
			if(userChoice==prizeDoor)
			{	correctDoorStay+=1;
			}
		}
		//7. If the user keeps her door choice and it is the correct one, then increment the numeber of correct doors chosen

		//If the user asks her door choice to be changed:
		if (answer == 1)
		{	iterChange+=1;
			if(alternativeDoor==prizeDoor)
			{	correctDoorChange+=1;
			}
			// 8. change the user choice to the alternative door	
		}
			// 9. If the alternative door is the prize door, then increment the number of correct doors chosen
	}//end of the for loop for the simulation

	//10. Calculate the probability of correct guesses: 
	cout <<"Total correct guesses when stayed: "<<correctDoorStay<<endl;
	cout <<"Out of: "<<iterStay<<" iterations" <<endl;
	resultStay=double(correctDoorStay)/iterStay;
	
	cout <<"The probablity of choosing the right door when door is not changed is: "<< 100*resultStay <<" \%"<<endl<< endl;
	
	//When changed
	
	cout <<"Total correct guesses when changed: "<<correctDoorChange<<endl;
	cout <<"Out of: "<<iterChange<<" iterations" <<endl;
	resultChange=double(correctDoorChange)/iterChange;
	cout <<"The probablity of choosing the right door when door is not changed is: "<< 100*resultChange <<" \%"<<endl<< endl;
	
	return 0;
}//end of main

//12. Generate random numbers of (0,1,2) + 1 to get door numbers 1, 2 and 3
int randGenerator(){
	return rand()%doors+1;
	}

//13. Generate 0 or 1 randomly:
//  0 : No = Don't change my door choice
//  1 : Yes = Change my door choice to Alternative door
int yesNoGenerator(){
	return rand()%2;
	// return an answer
}
