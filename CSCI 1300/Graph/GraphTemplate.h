// FILE: GraphTemplate.h (part of the namespace elizabeth_white_adjacency_matrix)
// TEMPLATE CLASS PROVIDED: Graph
//   (a container class for a Graph with Vertex and Edge components)
//
// CONSTRUCTOR for the Graph<Vertex, Edge> class:
//   Graph( )
//     Postcondition: The Graph is empty.
//
// MODIFICATION MEMBER FUNCTIONS for the Graph<Vertex, Edge> class:
//   void clear( )
//     Postcondition: The Graph is empty.
//
//   bool insert(const Item& entry)
//     Postcondition: If an equal entry was already in the Graph, the Graph is
//     unchanged and the return value is false. Otherwise, entry was added
//     to the Graph and the return value is true. This is slightly different than
//     the C++ Standard Library Graph (see Appendix H).
//
//   bool erase(const Item& target)
//     Postcondition: If target was in the Graph, then it has been removed from
//     the Graph and the return value is true. Otherwise the Graph is unchanged
//     and the return value is false.
//
// CONSTANT MEMBER FUNCTIONS for the Graph<Vertex, Edge> class:
//   bool contains(const Item& target) const
//     Postcondition: Returns true if the target is in this Graph; otherwise false.
//
//  bool empty( ) const 
//     Postcondition: Returns true if the Graph is empty; otherwise returns false.
//
// VALUE SEMANTICS for the Graph<Vertex, Edge> class:
//   Assignments and the copy constructor may be used with Graph<Vertex, Edge> objects.
//
// DYNAMIC MEMORY USAGE by the Graph<Vertex, Edge> class:
//   If there is insufficient dynamic memory, then the following functions throw
//   bad_alloc: The constructors, insert, and the assignment operator.

#ifndef CSCI1300_GRAPH_H
#define CSCI1300_GRAPH_H
#include <cstdlib>   
#include <iomanip>
#include <iostream>
#include <string>
#include <cstring>
#include <vector>
#include "Vertex.h"
#include "Edge.h"

using namespace std;

namespace YOUR_NAME_HERE
{
    template <class Vertex, class Edge>
    class Graph
    {

    public:

        // CONSTRUCTORS and DESTRUCTOR
        Graph( );
        Graph(const Graph& source);
        ~Graph( ) { clear( ); }		// keep this line

        // MODIFICATION MEMBER FUNCTIONS
        Graph& operator =(const Graph& source);
        void clear( );
        bool addVertex(const string& newVertexname);
        bool removeVertex(const string& unwantedVertexName);
        Vertex& getVertex(const string& vertexName);
        Edge& getEdge(const string& fromVertexName, const string& toVertexName);
        bool setEdge(const string& fromVertexName, const string& toVertexName, const Edge& newEdge);
    	bool removeEdge(const string& fromVertexName, const string& toVertexName);
        // CONSTANT MEMBER FUNCTIONS
        int countVertices() const;
        int countEdges() const;
        bool containsVertex(const string& vertexName) const;
		bool containsEdge(const string& fromVertexname, const string& toVertexName) const;
        const Vertex& getVertex(const string& vertexName) const;
        const Edge& getEdge(const string& fromVertexName, const string& toVertexName) const;
        bool empty( ) const;

    private:
    
        // MEMBER VARIABLES
		// Here is where you declare your vectors (or maps, or arrays) of Vertex and Edge 
		// You need to add those lines FIRST
		// depending on what you decide, you may want to keep a counter for the
		// number of Vertex in the graph, and one for the number of Edge that aren't empty
	
	
        Vertex badVertex;	// you will need to keep this (an untrustworthy Vertex)
        Edge badEdge;		// and this (an untrustworthy Edge)
      };
}

#include "GraphTemplate.cxx"

#endif
