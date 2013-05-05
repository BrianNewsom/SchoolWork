EXPlENDABLES = Lab9 Lab9.o

all:	
	@make $(EXPENDABLES)

Lab9 : Lab9.o
	g++ -Wall -gstabs Lab9.o -o Lab9

# make object file (ends in .o) with partial compilation of code for the main program
Lab9.o : Lab9.cxx
	g++ -Wall -gstabs -c Lab9.cxx -o Lab9.o

clean:
	rm $(EXPENDABLES)
