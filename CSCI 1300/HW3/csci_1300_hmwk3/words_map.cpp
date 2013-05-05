/*
Name: Brian Newsom
DO NOT GRADE THIS!!! It is not complete.
Description: Counts the number of words in a string entered by the user
*/

#include <iostream>
#include <iomanip>
#include <map>
#include <string>

using namespace std;

	map <string, int> words;		// a map with char key and int data
	map <string, int>::iterator iter;	// iterator for the map
	string user_text;				// a user_text entered by the user
	string answer;					// whether the user wants to re-run the program
	unsigned int pos=0;
	string str;
	string word;	
	unsigned int WordCount();
	
int main( )
{
	
	do
	{
		// 1. map must be cleared for each iteration of do-while 
		words.clear();	
		
		
		// get the user_text the user enters
		
		cout << endl << "Please enter some text and press enter: ";
		getline( cin, user_text );
		
		// iterate through the user_text entered
			pos = user_text.find(" ");
			word = user_text.substr(0,pos);
			cout << word << endl;
			str = str.substr(pos+1);
			pos = str.find(" ");
			word = str.substr(0,pos);
			
		//for(unsigned int i=0;i!=WordCount(); i++)			
	//	{	
			

	//	}
	} while ( answer[0] == 'y' || answer[0] == 'Y' );
	
	return 0;
	
}

unsigned int WordCount()
{
    int length = user_text.length();        // length of sentence
   
    int wordscount = 1;                          
  
    
    for (int size = 0; length > size; ++size)
    {
                 
        if (user_text[size] == ' ' && user_text[size-1] != ' ') 
			wordscount++;
    }
    if ( user_text[0] == ' ')
		wordscount--; 
    return wordscount;
}
