import numpy as np
import random as rand
import time
import matplotlib.pyplot as plt
import math
#Space is binary sequence of length L. 
#Each binary <=> index of J in base 10

def Create_J(L):
	J=np.ones((2**L,2**L))


def Species(N, m):
	#creates vectors
	s1=np.ones(N)
	s1[m:N]=0

	s2=np.ones(N)
	s2[0:m]=0

	return s1, s2, 


def JGen(s1,s2):
	#creates boolean disjoint J matrix, 1 if possible, 0 else
	#row index interacted on my column index
	J=np.outer(s1,s2)+np.outer(s2,s1)
	return J

def HGen(J, pop, k=10000, mu=1): #Make sure k ins't too high else we get inf and nan
	#pop= vector len(#spec)
	# print np.dot(J,pop.T)
	H=-mu*float(sum(pop))*np.ones(len(pop))+(k/float(sum(pop)))*np.dot(J, pop.T)
	for i in range(len(H)):
			if H[i] > 200:
				H[i]=200
	return H


def Create_J(L):
	J=np.zeros((2**L,2**L))-np.identity(2**L)
	
	return J

def Timestep(H, pop, pkill=0.05, pmut=0.2):
	
	# birth=rand.randint(0,len(pop)-1)
	p=pop/float(sum(pop))
	birth=np.random.choice(len(pop), p=p)
	while pop[birth]==0:
		# birth=rand.randint(0,len(pop)-1)
		birth=np.random.choice(len(pop), p=p)
	
	probb= np.exp(float(H[birth]))/(1+np.exp(float(H[birth])))
	x=rand.random()

	if x < probb:
		pop[birth]-=1	
		birth1=Mutation(birth, pmut)
		birth2=Mutation(birth, pmut)
		pop[birth1]+=1
		pop[birth2]+=1
	else:
		pass

	# death=rand.randint(0,len(pop)-1)
	#death not dependent on populations
	death=np.random.choice(len(pop), p=p)

	#dependant on poulation
	while pop[death] ==0:
		# death=rand.randint(0,len(pop)-1)
	 	death=np.random.choice(len(pop), p=p)
	z = rand.random()
	
	if z < pkill:
		pop[death]-=1

	return pop

def Mutation(birth, pmut):
	birthbin=list(bin(birth)[2:].zfill(int(math.log(len(pop),2))))
	
	for l in range(len(birthbin)):
		y=rand.random()
	
		if y < pmut:
			if birthbin[l] == '1':
				birthbin[l]='0'
			else:
				birthbin[l]='1'	
	
	return 	int(''.join(birthbin), base=2)

# pop=120*np.ones(2**3)
pop=np.array([0,0,500,500])
J=Create_J(int(math.log(len(pop),2)))
for i in range(len(J)):
	for j in range(len(J)):
		x=rand.uniform(0,1)
		if x <0.25:
			J[i][j]=0
		else:
			if i==j:
				J[i][j]=0
			else:
				J[i][j]=rand.uniform(-1,1)

J=np.array(np.matrix([[0, 0.3, -0.1, -0.6],[0.2, 0, 0,-0.1],[-0.1, 0, 0, 0.1],[-0.1, -0.4, 0.3, 0]]))
print J
T=4000000
y=time.time()
record=np.zeros((len(pop),T))
recordN=np.zeros(T)

for t in range(T):
	H=HGen(J, pop, k=10000, mu=0.2)
	pop = Timestep(H, pop, pkill=0.05, pmut=0.2)
	record[:,t] += pop
	recordN[t] += sum(pop)

for i in range(len(pop)):
	plt.plot(record[i,:])
print time.time()-y
plt.show()
plt.plot(recordN)
plt.show()