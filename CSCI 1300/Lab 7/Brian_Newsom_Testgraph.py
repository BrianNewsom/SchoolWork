from Graph import *
from Vertex import *
from Edge import *
def main():
# make a new Graph called fredo
	fredo = Graph()
# add 5 vertices
	fredo.addVertex('A')
	fredo.addVertex('B')
	fredo.addVertex('C')
	fredo.addVertex('D')
	fredo.addVertex('E')
#show graph with no edges
	fredo.display()
#check edge and vertex count
	if fredo.countEdges() !=0:
		print 'Edge count incorrect'
	else:
		print 'Edge count correct'

	if fredo.countVertices() != 5:
		print 'Vertex count incorrect'
	else:
		print 'Vertex count correct'
#Set edges to values
	fredo.setEdge('A', 'A', 1.0)
	fredo.setEdge('A', 'B', 2.0)
	fredo.setEdge('A', 'C', 3.0)
	fredo.setEdge('A', 'D', 4.0)
	fredo.setEdge('B', 'A', 5.0)
	fredo.setEdge('B', 'B', 6.0)
	fredo.setEdge('B', 'C', 7.0)
	fredo.setEdge('B', 'D', 8.0)	
	fredo.setEdge('C', 'A', 9.0)
	fredo.setEdge('C', 'B', 10.0)
	fredo.setEdge('C', 'C', 11.0)
	fredo.setEdge('C', 'D', 12.0)	
	fredo.setEdge('D', 'A', 13.0)
	fredo.setEdge('D', 'B', 14.0)
	fredo.setEdge('D', 'C', 15.0)
	fredo.setEdge('D', 'D', 16.0)
	fredo.setEdge('E', 'B', 17.0)
#Show new graph
	fredo.display()
#Check new edge count
	if fredo.countEdges() !=13:
		print 'Edge count 2 incorrect'
	else:
		print 'Edge count 2 correct'
#Add duplicate vertex
	fredo.addVertex('B')
#Check if vertex count remains same
	if fredo.countVertices() != 5:
		print 'Vertex count 2 incorrect'
	else:
		print 'Vertex count 2 correct'
#Remove zero edge from graph
	fredo.removeEdge('D','D')
#Ensure edge count remains same
	if fredo.countEdges() !=13:
		print 'Edge count 3 incorrect'
	else:
		print 'Edge count 3 correct'
#Remove vertex
	fredo.removeVertex('B')
#Display graph
	fredo.display()
#Check edges and Vertices
	if fredo.countEdges() !=6:
		print 'Edge count 4 incorrect'
	else:
		print 'Edge count 4 correct'
	if fredo.countVertices() !=4:
		print 'Vertex count 4 incorrect'
	else:
		print 'Vertex count 4 correct'
#Test graph clear (THIS IS A BUG)
	fredo.clear()
#Test to see if no vertices or edges remain
	if fredo.countEdges() !=0:
		print 'Edge count 5 incorrect'
	else:
		print 'Edge count 5 correct'
	if fredo.countVertices() !=0:
		print 'Vertex count 5 incorrect'
	else:
		print 'Vertex count 5 correct'

# no duplicate Vertex names, no edges from a Vertex to itself,
# edges with zero cost are just fillers--not real edges.
# Some examples to get you thinking about Graphs for the test:
# add a few Vertices to fredo, with different names.
# display fredo's representation of himself now
# quiz fredo about his vertexCount and edgeCount (this last should be 0)
# add a few Edges to fredo and test the edgeCount
# try a self edge and see if it changes edgeCount or displays
# try a duplicate Vertex and see if it changes vertexCount or displays
# set an existing Edge in the graph to a zero cost and ask if edgeCount has changed
# remove a zero edge from the graph and ask whether edgeCount has changed
# this line is needed to run main programs in Python. God only knows why.
if __name__ == "__main__":
	main()

