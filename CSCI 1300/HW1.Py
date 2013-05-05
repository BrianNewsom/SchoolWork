# NAME: Brian Newsom
# LECTURE SECTION: MWF 1-2 PM
# RECITATION SECTION: W 9-10 AM

import math

def infinite_sin_1(x):
	iterations = int(raw_input('Enter the number of sine terms to add up: '))
	total = 0
	for i in range(0, iterations, 1):
		i+=i
        lastterm = ((-x)**(2*i+1))/(math.factorial(i)(2*i+1))
		total+lastterm=total
	return total

def infinite_cos_1(x):
	iterations = int(raw_input('Enter the number of cosine terms to add up: '))
	total = 0
	for ____________________________:
		# compute the ith term

		# add this term to total

	return total
	
# here is where you can test your code

x = math.pi/3	
real_sine = math.sin(x)
real_cosine = math.cos(x)
my_inf_sin_1 = infinite_sin_1(x)	
my_inf_cos_1 = infinite_cos_1(x)	

# print the answers out to 25 digits after the decimal, to inspect them

print 'real sine:', "%0.25f" % real_sine
print 'my sine 1:', "%0.25f" % my_inf_sin_1			
print 'my sine is accurate to:', "%0.25f" % math.fabs(real_sine-my_inf_sin_1) 
print 'real cosine:', "%0.25f" % real_cosine
print 'my cosine 1:', "%0.25f" % my_inf_cos_1			
print 'my cosine is accurate to:', "%0.25f" % math.fabs(real_cosine-my_inf_cos_1)

