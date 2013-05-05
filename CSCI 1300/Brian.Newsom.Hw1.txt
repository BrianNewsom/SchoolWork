# NAME: Brian Newsom
# LECTURE SECTION: MWF 1-2 PM
# RECITATION SECTION: W 9-10 AM

import math
def infinite_sin_x(x):
	iterations = int(raw_input('Enter the number of sine terms to add up: ')) #Allows user to input how many terms they wish to see in the expansion of sin
	totalsin = 0 #Sets initial value for totalsin
	for i in range(0, iterations, 1): #Repeats following until i reaches iterations
		term = ((-1)**i*x**(2*i+1))/(math.factorial(2*i+1)) #Mathematical equation to define next term based on x and i
		totalsin = totalsin+term #Adds new term to total
		i +=i #Advances counter
	return totalsin #Stores solution to function as totalsin
def infinite_cos_x(x):
	iterations = int(raw_input('Enter the number of cosine terms to add up: '))
	totalcos = 0
	for i in range(0, iterations, 1):
		term = ((-1)**i*x**(2*i))/(math.factorial(2*i))#Slightly changed logic to provide McLaurin expansion for cos(x)
		totalcos=totalcos+term
		i +=i
	return totalcos
x=math.pi/3 #Value for x variable
my_sine = infinite_sin_x(x)
my_cosine = infinite_cos_x(x)
real_sine = math.sin(x) 
real_cosine = math.cos(x) #Defines actual values of sin and cos
	# print the answers out to 25 digits after the decimal, to inspect them

print 'real sine:', "%0.25f" % real_sine
print 'my sine 1:', "%0.25f" % my_sine		
print 'my sine is accurate to:', "%0.25f" % math.fabs(real_sine-my_sine) 
print 'real cosine:', "%0.25f" % real_cosine
print 'my cosine 1:', "%0.25f" % my_cosine	
print 'my cosine is accurate to:', "%0.25f" % math.fabs(real_cosine-my_cosine)
