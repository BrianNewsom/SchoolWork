
/*

  btree_unittest.cpp
  Refer to deque to check ordering/format
*/
#include <cstring>
#include <cstdlib>
#include "btree.h"
#include "UTFramework.h"

using namespace Thilenius;
using namespace std;

extern int RETROGRADE_MODE;

/* begin a suite. This is a collection of tests. */

SUITE_BEGIN("Btree")     
/* now define tests with the same form as the sanity check. */
// the below is just a main function to get the unit test started. 

TEST_BEGIN("Sanity Check") {
  IsTrue("Sane?",        // label in output
	 true == true,          // a truth test
	 "I'm insane!"); // error message when needed
}TEST_END

/* end the suite, since all of this was a macro definition. */



TEST_BEGIN("Init Btree") {
  btree* n = init_btree(5);
 

  IsTrue("Initialize a key",
	 n->keys[0] == 5,
	 "Key is not correctly assigned");

  IsTrue("Initialize leaf to true",
    n->is_leaf == true,
      "Didn't initialize as leaf");
}TEST_END

TEST_BEGIN("Contains"){
  btree* n = init_btree(1);
  n->keys[1] = 2;
  n->keys[2] = 3;
  n->keys[3] = 4;
  
  IsTrue("Contains returns true on leaf",
	 contains(n, 3) == true,
	 "Contains does not return true on contained element");
  
  IsTrue("Contains returns false on bad element",
	 contains(n,100) == false,
	 "Contains does not return false on bad element");

}TEST_END


TEST_BEGIN("Trivial Insert"){
  btree* n = init_btree(0);
  insert(n, 2);
  insert(n, -1);
  insert(n, 3);
  btree* m = init_btree(5);
  insert(m, 2);
  insert(m, 7);
  insert(m, 8);
  btree* x = init_btree(5);
  insert(x, 5);
  /*
  IsTrue("Inserts into root NULL".
	 q->keys[0]==12,
	 "Insert does not work if root is NULL");
  */

  IsTrue("Insert does nothing if already contained",
	 (x->keys[0] == 5) && (x->keys[1] != 5),
	 "Insert still adds element");

  IsTrue("Inserts successfully",
	 contains(n, 2) && contains(n, 0) && contains(n, 3) && contains(n,-1),
	 "Insert is not contained");
  
  IsTrue("Inserts in order",
	 (n->keys[0] == -1) &&
	 (n->keys[1] == 0) &&
	 (n->keys[2] == 2) &&
	 (n->keys[3] == 3),
	 "Insert is not in order");
}TEST_END

TEST_BEGIN("Trivial Removal"){
  btree* n = init_btree(0);
  insert(n, 2);
  insert(n, -1);
  insert(n, 3);
  remove(n, 4);

  btree* m = init_btree(0);
  insert(m, 2);
  insert(m, -1);
  insert(m, 3);
  remove(m, -1);
  remove(m, 0);

  btree* y = init_btree(123);
  insert(y, 90);
  insert(y, 170);
  insert(y, 200);
  remove(y, 123);
  remove(y, 200);

  IsTrue("Remove does nothing if not contained",
	 (n->keys[0] == -1) && 
	 (n->keys[1] == 0) &&
	 (n->keys[2] == 2) &&
	 (n->keys[3] == 3),   

	 "Remove f's something up");

  IsTrue("Remove works on first element",
	 (m->keys[0] == 2) && 
	 (m->keys[1] == 3),   

	 "Remove doesn't work on first element");
  
  IsTrue("Remove works in middle element, order is okay",
	 (y->keys[0] == 90) &&
	 (y->keys[1] == 170),
	 "Remove works for any element");
}TEST_END




SUITE_END
 /*
TEST_BEGIN("Insert") {
  btree* q = init_node();
  insert(q, 5);
  insert(q, 12);
  insert(q, 15);
  IsTrue("Push onto Empty",
           ,
	 "End should not be NULL");
  IsTrue("Push onto Empty",
	  ,
	 "First value is not correct.");
}TEST_END

*/

void printUsage(char call[]) {
  cout << " Usage: " << call << " [--retrograde]" << endl;
}

int main (int argc, char* argv[]) {
  if (argc == 2 && strcmp(argv[1], "--retrograde") == 0) RETROGRADE_MODE = 1;
  else if (argc != 1) { 
    printUsage(argv[0]);
    return -1;
  }
  UTFrameworkInit;
}

