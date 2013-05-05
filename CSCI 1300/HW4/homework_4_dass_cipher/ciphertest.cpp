#include <iostream>
#include <iomanip>
#include <cstdlib>
#include <string> 
#include <map>
// I am using this file to test individual pieces
using namespace std;

string shift( string text, int shift);

int main()
{

	string text="zaxybhads";
	int shifta=5;
	cout<< shift(text,shifta);
}

string shift( string text, int shift )
{
	// ** 4.1 **
	// Go through all of the characters in text and shift them 
	// Check and see if the shifted character is outside 'a' - 'z'
	// If outside fix it so that it wraps around
	//	  With a shift of 2, 'z' would be 'b' and 'y' would be 'a'
	//    With a shift of 4, 'z' would be 'd' and 'w' would be 'a'
	// Else go ahead and shift
	
	for(unsigned int i=0 ; i<text.size() ; i++)
	{
		
		/*text[i] = char(int(text[i])+ shift);
		if (int(text[i])>int("z"))
			text[i] +=26;
		if (int(text[i]) < int("a"))
			text[i] -= 26;
				*/
			
	}
	return text;
}
