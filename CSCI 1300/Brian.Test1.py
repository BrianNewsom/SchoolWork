import math
x=5
def infinite_series_exp(x):
	total=0
	iterations=int(raw_input('Enter number of terms: '))
	for i in range(0,iterations):
		term=x**i/math.factorial(i)
		total+=term
		i+=1
	print total
infinite_series_exp(x)	
