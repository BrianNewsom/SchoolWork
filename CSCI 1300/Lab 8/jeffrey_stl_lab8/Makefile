EXPENDABLES = stl_fun stl_fun.o

all:	
	@make $(EXPENDABLES)

stl_fun : stl_fun.o
	g++ -Wall -gstabs stl_fun.o -o stl_fun

# make object file (ends in .o) with partial compilation of code for the main program
stl_fun.o : stl_lab8.cxx
	g++ -Wall -gstabs -c stl_lab8.cxx -o stl_fun.o

clean:
	rm $(EXPENDABLES)
