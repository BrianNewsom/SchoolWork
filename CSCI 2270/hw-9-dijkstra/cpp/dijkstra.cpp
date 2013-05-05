/*
   dijkstra.cpp

   ------------------------------------------------------------

   A reprise of the 'graph.cpp' file, but modified for doing
   Dijkstra's algorithm.  All the graphs in this assignment are DAGs,
   though be aware that Dijkstra's does not require this. Only
   implement the parts you really need!

   You are responsible for implementing:

   Graph::isDAG(),

   Graph::dijkstra(Node*), and

   Graph::dijkstra(Node*, Node*).

   You will likely need to write some helper functions to babysit your
   Tree* and priority queue (or pq substitute). How you do this is up
   to you!

   ------------------------------------------------------------


   Your Name: Brian Newsom

   Your Collaborators: Ian Courtney, Dawson Botsford

 */

#include "dijkstra.hpp"

using namespace std;


void bubblesort(vector<Node*> &vect_nodes);

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
  for (size_t i = 0; i < edges.size(); i++) {
    Edge* edge = edges[i];
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
  
  //Remember new node members?
}

void Graph::tick(string message) {
  // optional
}

void Graph::dfs(Node& start) {
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

  // implement (just like last week. copy/paste)
}

void Graph::dfs(Node& start, Node& finish) {
  // implement if you think it is necessary
}

/**
 * Perform Dijkstra's algorithm for finding the minimum path length
 * from the given start node to all other reachable nodes in the
 * graph.
 *
 * Return the spanning tree that is rooted at the given start node,
 * with a path to all reachable nodes.
 **/
Tree* Graph::dijkstra(Node* start) {
  start->setPathDistance(0);
  Tree* tree = new Tree;
  tree->setRoot(start);
  vector<Node*> Nodes = getNodes();
  vector<Node*> vNodes;
  vector<Node*>::iterator it = Nodes.begin();
  for( ; it!= Nodes.end(); it++){
    vNodes.push_back(*it);
  }
//bubblesort(Nodes);
  while(!vNodes.empty()){
    Node* current = *vNodes.begin();
    vNodes.erase(vNodes.begin());
    if (current->getPathDistance() == INFINITY)
      return tree;
    //  cout << *current;
    set<Edge*> adj_edges = getAdjacentEdges(*current);
    set<Edge*>::iterator it = adj_edges.begin();
    Edge* q;
    Node* n;
    for(it = adj_edges.begin() ; it!= adj_edges.end() ; it++){
      //a = other end of e
      q = *it; //CURRENT Edge;
      if (q->getStart() == current)
	n = q->getEnd();
      else
	n = q->getStart();
      // cout << n;
      //tree->print_tree();
      /*  if (std::find(Nodes.begin(), Nodes.end(), n)!=Nodes.end()){
	cout << "TEST" << endl;
	continue;
      }
      */
      for(size_t i = 0; i < vNodes.size() ; i++){
	if (vNodes[i] == n)
	  continue;
      }
      //cout << "get Weight: " << q->getWeight() << endl;
      //cout << "current pd: " << current->getPathDistance() << endl;
      float d = current->getPathDistance() + q->getWeight();
      //cout << "d is: " << d << endl;
      if (d < n->getPathDistance()){
	n->setPathDistance(d);
	tree->update(n, n->getPredecessor(), current);
	n->setPredecessor(*current);
	vNodes.push_back(n);
	bubblesort(Nodes);
      }
    }
  }
  //tree->print_tree();
  return tree;
}

void bubblesort(vector<Node*> &vect_nodes)
{
  Node* temp;
  unsigned int size = vect_nodes.size();
      for (unsigned int j = size-1; j > 0; j--)
	{
		for (unsigned int i = 0; i < size-1 ; i++)
		{
			if ( vect_nodes[i]->getPathDistance() > vect_nodes[i+1]->getPathDistance())
			{
				temp = vect_nodes[i];
				vect_nodes[i] = vect_nodes[i+1];
				vect_nodes[i+1] = temp;
			}
	     }
	     size--;
	 }
}
/**
 * Perform Dijkstra's algorithm like in the other version, but end
 * the algorithm when a definitive path length is found to the given
 * end node. Note that the end node might be unreachable.
 *
 * Return the spanning tree that was found during this search. Note
 * that when an answer is found for the path from start to end, the
 * algorithm stops, so the tree may be incomplete compared with what
 * is produced from the single-argument version of the dijkstra
 * function.
 **/
