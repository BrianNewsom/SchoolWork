/*

  sorting.cpp

  Please refer to sorting.h for documentation on each function.

  Your Name: Brian Newsom
  Your TA: Shang Ma
  List O' Collaborators: David Aleman, Dawson Botsford


   + ------ N O T E: -- Big scary warning! ------------------------------
   |
   |    We clearly can't use unit testing to ensure that you're
   |    actually implementing the correct algorithm. I suppose we could
   |    write some complicated static analysis checker. But it is
   |    easier to just look at it with our eyeballs.
   |
   |    After the assignment is due, we will look at the most recent
   |    version of your implementation that got the highest score and
   |    make sure you're not doing something sneaky like using a
   |    standard library call to sort a vector.
   |
   |    Anyone caught doing this (even though it is kinda funny) will
   |    be given 0/15 on the assignment.
   |
   +-------------------------------------------------------------------- 

 */

#include "sorting.h"
#include <math.h>
#include <iostream>
using namespace std;


void quicksort(vector<int> &data, int low_idx, int high_idx) {
	int pivot = (low_idx + high_idx)/2;
	int index = quicksort_partition(data, low_idx, high_idx, pivot);
	if(low_idx < index - 1)
	{
		quicksort(data, low_idx, index - 1);
    }
	if(index < high_idx)
    {
		quicksort(data, index, high_idx);
    }
}

int quicksort_partition(vector<int> &data, int low_idx, int high_idx, int pivot_index) {
	int pivotValue = data[pivot_index];
	while(low_idx <= high_idx)
	{
		while(data[low_idx]<pivotValue)
		{
			low_idx++;
		}
		while(data[high_idx]>pivotValue)
		{
			high_idx--;
		}
		if(low_idx<=high_idx)
		{
			swap(data[low_idx], data[high_idx]);
			low_idx++;
			high_idx--;
		}
	}
	return low_idx;

}

void bubblesort(vector<int> &data) {
	for(unsigned int i = 0 ; i< data.size() -1 ; i++)
	{
		for (unsigned int j=data.size() -1; j>i; j--)
		{
			if(data[j] < data[j-1])
			{
				int temp = data[j]; //SWAP
				data[j]= data[j-1];
				data[j-1] = temp;
			}
		}
	}		

}

void mergesort(vector<int> &data) {
	vector<int> left_list;
	vector<int> right_list;
	if(data.size() <=1)
	{	
		return;
	}
	for (unsigned int i = 0 ; i < data.size(); i++)
	{
		if ( i< data.size()/2)
		{
			left_list.push_back(data[i]); //Assign small half to left
		}
		else if (i >= data.size()/2)
		{
			right_list.push_back(data[i]); //Assign big half to right
		}
	}
	if (left_list.size() > 1)
		mergesort(left_list); //Rpt with left
	if (right_list.size() > 1)
		mergesort(right_list); //Rpt with right
	data = merge(left_list,right_list);
	return;
}

vector<int> merge(vector<int> &left, vector<int> &right) {
	vector<int> data;	
	while(0 < left.size() || 0 < right.size())
	{		
		if (left.size() > 0 && right.size() > 0)
		{
			if(left[0] <= right[0])
			{
				data.push_back(left[0]);
				left.erase(left.begin());
			}
			else
			{
				data.push_back(right[0]);
				right.erase(right.begin());	
			}
		}
		else if (right.size() > 0)
		{
			data.push_back(right[0]);
			right.erase(right.begin());
		}
		else if (left.size() > 0)
		{
			data.push_back(left[0]);
			left.erase(left.begin());
		}
	}
	return data;

}

void mystery_sort(vector<int> &data) {   //Selection Sort
	int length = data.size();
	for (int i = 0; i < length; i++)
	{
		int first = i;
		for (int n = i+1; n < length ; n++)
		{
			if(data[first]>data[n])
				first = n;
		}
		int temp = data[first];
		data[first] = data[i];
		data[i] = temp;
	} 
	return;
}

