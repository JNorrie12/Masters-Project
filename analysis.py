import numpy as np
import matplotlib.pyplot as plt

# TANA  ORIGINAL POPULATION----------------------------------
file = open("data_fast.txt", "r")
data = file.read()

data = data.split('\n')
# data =[row.split('\t') for row in data]
x =[row.split('\t')[0] for row in data]
y =[row.split('\t')[-1] for row in data]

x[-1] = x[-2]
y[-1] = y[-2]
# print data
# y = [row.split('\t')[1] for row in data]

fig = plt.figure()

ax1 = fig.add_subplot(111)

ax1.set_title("Total Population per genertion")    
ax1.set_xlabel('Generation')
ax1.set_ylabel('Population')

ax1.plot(x,y, c='r', label='the data')

leg = ax1.legend()

plt.show()
#----------------------------------------------------------
# file = open("pop.txt", "r")
# data = file.read()

# data = data.split('\n')
# # data =[row.split('\t') for row in data]
# x =[row.split('\t')[0] for row in data]
# # y =[row.split('\t')[-2] for row in data]
# z =[row.split('\t')[-1] for row in data]
# print x
# x[-1] = x[-2]
# y[-1] = y[-2]
# z[-1] = z[-2]

# fig = plt.figure()

# ax1 = fig.add_subplot(111)

# ax1.set_title("Total Population per genertion")    
# ax1.set_xlabel('Population')
# ax1.set_ylabel('Generation')

# ax1.plot(x,y, c='r', label='the data')
# ax1.plot(x, z , c='g', label='dada')

# leg = ax1.legend()

# plt.show()
#-----------------------------------------------------
# TANA
file = open("species_fast.txt", "r")
data = file.read()

data = data.split('\n')
# data =[row.split('\t') for row in data]
data=[row.split('\t') for row in data]

# fig = plt.figure()

# ax2 = fig.add_subplot(121)
ax1.set_xlabel('Generation')
ax1.set_ylabel('Species Label')
for i in range(len(data)-1):
	x=i*np.ones(len(data[i]))
	data[i][-1] = data[i][-2]
	y=[int(j) for j in data[i]]
	plt.scatter(x, y, color='blue', marker='.', s=5)

plt.show()




