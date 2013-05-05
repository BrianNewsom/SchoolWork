/*
   Graph.cpp

   This is your implementation file for the depth-first and
   breadth-first search assignment. All the documentation and
   instructions are in the header file.

   Your Name: BRIAN NEWSOM!

   Your Collaborators: Dawson Botsford, David Aleman, Alec Thilenius, LA's, Steven 

 */
#include <iostream>
#include <string>
#include <set>
#include "graph.hpp"

using namespace std;

void clearQ(vector<Node*> &Q);

Graph::Graph() {
  // graphs are undirected by default
  directed = false;
}

Graph::~Graph() {

}

vector<Node*> Graph::getNodes() {
  return nodes;
}

vector<Edge*> Graph::getEdges() {
  return edges;
}

int Graph::getClock() {
  return clock;
}

void Graph::addNode(Node& n) {
  nodes.push_back(&n);
}

void Graph::addEdge(Edge& e) {
  edges.push_back(&e);
}
 
void Graph::removeNode(Node& n) {
  for (vector<Node*>::iterator it = nodes.begin();
       it != nodes.end(); 
       it++) {
    if (&n == *it) {
      nodes.erase(it);
      break;
    }
  }
}
 
void Graph::removeEdge(Edge& e) {
  for (vector<Edge*>::iterator it = edges.begin();
       it != edges.end(); 
       it++) {
    if (&e == *it) {
      edges.erase(it);
      break;
    }
  }
}

void Graph::setDirected(bool val) {
  directed = val;
}

bool Graph::isDirected() {
  return directed;
}

set<Edge*> Graph::getAdjacentEdges(Node& n) {
  set<Edge*> ret;
  for (vector<Edge*>::iterator it = edges.begin(); it != edges.end(); it++) {
    Edge* edge = *it;
    if (edge->getStart() == &n) {
      ret.insert(edge);
    }
    if (!directed && edge->getEnd() == &n) {
      ret.insert(edge);
    }
  }
  return ret;
}

void Graph::clear() {
  clock = 0;
  //for (size_t i = 0 ; i < nodes.size(); i++)
  //  Node* n = nodes[i];
  vector<Node*>::iterator it = nodes.begin();
  for( ; it != nodes.end(); it++){
    Node* n = *it;
    n->clear();
  }
  vector<Edge*>::iterator eit = edges.begin();
  for (; eit != edges.end(); eit++){
    Edge* e = *eit;
    e->setType(UNDISCOVERED_EDGE);
  }

  /*  vector<Edge*>::iterator edgeIt = edges.begin();
  for(edgeIt ; edgeIt != edges.end() ; edgeIt++){
    (*edgeIt)->setType(UNDISCOVERED_EDGE);
  }
  vector<Node*>::iterator nodeIt = nodes.begin();
  for(nodeIt ; nodeIt != nodes.end() ; nodeIt++){
    (*nodeIt)->clear();
  }
  clock = 0;
  */ 
}

void Graph::tick(string message) {
  // optional debugging function
}

void Graph::dfs(Node& start){
  clock++;
  start.setColor(GRAY,clock);
  set<Edge*> e = getAdjacentEdges(start);
  set<Edge*>::iterator it = e.begin();
  for( ; it!= e.end() ; it++){
    //a = other end of e
    Edge* q = *it; //CURRENT Edge;
    Node* a = q->getEnd(); //end node
    int color, disco_time, finish_time, bfs_rank;
    a->getDiscoveryInformation(color, disco_time, finish_time, bfs_rank);
    if(color == WHITE){
      a->setPredecessor(start);
      q->setType(TREE_EDGE);//Set Edge types
      dfs(*a);
      
    }
    if (color == GRAY)
      q->setType(BACK_EDGE);
    if (color == BLACK){
      if (start.isAncestor(*q->getEnd())){
    	q->setType(CROSS_EDGE);
      }	
      else{
	q->setType(FORWARD_EDGE);
      }
    
    }
  }
  start.setColor(BLACK,clock);
}

void Graph::dfs(Node& start, Node& finish) {
  // implement me. see header file for info.
}

