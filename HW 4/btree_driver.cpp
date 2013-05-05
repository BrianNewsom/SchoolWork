#include"btree.h"
#include <iostream>

using namespace std;
void print(btree* &root);


int main(){
  /*  btree* b = init_btree(5);
  print(b);
  insert(b, 3);
  print(b);
  insert(b,2);
  print(b);

  btree* c = init_btree(1);
  print(c);
  insert(c,2);
  print(c);
  insert(c,3);
  print(c);

  btree* d = init_btree(1);
  print(d);
  insert(d,3);
  print(d);
  insert(d,7);
  print(d);
  insert(d,4);
  print(d);

  cout << "BEGIN REMOVE TESTING" << endl;

  btree* e = init_btree(5);
  print(e);
  remove(e,5);
  print(e);
  insert(e,3);
  print(e);
  remove(e,3);
  print(e);
  insert(e,1);
  insert(e,2);
  insert(e,3);
  insert(e,4);
  print(e);
  remove(e,3);
  print(e);
  remove(e,2);
  print(e);
  remove(e,4);
  print(e);
  remove(e,1);
  print(e);
  
  cout << "fix the broken thing" << endl;

  btree* q = init_btree(12);
  print(q);
  insert(q,1);
  insert(q,2);
  insert(q,3);
  print(q);
  remove(q,1);
  print(q);
  remove(q,2);
  print(q);
  // */
  // btree* a = init_btree(12);
  // btree* b = init_btree(2);
  // btree* c = init_btree(100);
  // a->children[0]= b;
  // a->children[5]= c;
  // a->is_leaf = false;

  /* FUNCTIONAL CONTAINS TEST

  cout << "Contains Recursion Test" << endl;

  
  btree* a = init_btree(20);
  btree* b = init_btree(1);
  btree* c = init_btree(6);
  btree* d = init_btree(11);
  btree* e = init_btree(18);
  btree* f = init_btree(100);

  a->children[0]= b;
  a->children[1]= c;
  a->children[2]= d;
  a->children[3]= e;
  a->children[4]= f;

  insert(a, 5);
  insert(a, 10);
  insert(a, 15);
  cout << "a is ";
  print(a);
  //insert(b, 2);
  insert(b, 3);
  insert(b, 4);
  cout << "b is ";
  print(b);
  insert(c, 7);
  insert(c, 8);
  insert(c, 9);
  cout << "c is ";
  print(c);
  insert(d, 12);
  insert(d, 13);
  insert(d, 14);
  cout << "d is ";
  print(d);
  insert(e, 16);
  insert(e, 17);
  cout << "e is ";
  print(e);
  insert(f, 21);
  insert(f, 22);
  insert(f, 1000);
  cout << "f is ";
  print(f);
  a->is_leaf = false;
  if (contains(a,80)){
      cout << "Contains 80" << endl;
    }
  else
    cout << "does not contain 80" << endl;
  if (contains(a,1)){
      cout << "Contains 100" << endl;
    }
  else
    cout << "does not contain 100" << endl;
  */

  /*  btree* a = init_btree(5);
  insert(a, 7);
  insert(a, 9);
  add_key(a, 10);
  print(a);
  add_key(a, 12);
  print(a);

  */
  ///BRIAN FIND A WAY TO TEST THIS IN A DRIVER!! WAIT FOR DROPBOX TO UPDATE
  btree* a = init_btree(5);
  insert(a, 1);
  insert(a, 3);
  print(a);
  insert(a, 7);
  print(a);
  insert(a, 9);
  print(a);
  insert(a, 12);
  insert(a, 13);
  insert(a, 15);
  print(a);
  print(a->children[0]);
  print(a->children[1]);
}

void print(btree* &root){
  for (int i = 0 ; i < (root->num_keys) ; i++){
    cout << root->keys[i] << " ";
  }
    cout << root->num_keys << "num keys" << endl;
}
