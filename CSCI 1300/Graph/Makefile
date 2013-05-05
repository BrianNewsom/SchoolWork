
EXPENDABLES = Vertex.o Edge.o GraphTemplate.o TestGraph.o TestGraph

all:	
	@make $(EXPENDABLES)

TestGraph:Vertex.o Edge.o GraphTemplate.o TestGraph.o 
	g++ -Wall -gstabs -o GraphTemplate.o TestGraph.o Edge.o Vertex.o -o TestGraph
	
Vertex.o:Vertex.cxx
	g++ -Wall -gstabs -c Vertex.cxx -o Vertex.o

Edge.o:Edge.cxx
	g++ -Wall -gstabs -c Edge.cxx -o Edge.o

TestGraph.o:TestGraph.cxx
	g++ -Wall -gstabs -c TestGraph.cxx -o TestGraph.o

GraphTemplate.o: GraphTemplate.cxx GraphTemplate.h
	g++ -Wall -gstabs -c GraphTemplate.h -o GraphTemplate.o

# make object file (ends in .o) with partial compilation of code for the main program
run_chapter_3_examples.o:run_chapter_3_examples.cxx
	g++ -Wall -gstabs -c run_chapter_3_examples.cxx -o run_chapter_3_examples.o

clean:
	rm $(EXPENDABLES)
