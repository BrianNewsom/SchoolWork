/*

  linked_list.cpp

  This file implements a list of linked data in which each element can be removed, inserted, appended, sized, as well as searched for a specific data.

*/

// AUTHOR: Brian Newsom

// WHAT: CSCI 2270 Assignment 1

// COLLABORATORS: Dawson Botsford, Gabriel Johnson, David Aleman, Alec 

// WEB:  http://www.codeproject.com/Articles/24684/How-to-create-Linked-list-using-C-C

// include the header file that provides function prototypes and the
// node structure. When you turn in your assignment, the grading
// system will use its own copy of this file, so don't edit it, and
// implement all the functions it specifies.
#include "linked_list.h"

// sstream gives you the stringstream object. Google it, and admire
// how much easier this makes life.
#include <sstream>

using namespace std;


// your linked list implementation goes here :)

// create a new node structure that points to NULL and holds the
// provided integer. return a pointer to that new node.
node* init_node(int data) 
{
  	node* new_node = new node; //init node pointer
	new_node->data = data; // p_node points to value of function
	new_node->next = NULL; // p_node pointer is set to default of NULL
	return new_node; // change this to return a newly initialized node.
}

// create a space-separated string representing the contents of the
// list, in the same order they are found beginning from the head of
// the list. return that string object.  For example, this might
// return "" (the empty string) if the list is empty, or it might
// return "1 7 3" or "1 7 3 " (note the space at the end, you can have
// that there and it is OK).
std::string report(node* root) 
{
	if ( root == NULL)
		return " ";
	else
	{
		stringstream ss;  //records things as a string without printing them
		node* cursor = root;
		while(cursor!=NULL)
		{
			ss << cursor->data;
			ss << ' ';
			cursor = cursor->next;
		}
		
		return ss.str();
	}

	// change this to return a proper string, 
               // even if it is a zero-length string object.
}

// insert an integer into the list pointed to by head. the resultin
// list is one element longer, and the newly appended node has the
// given data value. consider using the 'append' function to help.
void append_data(node** head, int data) 
{
	node* new_node= init_node(data);
	append(head, new_node);
}

// this is the same as append_data, except we're adding a node, rather
// than a value. 
void append(node** head_ref, node* new_node) 
{
	// node* head = *head_ref;
	if (*head_ref == NULL)
	{
		*head_ref = new_node;
	}else {
		node* cursor = *head_ref;
		while (cursor->next != NULL){
			cursor = cursor->next;
		}
		cursor->next = new_node;
	}
}

// similar to append_data. insert a new node that contains the given
// data value, such that the new node occupies the offset
// indicated. Any nodes that were already in the list at that offset
// and beyond are shifted down by one. For example if the list
// contains 23, 74, 93, and we insert 42 at index 1, the resulting
// list should be 23, 42, 74, 93.
void insert_data(node** head, int offset, int data) 
{
	node* new_node = init_node(data) ; 
	insert(head, offset, new_node);
	
}
	

// this is the same as insert_data, except we're inserting a node,
// rather than a value.
void insert(node** head, int offset, node* new_node) {
	node* cursor ; 
	cursor = *head;
	if(cursor == NULL)
		cursor = new_node;
	else if ( offset == 0)
	{
		new_node->next = cursor;
		*head = new_node;
	}
	else
	{
		for (int i = 0 ; i < offset-1; i++)
		{
			if( cursor != NULL )
				cursor = cursor->next;
		}
		new_node->next = cursor->next;
		cursor->next = new_node;
		

	}
}  


// remove the node indicated by the given offset. For example if our
// list contains 23, 74, 93, and we remove offset 1, the resulting
// list should then contain 23, 93.
void remove(node** parent, int offset) 
{
	node* cursor;
	cursor = *parent;
	int index = 0;
	if(offset == 0)
	{	
		*parent = cursor->next; 
		delete(cursor);
	}
	else
	{
		while ((index+1) < offset)
		{
			index+=1;
			cursor = cursor->next;
		}
		node* node_delete = cursor->next;
		cursor->next = cursor->next->next;
		delete(node_delete);
	}																																																	
}


// report the number of nodes in the linked list pointed to by head.
int size(node* head) {
	int size=0;
	node* cursor = head;
	while(cursor!=NULL)
	{
		size=size+1;
		cursor = cursor->next;
	}
	
  return size; 
}

// return true if the linked list pointed to by head contains a node
// with the specified value.
bool contains(node* head, int data) 
{
	node* cursor = head;
	if (head->data == data)
		return true;
	while(cursor!=NULL)
	{
		if(cursor->data == data)
			return true;
		cursor = cursor->next;
	}
	return false; 
}

