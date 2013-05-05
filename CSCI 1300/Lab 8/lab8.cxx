//Brian Newsom

#include <iostream>
#include <cstdlib>
#include <vector>			// to allow using the STL vector class
#include <string>		// to allow using the C++ string class

using namespace std;

int main()
{
//Create a vector
vector<string> names;
//Add 10 elements
names.push_back("A");
names.push_back("B");
names.push_back("C");
names.push_back("D");
names.push_back("E");
names.push_back("F");
names.push_back("G");
names.push_back("H");
names.push_back("I");
names.push_back("J");
//Print out
cout << "Printing all 10 characters" << endl;
vector<string>::iterator iter;
for (unsigned int i=0; i<names.size() ;++i)
	cout << names[i] <<endl;
//Print 5th character (this is the 4th term)
cout << "Printing 5th character" << endl;
cout << names[4] <<endl;
//Delete first two characters
cout << "Erasing first two characters" << endl;
names.erase (names.begin());
names.erase (names.begin()+1);
cout << "Complete" << endl;
//Print new vector
cout << "Printing new vector" << endl;
for (unsigned int i=0; i<names.size() ;++i)
	cout << names[i] <<endl;
//Print vector size
cout << "Vector size is now: " << names.size() << endl;

}
