//Brian Newsom
// binary_search_tree.cpp
//
// Please refer to binary_search_tree.h for documentation.
//Websites: http://en.wikipedia.org/wiki/Binary_search_tree
//http://www.cs.bu.edu/teaching/c/tree/bst/
//http://www.bogotobogo.com/cplusplus/binarytree.php
//
#include <iostream>

#include "binary_search_tree.h"

bt_node* init_node(int data) {
	bt_node* new_node = new bt_node;
	new_node->data = data;
	new_node->left = NULL;
	new_node->right = NULL;
	return new_node;
}

void insert(bt_node** top_ref, bt_node* new_node) {
	bt_node* cursor;
	cursor = (*top_ref);
	if (cursor == NULL)
	{	
		cursor = new_node;
		return;
	}
	if(new_node->data < cursor->data)
	{
		if(cursor->left==NULL)
			cursor->left = new_node;
		else
			insert(&(cursor->left),new_node);
	}
	else if(new_node->data >= cursor->data)
	{
		if(cursor->right==NULL)
			cursor->right = new_node;
		else
			insert(&(cursor->right),new_node);
	}
}
	
void insert_data(bt_node** top_ref, int data) {
	bt_node* new_node= init_node(data);
	insert(top_ref,new_node);

}

void remove(bt_node** top_ref, int data) {

	if (contains((*top_ref),data)==false) 
		return; 
	if (data <( *top_ref)->data) //traverse 
		remove(&((*top_ref)->left), data); 
	else if (data > (*top_ref)->data)//traverse 
		remove(&((*top_ref)->right),data); 
	else 
	{ 
		bt_node* tempNode; 
		if((*top_ref)->left == NULL) 
		{ 
			tempNode = (*top_ref)->right; 
			delete *top_ref; 
			*top_ref = tempNode; 
		} 
		else if((*top_ref)->right==NULL) 
		{ 
			tempNode = (*top_ref)->left; 
			delete *top_ref; 
			*top_ref = tempNode; 
		} 
		else 
		{ 
			bt_node* parent = NULL; 
			tempNode = (*top_ref)->right; 
			while(tempNode->left!=NULL) 
			{ 
				parent = tempNode; 
				tempNode = tempNode->left; 
			} 
			(*top_ref)->data = tempNode->data; 
			if (parent!=NULL) 
				remove(&(parent->left),parent->left->data); 
			else 
				remove(&((*top_ref)->right),(*top_ref)->right->data); 
		} 
	}  
} 

bool contains(bt_node* top, int data) {
	if(get_node(top,data) != NULL)
		return true;
	else
		return false;
}
	
bt_node* get_node(bt_node* top, int data) {
	bt_node* cursor = top;
	if(cursor->data == data)
		return cursor;
	else if((data < cursor->data) && cursor->left != NULL)
		get_node(cursor->left,data);
	else if((data >= cursor->data) && cursor->right !=NULL)
		get_node(cursor->right,data);
	else
		return NULL;
}

int size(bt_node* top) {
	bt_node* cursor = top;
	if(cursor == NULL) 
		return 0;
	else
		return 1 + size(cursor->left) + size(cursor->right);
}

void to_array_helper(bt_node* top, int arr[], int* a)
{
	bt_node* cursor = top;
	if(cursor == NULL)
		return;
	else
	{
		to_array_helper(cursor ->left, arr, a);
		arr[*a] = cursor->data;
		(*a)++;
		to_array_helper(cursor->right, arr, a);
	}
}
	
void to_array(bt_node* top, int arr[]){
	int a = 0;
	to_array_helper(top, arr, &a); 
}
