//
// pq_driver.cpp
//
// This is an empty unit test file that you can implement (or not) to
// create unit tests for your code.
//
// You'll likely want one for insert, remove, and peek. Try to think
// about how your queue could break, and write tests that help you
// test your deepest priority-queue-related fears.
//
// The test code will appear on RetroGrade late in the game.

#include "UTFramework.h"
#include "pq.h"

using namespace Thilenius;
extern int RETROGRADE_MODE;

SUITE_BEGIN("Priority Queue")

TEST_BEGIN("SanityCheck")
{
  IsTrue("Sane?", true, "OK I'm insane");
}TEST_END


 /*TEST_BEGIN("InitializeNode")
{
  pq* blah = init_node("hello", 12);
  
  string hi ="hello";
  IsTrue("Returned A Node", blah != NULL, 
	 "A Null node was returned by the init_node( ) function.");
  IsTrue("Data", blah != NULL && blah->priority == 12 && blah->text=="hello",
	 "The data has not been correctly set in the returned node.");
  IsTrue("Left Null", blah != NULL && blah->left == NULL, 
	 "The node->left field should be null.");
  IsTrue("Right Null", blah != NULL && blah->right == NULL, 
	 "The node->right field should be null.");
}TEST_END

TEST_BEGIN("InsertNode")
{
  pq* blah = init_priority_queue();
  string a = "hello";
  insert(blah, a, 4);
  string b = "holo";
  string c = "helo";
  string d = "foo";
  string e = "bar";
  string f = "ugh";
  cout << "1";
  insert(blah, b, 3);
  cout << "2";
  insert(blah, c, 5);
  cout << "3";
  insert(blah, d, 100);
  cout << "4";
  insert(blah, e, 1000);
  cout << "5";
  insert(blah, f, 90);
  cout << "6";
  IsTrue("Left Insert", blah->left->priority == 3 && blah->left->text == b,
	 "hilo should be to the left of the parent");
  IsTrue("Right Insert", blah->right->priority == 5 && blah->right->text == c,
	 "holo should be to the right of the parent");
  IsTrue("Nonroot Insert", blah->right->right->left->priority == 90 && blah->right->right->left->text == f,
  	 "helo should be to the right then left of the parent");
}TEST_END
 */
TEST_BEGIN("Peek")
{
  pq* blah = init_priority_queue();
  string a = "hilo";
  string b = "holo";
  string c = "helo";
  string d = "hello";
  insert(blah, d, 12);
  insert(blah, a, 14);
  insert(blah, b, 16);
  insert(blah, c, 17);

  pq* blah2 = init_priority_queue();
  string e = "hello";
  insert(blah2, e, 8);
  insert(blah2, a, 15);
  insert(blah2, b, 12);
  insert(blah2, c, 15);

  IsTrue("Finds highest priority node",
	 peek(blah)==c,
	 "Does not return highest priority string");
  IsTrue("Handles ties appropriately",
	 peek(blah2)==a,
	 "Does not return first string entered if equal priority (CHECK)");
}TEST_END

TEST_BEGIN("Remove")
{
  pq* blah = init_priority_queue();
  string b = "holo";
  string c = "helo";
  string d = "foo";
  string e = "bar";
  string f = "ugh";
  string g = "poop";
  insert(blah, g, 2);
  insert(blah, b, 3);
  insert(blah, c, 5);
  insert(blah, d, 100);
  insert(blah, e, 1000);
  insert(blah, f, 90);

  IsTrue("Removes highest priority node",
	 remove(blah) == e,
	 "Does not remove correct node");
  IsTrue("Fixes children of removed",
	 remove(blah) == d,
	 "Children are not fixed properly after removal");
}TEST_END

TEST_BEGIN("Remove Stress Test"){
  string a = "poop";
  pq* blah = init_priority_queue();
  insert(blah, a, 2);
  string b = "holo";
  string c = "helo";
  string d = "foo";
  string e = "bar";
  string f = "ugh";

  insert(blah, b, 1000);
  insert(blah, c, 500);
  insert(blah, d, 700);
  insert(blah, e, 12);
  insert(blah, f, 100);
  IsTrue("Remove 1",
	 remove(blah) == b,
	 "R1 Fails");
  IsTrue("Remove 2",
	 remove(blah) == d,
	 "R2 Fails");
  IsTrue("Remove 3",
	 remove(blah) == c,
	 "R3 Fails");
  IsTrue("Remove 4",
	 remove(blah) == f,
	 "R4 Fails");
  IsTrue("Remove 5",
	 remove(blah) == e,
	 "R5 fails");
  IsTrue("Remove 6",
	 remove(blah) == a,
	 "R6 Fails");

  pq* blah2 = init_priority_queue();
  insert(blah2, a, 100);
  insert(blah2, b, 50);
  insert(blah2, c, 12);
  insert(blah2, d, 60);

  IsTrue("Remove 7",
	 remove(blah2) == a,
	 "R7 Fails");

  IsTrue("Remove 8",
	 remove(blah2) == d,
	 "R8 Fails");
  IsTrue("Remove 9",
	 remove(blah2) == b,
	 "R9 Fails");
  IsTrue("Remove 10",
	 remove(blah2) == c,
	 "R10 Fails");
}TEST_END
 //GABES TEST
TEST_BEGIN("GABES TEST"){
pq* queue = init_priority_queue();
  string text = "Speaker of the House";
  insert(queue,  text, 7.9);
  text = "President";
  insert(queue, text, 10.0);
  text = "Congressional Staffer";
  insert(queue, text, 2.0);
  cout << remove(queue) << endl; // President
  cout << remove(queue) << endl; // Speaker of the House
  cout << remove(queue) << endl; // Congressional Staffer
}TEST_END

  
SUITE_END

int main (int argc, char* argv[])
{	
  UTFrameworkInit;
}
