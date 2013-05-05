/*
Name:

Description:
*/

#include <iostream>
#include <iomanip>
#include <map>
#include <string>

using namespace std;

int main( )
{
	map <char, int> letters;		// a map with char key and int data
	map <char, int>::iterator iter;	// iterator for the map
	string user_text;				// a user_text entered by the user
	string answer;					// whether the user wants to re-run the program
	
	do
	{
				
		// 1. map must be cleared for each iteration of do-while 
		
		
		// get the user_text the user enters
		cout << endl << "Please enter a some text and press enter: ";
		getline( cin, user_text );
		
		// iterate through the user_text entered
		for(unsigned int i = 0; i < user_text.size(); ++i)
		{	
			// 2. check to see if letter is already in the user_text
			
			
			// 3. if the letter is not already in the map add it and make the count 1
			//    else the letter already exists and the count needs to increase by 1
			/*
			if(  )
			{
				
			}
			else
			{
				
			}
			*/
		}
		
		cout << endl;
		
		// print out the total letters in the user_text
		cout << "Total letters in the user text = " << user_text.size() << endl << endl;
		
		// Construct a nicely formatted table
		//  Column 1 is a list of the characters in the user_text
		//  Column 2 is the number of times each letter occurs in the user_text
		//  Column 3 is the percent each letter occurs compared to total user_text characters
		//		the decimal point is fixed and only two decimal places are shown
		//	In the chart, a tab is listed as <TAB> and space as <SPACE>
		// 
		// References to help with formatting:
		//	 http://www.cplusplus.com/reference/iostream/ios_base/flags/
		//   http://www.cplusplus.com/reference/iostream/ios_base/precision/
		//	 http://www.cplusplus.com/reference/iostream/ios_base/setf/
		//   http://www.cplusplus.com/reference/iostream/manipulators/setw/
		//	 http://www.cplusplus.com/reference/iostream/manipulators/showpoint/
		
		// 4. set justification left
		
		
		// 5. set to show two decimal places of precision for decimal numbers
		
		
		// display table header info
		cout << setw( 10 ) << "Char" << setw( 10 ) << "Count" << setw( 10 ) << "Percent" << endl;
		cout << "----------------------------------" << endl;
		
		// 6. iterate through the contents in the map using an iterator
		/*
		for(  )
		{
			// 7. set justification left
			
			
			// 8. display characters and character count in their columns
			if( )		// check for tab character
			{
				// print out <TAB> here
			}
			else if( )	// check for space character
			{
				// print out <SPACE> here
			}
			else							// all other cases
			{
				// print out any other characters here
			}
			
			// 9. set justification right
			
			
			// 10. display the percentage in fixed decimal format where decimal point is always shown
			//	 you will need to use showpoint and fixed
			
		}
		*/
		// ask the user if they would like to enter another user_text
		cout << endl << "Would you like to enter more text (y/n): ";
		getline( cin, answer );
		
	} while ( answer[0] == 'y' || answer[0] == 'Y' );
	
	return EXIT_SUCCESS;
}