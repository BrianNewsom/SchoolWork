//Name: Brian Newsom
//SID: 830372483

#include <iostream>
#include <vector>
#include <string>
#include <map>

using namespace std;

int main()
{
	//Create map
	map<string, int> grades;
	map<string, int>::iterator iter;
	//Add 5 elements
	grades.insert(pair<string, int>("Brian", 100));
	grades.insert(pair<string, int>("Steve", 82));
	grades.insert(pair<string, int>("Joe", 98));
	grades.insert(pair<string, int>("Laura", 99));
	grades.insert(pair<string, int>("Diane", 12));
	//Print all elements
	for(iter=grades.begin(); iter!=grades.end(); ++iter)
		cout<< "Name: "<< iter->first<< ", Grade: "<< iter->second<<endl;
	//Print all 100s
	cout<<endl;
	string a="No";
	for (iter=grades.begin(); iter!=grades.end(); ++iter)
	{	if (100==iter->second)
		{	cout<<iter->first<< " scored 100" <<endl;
			a=iter->first;
		}
	}
	//If zero students received a 100, a should still be the string "No" and will output the statement
	if (a=="No")
		cout<< "No students received a 100"<<endl;
		
	return 0;
}
