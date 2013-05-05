#include <fstream>
#include <iostream>
using namespace std;

int main()
{
	ofstream fout;
	ifstream fin;
	fout.open("cities.txt");
	fout << "Boulder \n";
	fout << "Denver \n";
	fout.close();
	string line;
	fin.open("cities.txt");
	while(fin.good())
	{
		getline(fin, line);
		cout << line << endl;
	}
	fin.close();
	return 0;
}