Tree* Graph::dijkstra(Node* start, Node* end) {
  Tree* tree = new Tree;
  tree->setRoot(start);
  vector<Node*> v;
  v.push_back(start);
  for(unsigned int i = 1; i< nodes.size(); i++)
    {
      v.insert(v.begin(), nodes[i]);
      nodes[i]->setPathDistance(INT_MAX);
        
    }
  start->setPathDistance(0);
  while(!v.empty())
    {
      Node* temp= v.back();
      v.pop_back();
      if(temp==end)
	{
	  return tree;
	}
      set<Edge*> e = getAdjacentEdges(*temp);
      set<Edge*>::iterator it = e.begin();
      for (; it != e.end(); it++)
	{
	  Edge* q = *it;
	  Node* n = q->getEnd();
	  float d = temp->getPathDistance() + q->getWeight();
	  if(d < n ->getPathDistance())
	    {
	      n->setPathDistance(d);
	      tree->update(n,n->getPredecessor(),temp);
	      n->setPredecessor(*temp);
	    }
	}       
    }
  return tree;
}



/**
 * Is this graph a DAG or not? Return true if it is, false if not.
 **/
bool Graph::isDAG() {
  clear();
  //  if(directed){
    vector<Node*> Nodes = getNodes();
    dfs(**(Nodes.begin()));
    vector<Edge*> Edges = getEdges();
    vector<Edge*>::iterator it = Edges.begin();
    for ( ; it!= Edges.end(); it++){
      Edge* e = *it;
      int type = e->getType();
      if( type == BACK_EDGE )
	return false;
    }
      }
    return true; 
    //dfs(
    //run dfs look for back_edges
}
Node::Node(string s) {
  data = s;
}

Node::~Node() {

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
  this->path_distance = INFINITY;


 // implement me
}

void Node::setColor(int search_color, int time) {
  color = search_color;
  if(color == WHITE)
    this->clear();
  if(color == GRAY)
    discovery_time = time;
  if(color == BLACK)
    completion_time = time;
  // implement me
}

void Node::getDiscoveryInformation(int& color, int& disco_time, 
				   int& finish_time, int& bfs_rank) {
  color = this->color;
  disco_time = discovery_time;
  finish_time = completion_time;
  bfs_rank = rank;
  // implement me
}

bool Node::isAncestor(Node& other) {

  if (this->predecessor == &other)
    return true;
  if (predecessor == NULL)
    return false;
  else 
    return (isAncestor(*(this->predecessor)));
  // implement me if you think it is necessary
}

void Node::setPredecessor(Node& other) {
  predecessor = &other;
}

Node* Node::getPredecessor() {
  return predecessor;
}

float Node::getPathDistance() const {
  return path_distance;
}

void Node::setPathDistance(float pd) {
  path_distance = pd;
}

Edge::Edge(Node& n1, Node& n2) {
  a = &n1;
  b = &n2;
  weight = 1.0;
}

Edge::Edge(Node& n1, Node& n2, float w) {
  a = &n1;
  b = &n2;
  weight = w;
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
  type = edge_type;
}

ostream &operator << (ostream& out, Graph graph) {
  out << graph.nodes.size() << " Nodes:" << endl;
  out << "[";
  for (size_t i = 0; i < graph.nodes.size(); i++) {
    Node* n = graph.nodes[i];
    out << *n << ", ";
  }
  out << "]" << endl;
  out << graph.edges.size() << " Edges:" << endl;
  out << "[";
  for (size_t i=0; i < graph.edges.size(); i++) {
    Edge* e = graph.edges[i];
    out << *e << ", ";
  }
  out << "]";
  return out;
}

