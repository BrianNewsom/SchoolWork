EXPENDABLES = lab8 lab8.o

all:	
	@make $(EXPENDABLES)

lab8 : lab8.o
	g++ -Wall -gstabs lab8.o -o lab8

# make object file (ends in .o) with partial compilation of code for the main program
lab8.o : lab8.cxx
	g++ -Wall -gstabs -c lab8.cxx -o lab8.o

clean:
	rm $(EXPENDABLES)