void Graph::bfs(Node& start) {
  vector<Node*> Q;
  Q.clear();
  Q.push_back(&start);
  start.setRank(1);
  start.setColor(GRAY, ++clock);
  while(!Q.empty()){
    Node* n = Q.back();
    Q.pop_back();//Deque
    n->setColor(BLACK, clock);
    set<Edge*> e = getAdjacentEdges(*n);
    set<Edge*>::iterator it = e.begin();
    int color, disco_time, finish_time, bfs_rank;
    n->getDiscoveryInformation(color, disco_time, finish_time, bfs_rank);
    for(it = e.begin() ; it!= e.end() ; it++){
      //a = other end of e
      Edge* q = *it; //CURRENT Edge;
      Node* a;
      if (q->getStart() == n)
		a = q->getEnd();
      else
		a = q->getStart();
      int col1, dt1, ft1, bf1;
      a->getDiscoveryInformation(col1, dt1, ft1, bf1);
      if(col1 == WHITE){
	Q.insert(Q.begin(),a);
	a->setColor(GRAY, ++clock);
	a->setRank(bfs_rank+1);
      }
    }
  }
// implement me. see header file for info.
}
/*
void otherEnd(Node& start, Edge& e){
  if (e.getEnd() == start){
    return e.getStart();
  }
  else 
    return e.getEnd();
}
*/
void Graph::bfs(Node& start, Node& finish) {
  // implement me. see header file for info.
}

Node::Node(string s) {
  data = s;
}

Node::~Node() {
  // This is equivalent to the default destructor the compiler will
  // generate for you. As a rule of thumb, you only need to `delete`
  // member variables that were created with `new` inside this
  // class. So, you don't need to do anything here. It could have been
  // left out of the header/impl file entirely.
}

string Node::getData() {
  return data;
}

void Node::setRank(int r) {
  rank = r;
}

void Node::clear() {
  this->color = WHITE;
  this->discovery_time = -1;
  this->completion_time = -1;
  this->rank = -1;
  this->predecessor = NULL;
}

void Node::setColor(int search_color, int time) {
  color = search_color;
  if(color == WHITE)
    this->clear();
  if(color == GRAY)
    discovery_time = time;
  if(color == BLACK)
    completion_time = time;
}

void Node::getDiscoveryInformation(int& color, int& disco_time, 
				   int& finish_time, int& bfs_rank) {
  //color is the parameter
  //this-> is the member variable
  color = this->color;
  disco_time = discovery_time;
  finish_time = completion_time;
  bfs_rank = rank;
}

bool Node::isAncestor(Node& other) {
  if (this->predecessor == &other)
    return true;
  if (predecessor == NULL)
    return false;
  else 
    return (isAncestor(*(this->predecessor)));
}

void Node::setPredecessor(Node& other) {
  predecessor = &other;
  // implement me.
}

Edge::Edge(Node& n1, Node& n2) {
  a = &n1;
  b = &n2;
  weight = 1.0;
}

Edge::~Edge() {
}

float Edge::getWeight() {
  return weight;
}

void Edge::setWeight(float val) {
  weight = val;
}

Node* Edge::getStart() {
  return a;
}

Node* Edge::getEnd() {
  return b;
}

int Edge::getType() {
  return type;
}

void Edge::setType(int edge_type) {
  this->type = edge_type;
}

string what(int& v) {
  // HINT: Make use of this debugging function!
  string ret = "Unknown";
  if (v == WHITE) {
    ret = "White";
  } else if (v == GRAY) {
    ret = "Gray";
  } else if (v == BLACK) {
    ret = "Black";
  } else if (v == UNDISCOVERED_EDGE) {
    ret = "Undiscovered";
  } else if (v == TREE_EDGE) {
    ret = "Tree";
  } else if (v == BACK_EDGE) {
    ret = "Back";
  } else if (v == FORWARD_EDGE) {
    ret = "Forward";
  } else if (v == CROSS_EDGE) {
    ret = "Cross";
  }
  return ret;
}

ostream &operator << (ostream& out, Graph graph) {
  out << graph.nodes.size() << " Nodes:" << endl;
  out << "[";
  for (vector<Node*>::iterator it = graph.nodes.begin(); it != graph.nodes.end(); it++) {
    Node* n = *it;
    out << *n << ", ";
  }
  out << "]" << endl;
  out << graph.edges.size() << " Edges:" << endl;
  out << "[";
  for (vector<Edge*>::iterator it = graph.edges.begin(); it != graph.edges.end(); it++) {
    Edge* e = *it;
    out << *e << ", ";
  }
  out << "]";
  return out;
}

ostream &operator << (std::ostream& out, Node node) {
  out << node.data;// << "color: " << node.color << "dt/ft: " << node.discovery_time << "/" << node.completion_time;
  return out;
}

ostream &operator << (std::ostream& out, Edge edge) {
  out << *edge.a << " -- " << *edge.b;
  return out;
}

