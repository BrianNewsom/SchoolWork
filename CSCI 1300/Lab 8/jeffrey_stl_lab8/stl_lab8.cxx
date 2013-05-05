/*
Description: Lab 8 - Using the Standard Template List Class

Name: Brian Newsom

Question: What is one advantage of a STL List over a STL Vector?
 Lists perform better in inserting, extracting, and moving elements in any position
 within the container for which we already have an iterator*/

/**** Reference: http://www.cplusplus.com/reference/stl/list/ ****/
/**** Hint, list functions needed: begin(), end(), push_front(), erase(), and size() ****/

#include <iostream>
#include <cstdlib>
#include <list>			// to allow using the STL list class
#include <string>		// to allow using the C++ string class

using namespace std;

int main()
{
	int erase_pos = -1;				// position to erase a list element	
	string user_string_input;		// string variable to hold text entered by user
	list<char> my_list;				// list object used to reverse characters in string of text
	
	// *** notice how to get a string of text that includes line breaks by using getline ***
	cout << "Please enter a string of text: ";
	getline(cin, user_string_input);
	
	cout << "\nUser text entered: " << user_string_input << endl;
	
	// 1. Now put the user text into a list so it is in reverse order and omit spaces
	// So if the text entered was "C++ Roxxorz ... maybe" the list would
	// 	 contain "ebyam...zroxxoR++C" where each character is a separate element
	// A string can be iterated through with the bracket [ ] syntax just like an array
	for(int i=0;i<list.size user_string_input;i++) 
	{
		// 2. test if current string character is not a blank
		//if( ) 
		{
			// 3. put character into list (i.e. push it on the list)
			
		}
	}
	
	// 4. Now print out the contents of the list
	// You will need to use a list iterator to traverse the list and
	//   print out the elements
	// Reference: http://www.cplusplus.com/reference/stl/list/begin/
	cout << "\nReverse of text:   ";
	//for( ; ; )
	{
		// 5. print out each list element using the iterator
	
	}
	
	cout << endl << endl;
	
	// If list size is > 2
	//   erase the middle list element if the list size is odd
	//   erase the middle two elements if the list size is even 
	// The erase position is the list size / 2 when odd
	// The erase position when even will have two positions, use odd position to help
	// you will need to use an iterator again to get to the correct list position for erasing
	if(my_list.size() > 2)
	{	
		cout << "List size before remove = " << my_list.size() << endl;
		
		cout << "Removing elements(s) - ";
		
		// 6. compute the erase position inside of the list
		// erase_pos = ????
		
		// 7. move iterator to the erase position
		//for( ; ; )
		{
		
		}
		
		// 8. erase correct elements based on even / odd list size
		//if( )  // odd erase
		{
			// Display element being erased
			
			// Erase element
		}
		//else  // even erases
		{
			// Display first element being erased	
			// Erase first element
			
			// Display second element being erased	
			// Erase second element
		}
		
		cout << "List size after remove = " << my_list.size() << endl;
		cout << "\nList contents after remove: ";
		
		// 9. print out the contents of the list on a single line
		//for( ; ; )
		{
		
		}
		
		cout << "\nList contents reversed: ";
		
		// 10. print out the contents of the list in reverse order on a single line
		//for( ; ; )
		{
			
		}
	}
	else
	{
		cout << "List size too small for remove!" << endl;
	}
	
	cout << endl;
	
	return EXIT_SUCCESS;
}
