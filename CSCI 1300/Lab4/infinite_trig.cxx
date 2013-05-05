#include <cstdlib>   	// Provides EXIT_SUCCESS
#include <iomanip>   	// Provides setw to set the width of an output
#include <iostream>  	// Provides cout, cin
#include <cmath>		// Provides power and other functions

// this lets us use cout, cin, etc. (see above) without having to say std::cout, std::cin, etc.
using namespace std;

// one way to make a constant in C++ for pi
#define PI 3.14159265359

// this line promises that a definition of this function will come
double infinite_sin_1(double x);

// this line promises that a definition of this function will come
double infinite_cos_1(double x);

// this line promises that a definition of this function will come
// longs are bigger integers
long factorial(int n);

// this code is the thing that runs; it performs the same tests on sin(pi/3) and cos(pi/3) as your homework did.
int main( )
{
	double x = PI/3.0;
	double sin_x = infinite_sin_1(x);
	double cos_x = infinite_cos_1(x);
	cout << "actual sin gives " << setprecision(25) << sin(x) << endl;
	cout << "infinite_sin_1 gives " << setprecision(25) << sin_x << endl;
	cout << "difference is " << setprecision(25) << fabs(sin_x-sin(x)) << endl;
	cout << "actual cos gives " << setprecision(25) << cos(x) << endl;
	cout << "infinite_cos_1 gives " << setprecision(25) << cos_x << endl;
	cout << "difference is " << setprecision(25) << fabs(cos_x-cos(x)) << endl;
	
	// send back a happy value
	return EXIT_SUCCESS;
}

// now write the function (this works like #def infinite_sin_1(x) in python)
double infinite_sin_1(double x)
{
	double total = 0;
	double term;
	int iterations;
	cout << "How many sin terms should I add up? ";
	cin >> iterations;
	for (int i = 0; i < iterations; ++i)
	{
		term=pow(x,2*i+1)*pow(-1,i)/factorial(2*i+1);
		total+=term;
	}
	return total;
}

// now write the function (this works like #def infinite_cos_1(x) in python)
double infinite_cos_1(double x)
{
	double total = 0;
	double term;
	int iterations;
	cout << "How many cos terms should I add up? ";
	cin >> iterations;
	for (int i = 0; i < iterations; ++i)
	{
		term=pow(x,2*i)*pow(-1,i)/factorial(2*i);
		total+=term;
	}
	return total;
}

// now write the function (this works like #def infinite_sin_1(x) in python)
// longs are just bigger integers.
long factorial(int n)
{
	long answer = 1;
	for (int i=1; i<=n; i++)
		{
		answer*=i;
		}
		
	return answer;
}

