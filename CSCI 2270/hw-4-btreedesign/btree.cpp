#include "btree.h"
#include <iostream>
#include <cstdlib>
#include <math.h>
using namespace std;

btree* init_btree(int key){
  btree* new_btree = new btree;
  new_btree->num_keys = 1;
  new_btree->keys[0]=key;
  for(unsigned int i = 0 ; i < BTREE_ORDER ; i++){
    new_btree->children[i]=NULL;
      }
  new_btree->is_leaf = true;
  return new_btree;
}


void insert(btree* &root, int key){
  if (&root == NULL){
    init_btree(key);
    return;
  }
  if(root->num_keys == 0)
    root = init_btree(key);
  else if (contains(root, key) == true)
    return;
  else if(root->num_keys < BTREE_ORDER - 1){
    //If leaf and not full
      add_key(root, key);
  }
  else if (root->is_leaf == true && root->num_keys >= BTREE_ORDER - 1){
    //Take a leaf, split node into two children and one parent
    int parentKey = split_median(root, key);
    btree* childleft = init_btree( root->keys[0]);
    btree* childright = init_btree(root->keys[int(floor(BTREE_ORDER/2))+1]);
    for(int i = 1 ; i < int(floor(BTREE_ORDER/2)) ; i++){
      add_key(childleft, root->keys[i]);
    }
    for(int i = int(floor(BTREE_ORDER/2))+2 ; i < BTREE_ORDER ; i++){
      add_key(childright, root->keys[i]);
    }
    root = init_btree(parentKey);
    root->is_leaf = false;
    root->children[0] = childleft;
    root->children[1] = childright;
  }
  else if (root->is_leaf == false){
    //If internal Node
    for (int i = 0 ; i < root->num_keys ; i++){
      if(key < root->keys[i]){
	insert(root->children[i], key);
	return;
      }
      if(key > root->keys[root->num_keys]){
	insert(root->children[root->num_keys+1], key);
	return;
      }
      }
  }
  //insert(
  return;
  //All other cases
}

void add_key(btree* &root, int key){
  //Adds key to non full leaf--WORKING 
  if(key < root->keys[0]){
    //If new key is lowest value
    for (int  n= root->num_keys  ; n > 0 ; n--){
      root-> keys[n] =root-> keys[n-1];
     
    }
    root->keys[0] = key;
    root->num_keys+=1;
    return;

  }
  //Key at end of leaf
  else if(key > root->keys[root->num_keys-1]){
    root->keys[root->num_keys] = key;
    root->num_keys+=1;
    return;
  }
  //Key in middle of leaf
  else{
    for(int i = 0 ; i < root->num_keys-1 ; i++){
      if(key > root->keys[i] && key < root->keys[i+1]){
	for(int n = root->num_keys ; n > i ; n--){
	  root->keys[n] = root->keys[n-1];
	}
	root->keys[i+1] = key;
	root->num_keys+=1;
	return;
      }
    }
    return;
  }

}

void remove(btree* &root, int key){
  if (contains(root, key) == false)
    //If not contained, do nothing
    return;
  if (root->is_leaf == true){
    //If a leaf, remove
    remove_leaf(root, key);
    if( root->num_keys < (ceil(BTREE_ORDER/2) -1)){
      //Rebalance tree (DO I NEED A REF TO THE PARENT?)
    }
  }



  root->num_keys -= 1;
  return;
}


void remove_leaf(btree* &root, int key){
  for( int i = 0  ; i < root->num_keys ; i++){
    if ( root->keys[i] == key ){
      for (int n = i ; n < root->num_keys-1 ; n++){
	root->keys[n] = root->keys[n+1];
      }
      return;
    }
  }
}

void rebalance_btree(btree* &root, int seperator){
  //Regroup children back into root
}
      
bool contains(btree* &root, int key){
  if (root == NULL) //If empty false
    return false;
  for(unsigned int i = 0 ; i < BTREE_ORDER-1 ; i++){ //search current node
    if (root->keys[i]== key)
      return true;
  }
  if (root->is_leaf == false){ //Search children
    //    for(int i = 0 ; root->children[i]!=NULL ; i++){
    if(key > root->keys[BTREE_ORDER - 2])//If after largest value
      return contains(root->children[BTREE_ORDER - 1], key);
    int i = 0;
    do{
      if (key < root->keys[i]){ //If at beginning or middle
	return contains(root->children[i], key);
      }
      i++;
    }while(root->children[i]!=NULL);

  }
  return false;  
}

int split_median(btree* &root, int key){
  add_key(root, key);
  int medianKey = root->keys[int((floor(BTREE_ORDER/2)))];
  return medianKey;
}
