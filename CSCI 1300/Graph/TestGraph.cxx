// Starter code for TestGraph

#include <iostream>
#include <malloc.h>
#include <string.h>
#include "GraphTemplate.h"
using namespace std;
using namespace YOUR_NAME_HERE;

// **************************************************************************


int test1( )
// Postcondition: Two simple tests have been run on the 
// set data type. If all tests are passed, then the function
// returns 2. Otherwise the function returns zero.
{
    Graph<Vertex, Edge> test;
    test.addVertex("A");
    test.addVertex("A");
    if (test.countVertices() != 1)
		return 0;
    test.addVertex("B");
    test.addVertex("C");
    test.addVertex("D");
    test.addVertex("E");
    test.addVertex("F");
    if (test.countVertices() != 6)
		return 0;
    return 2;
}

int main( )
{
	
    int value = 0;
    int result;
    
    cerr << "Running graph tests:" << endl;

    cerr << "TEST 1:" << endl;
    result = test1( );
    value += result;
    if (result > 0) cerr << "Test 1 passed." << endl << endl;
    else cerr << "Test 1 failed." << endl << endl; 
 
    cerr << "If you submit the set now, you will have\n";
    cerr << value << " points out of the possible 75 points.\n";

    return EXIT_SUCCESS;
}
