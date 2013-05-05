using namespace std;namespace Brian_Newsom{	// Initialize an empty Graph; there is not so much work to do here 	// if you use the STL classes as members, since they initialize for you.	// But you should set your badEdge and badVertex up in this code. 	template<class Vertex, class Edge>	Graph<Vertex, Edge>::Graph()	{		    }        // Initialize a new Graph from an existing one.      // This should result in 2 independent Graphs.    template<class Vertex, class Edge>    Graph<Vertex, Edge>::Graph(const Graph<Vertex, Edge>& source)    {		// STUB		    }	// assign one Graph to another.  In this case you want to overwrite the	// data of the receiver Graph with the data of the donor Graph.  	// Again, the 2 Graphs should be independent after this code executes.    template<class Vertex, class Edge>    Graph<Vertex, Edge>& Graph<Vertex, Edge>::operator =(const Graph<Vertex, Edge>& source)    {		return *this; // STUB, but you will keep this as the last line    }	// clear out the Graph's data and reset it to be an empty Graph    template<class Vertex, class Edge>    void Graph<Vertex, Edge>::clear( )    {		// STUB		    }	// tell me how many Vertex entries you have in the Graph    template<class Vertex, class Edge>    int Graph<Vertex, Edge>::countVertices( ) const	{		return 0;	// STUB	}		// tell me how many (non-zero) Edge entries you have in the Graph	template<class Vertex, class Edge>    int Graph<Vertex, Edge>::countEdges( ) const	{		return 0;	// STUB	}		// Give me a Vertex in the Graph with this name, but don't let me change the Vertex	// return the "bad vertex" if the name doesn't match    template<class Vertex, class Edge>    const Vertex& Graph<Vertex, Edge>::getVertex(const string& vertexName) const    {		return badVertex; 	// STUB    }	// Give me a Vertex in the Graph with this name, but don't let me change the Vertex	// return the "bad vertex" if the name doesn't match    template<class Vertex, class Edge>    Vertex& Graph<Vertex, Edge>::getVertex(const string& vertexName)    {		return badVertex;	// STUB    }	// tell me if the Graph is empty    template<class Vertex, class Edge>    bool Graph<Vertex, Edge>::empty( ) const    {		return true;	// STUB    }	// add a Vertex to the Graph, but do not allow duplicate names.  	// return true if the Vertex added normally and false if something went weird.    template<class Vertex, class Edge>    bool Graph<Vertex, Edge>::addVertex(const string& newVertexName)    {		return true; // STUB    }	// take a Vertex out of the Graph and adjust for any gaps in your storage	// remember to take out the edges to and from this guy as well    template<class Vertex, class Edge>    bool Graph<Vertex, Edge>::removeVertex(const string& unwantedVertexName)    {		return true; // STUB    }    	// Give me an Edge in the Graph between 2 Vertex with these names, but don't let me change the Edge 	// return the "bad edge" if the Vertex names don't match any Vertex we have    template<class Vertex, class Edge>    const Edge& Graph<Vertex, Edge>::getEdge(const string& fromVertexName, const string& toVertexName) const    {		return badEdge; // STUB    }	// set an Edge from one Vertex to another; return true if nothing gets weird	// if the Vertex names you are given don't match anything in your graph, return false	// if the Edge already exists, overwrite it with this edge.  We don't allow multiple edges	// between 2 Vertex.    template<class Vertex, class Edge>    bool Graph<Vertex, Edge>::setEdge(const string& fromVertexName, const string& toVertexName, const Edge& newEdge)     {		return true; 	// STUB    }	// Tell me if the Graph contains a Vertex with this name.  Return true if so, false if not.    template<class Vertex, class Edge>    bool Graph<Vertex, Edge>::containsVertex(const string& vertexName) const    {		return true; // STUB    }	// Remove or 'zero out' an edge so it's no longer connecting 2 Vertex.	// return true if this goes normally and false if the Vertex names are bogus.    template<class Vertex, class Edge>    bool Graph<Vertex, Edge>::removeEdge(const string& fromVertexName, const string& toVertexName)    {		return true; // STUB    }    	// Tell me if the Graph contains a nonzero Edge between 2 Vertex given by name.  	// Return true if so, false if not. Return false if the Vertex names are not in the Graph, too.     template<class Vertex, class Edge>    bool Graph<Vertex, Edge>::containsEdge(const string& fromVertexName, const string& toVertexName) const    {		return true; // STUB    }}