ostream &operator << (std::ostream& out, Node node) {
  out << node.data << " (";
  if (node.color == WHITE) {
    out << "White ";
  } else if (node.color == GRAY) {
    out << "Gray ";
  } else if (node.color == BLACK) {
    out << "Black ";
  } else {
    out << "??? ";
  }
  out << node.discovery_time << "/" << node.completion_time;
  out << " bfs_rank: " << node.rank;
  out << ")";
  return out;
}

ostream &operator << (std::ostream& out, Edge edge) {
  out << *edge.a << " -- " << *edge.b;
  out << " (";
  if (edge.type == UNDISCOVERED_EDGE) {
    out << "Undiscovered";
  } else if (edge.type == TREE_EDGE) {
    out << "Tree";
  } else if (edge.type == BACK_EDGE) {
    out << "Back";
  } else if (edge.type == FORWARD_EDGE) {
    out << "Forward";
  } else if (edge.type == CROSS_EDGE) {
    out << "Cross";
  }
  out << ")";
  return out;
}

/**
 * Make a new tree node for the given node.
 **/
TreeNode::TreeNode(Node* data) {
  this->node = data;
}

/**
 * Find a TreeNode that has the given data in this tree's member list,
 * or NULL if none are found.
 **/
TreeNode* Tree::find(Node* data) {
  vector<TreeNode*>::iterator tnit = members.begin();
  for (;tnit != members.end(); tnit++) {
    TreeNode* tn = *tnit;
    if (tn->node == data) {
      return tn;
    }
  }
  return NULL;
}

/**
 * Updates the tree such that (a) child is inserted into the tree if
 * necessary, (b) old_parent no longer refers to child, and (c)
 * new_parent does.
 **/
void Tree::update(Node* child, Node* old_parent, Node* new_parent) {
  TreeNode* child_tn = find(child);
  TreeNode* old_parent_tn = find(old_parent);
  TreeNode* new_parent_tn = find(new_parent);
  // if both the child and parent were present, remove the
  // now-outdated relationship.
  if (child_tn != NULL && old_parent_tn != NULL) {
    vector<TreeNode*>::iterator tnit;
    tnit = std::find(old_parent_tn->children.begin(), 
		old_parent_tn->children.end(), child_tn);
    if (tnit != old_parent_tn->children.end()) {
      old_parent_tn->children.erase(tnit);
    }
  }
  // if child_tn is null it means we don't yet know about the
  // child. We should add a new TreeNode to the members list.
  if (child_tn == NULL) {
    child_tn = new TreeNode(child);
    members.push_back(child_tn);
  }
  // if new_parent_tn is null, that's a straight up bug.
  if (new_parent_tn == NULL) {
    cout << "WARNING: New parent has no tree node in tree." << endl;
    cout << "         This is definitely a bug." << endl;
  } else {
    new_parent_tn->children.push_back(child_tn);
  }
}

/**
 * Sets the root node of the tree, clears the membership list, and
 * inserts the root into that membership list.
 **/
void Tree::setRoot(Node* n) {
  root = new TreeNode(n);
  members.clear();
  members.push_back(root);
}

/**
 * Gives you the root of the tree.
 **/
TreeNode* Tree::getRoot() {
  return root;
}

/**
 * Private member function implementation. Prints the tree with
 * multi-level output depending on where you are. This is recursive.
 **/
void Tree::print_tree(TreeNode* tn, int lvl) {
  // leave the cout statements in
  for (int i=0; i < lvl; i++) {
    cout << " . ";
  }
  cout << tn->node->getData() << " dist: " << tn->node->getPathDistance() << endl;
  for (size_t i = 0; i < tn->children.size(); i++) {
    print_tree(tn->children[i], lvl+1);
  }
}

/**
 * Prints the tree in a nice output form to standard output.
 **/
void Tree::print_tree() {
  TreeNode* cursor = root;
  print_tree(cursor, 0);
}

