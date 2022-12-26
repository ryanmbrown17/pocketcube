import numpy as np
import pandas as pd
import scipy.sparse as sp
import pickle as pk
from joblib import Parallel, delayed
import matplotlib.pyplot as plt
import math as mt
import seaborn as sns

def moment(p,v,n):
	sum = 0
	for i in range(len(p)):
		sum += pow(v[i],n)*p[i]
	return sum 


def load(c,g):
	for j in range(3674160):
		for i in range(1,7):	
			c[g[0][j]-1,g[i][j]-1]=1/6
		if(j%100000 == 0):
			print(j)
	m= sp.csr_matrix(c)
	return m

def power(pv,m,n):
	p = pv
	for i in range(n):
		p = m*p
	return p
def power_moment(p,m,n,v,l):
	pv = power(p,m,n)
	return moment(pv,v,l)

def varience(p,v):
	return moment(p,v,2)-moment(p,v,1)**2

def std_dev(p,v):
	return mt.sqrt(varience(p,v))

def power_varience(p,v,m,n):
	pv = power(p,m,n)
	return varience(pv,v)

def power_std_dev(p,v,m,n):
	pv = power(p,m,n)
	return mt.sqrt(varience(pv,v))

##Change this from 1, np.inf, -np,inf, 2, etc. for norm
def power_norm(pv,m,i,even_steady_state,odd_steady_state,t):
	#print(i)
	#print(i,power(pv,m,i))
	if(i%2 ==0):
		return np.linalg.norm(power(pv,m,i) - even_steady_state,t)
	return np.linalg.norm(power(pv,m,i) - odd_steady_state,t)

def power_exp(length,pv,m,i):
	return np.dot(length,power(pv,m,i))

def prob_heat(pv):
	lst = [0.0]*15
	lst[0] = pv[0]*100
	lst[1] = sum(pv[1:6])*100
	lst[2] = sum(pv[7:33])*100
	lst[3] = sum(pv[34:153])*100
	lst[4] = sum(pv[154:687])*100
	lst[5] = sum(pv[688:2943])*100
	lst[6] = sum(pv[2944:11912])*100
	lst[7] = sum(pv[11913:44970])*100
	lst[8] = sum(pv[44971:159119])*100
	lst[9] = sum(pv[159120:519627])*100
	lst[10] = sum(pv[519628:1450215])*100
	lst[11] = sum(pv[1450216:2801067])*100
	lst[12] = sum(pv[2801068:3583603])*100
	lst[13] = sum(pv[3583604:3673883])*100
	lst[14] = sum(pv[3673884:3674159])*100
	return np.array(lst)


def power_prob_heat(pv,m,n):
	return prob_heat(power(pv,m,n))

def cum_sum(pv):
	p = pv
	for i in range(1,len(pv)):
		p[i] = p[i]+p[i-1]
	return p

def iqr(pv):
	lst = [0]*3
	p = cum_sum(prob_heat(pv))
	i = 0
	while(p[i]<25):
		i+=1
	lst[0]=i
	while(p[i]<50):
		i+=1
	lst[1]=i
	while(p[i]<75):
		i+=1
	lst[2]=i
	return np.array(lst)
def power_iqr(pv,m,n):
	return iqr(power(pv,m,n))

def percentiles(pv,num):
	lst = [0]*9
	p = cum_sum(prob_heat(pv))
	#print(p)
	i=0
	while(p[i]<num):
		if(i<=13):
			i+=1
		else:
			return i
	return i

def power_pecentiles(pv,m,n,num):
	#print("POWER PERCENTILES")
	print(n)
	return percentiles(power(pv,m,n),num)

#g = pd.read_csv('graph_rename.csv',header=None)
#c = sp.lil_matrix((3674160,3674160),dtype=float)
#filehandler = open('adjencency_matrix.obj', 'wb') 
#pk.dump(load(c,g), filehandler)


file_pi = open('adjencency_matrix.obj','rb')
m = pk.load(file_pi)


## Starting Probabilitity Distribution
lst = [0.0]*3674160
lst[0] = 1.0
pv = np.array(lst)


## 1837080 Elements Even & Odd Distance Away

#### Even
#lst = [0]*3674160
#lst[0] = 1/1837080
#for i in range(7,34):
#	lst[i]= 1/1837080
#for i in range(154,688):
#	lst[i]= 1/1837080
#for i in range(2944,11913):
#	lst[i]= 1/1837080
#for i in range(44971,159120):
#	lst[i]= 1/1837080
#for i in range(519628,1450216):
#	lst[i]=  1/1837080
#for i in range(2801068,3583604):
#	lst[i]= 1/1837080
#for i in range(3673884,3674160):
#	lst[i]= 1/1837080
#even_steady_state = np.array(lst)
##print(even_steady_state)
#### Odd
#lst = [0]*3674160
#for i in range(1,7):
#	lst[i]= 1/1837080
#for i in range(34,154):
#	lst[i]=1/1837080
#for i in range(688,2944):
#	lst[i]=1/1837080
#for i in range(11913,44971):
#	lst[i]=1/1837080
#for i in range(159120,519628):
#	lst[i]=1/1837080
#for i in range(1450216,2801068):
#	lst[i]=1/1837080
#for i in range(3583604,3673884):
#	lst[i]=1/1837080
#odd_steady_state = np.array(lst)
##print(odd_steady_state)




lst = [0]*3674160
for i in range(1,7):
	lst[i]=1
for i in range(7,34):
	lst[i]=2
for i in range(34,154):
	lst[i]=3
for i in range(154,688):
	lst[i]=4
for i in range(688,2944):
	lst[i]=5
for i in range(2944,11913):
	lst[i]=6
for i in range(11913,44971):
	lst[i]=7
for i in range(44971,159120):
	lst[i]=8
for i in range(159120,519628):
	lst[i]=9
for i in range(519628,1450216):
	lst[i]=10
for i in range(1450216,2801068):
	lst[i]=11
for i in range(2801068,3583604):
	lst[i]=12
for i in range(3583604,3673884):
	lst[i]=13
for i in range(3673884,3674160):
	lst[i]=14

length = np.array(lst)



#results = [0]*50
#results[0] = power_pecentiles(pv,m,0)
#results[1] = power_pecentiles(pv,m,1)
#results[2] = power_pecentiles(pv,m,2)
#results[3] = power_pecentiles(pv,m,3)
#results[4] = power_pecentiles(pv,m,4)
#results[5] = power_pecentiles(pv,m,5)
#results[6] = power_pecentiles(pv,m,6)
#results[7] = power_pecentiles(pv,m,7)
#results[8] = power_pecentiles(pv,m,8)
#results[9] = power_pecentiles(pv,m,9)
#results[10] = power_pecentiles(pv,m,10)
#results[11] = power_pecentiles(pv,m,11)
#results[12] = power_pecentiles(pv,m,12)
#results[13] = power_pecentiles(pv,m,13)
#results[14] = power_pecentiles(pv,m,14)
#results[15] = power_pecentiles(pv,m,15)
#results[16] = power_pecentiles(pv,m,16)
#results[17] = power_pecentiles(pv,m,17)
#results[18] = power_pecentiles(pv,m,18)
#results[19] = power_pecentiles(pv,m,19)
#results[20] = power_pecentiles(pv,m,20)
#results[21] = power_pecentiles(pv,m,21)
#results[22] = power_pecentiles(pv,m,22)
#results[23] = power_pecentiles(pv,m,23)
#results[24] = power_pecentiles(pv,m,24)
#results[25] = power_pecentiles(pv,m,25)
#results[26] = power_pecentiles(pv,m,26)
#results[27] = power_pecentiles(pv,m,27)
#results[28] = power_pecentiles(pv,m,28)
#results[29] = power_pecentiles(pv,m,29)
#results[30] = power_pecentiles(pv,m,30)
#results[31] = power_pecentiles(pv,m,31)
#results[32] = power_pecentiles(pv,m,32)
#results[33] = power_pecentiles(pv,m,33)
#results[34] = power_pecentiles(pv,m,34)
#results[35] = power_pecentiles(pv,m,35)
#results[36] = power_pecentiles(pv,m,36)
#results[37] = power_pecentiles(pv,m,37)
#results[38] = power_pecentiles(pv,m,38)
#results[39] = power_pecentiles(pv,m,39)
#results[40] = power_pecentiles(pv,m,40)
#results[41] = power_pecentiles(pv,m,41)
#results[42] = power_pecentiles(pv,m,42)
#results[43] = power_pecentiles(pv,m,43)
#results[44] = power_pecentiles(pv,m,44)
#results[45] = power_pecentiles(pv,m,45)
#results[46] = power_pecentiles(pv,m,46)
#results[47] = power_pecentiles(pv,m,47)
#results[48] = power_pecentiles(pv,m,48)
#results[49] = power_pecentiles(pv,m,49)


range_1 = 2
range_2 = 50

r_10 = Parallel(n_jobs=2)([delayed(power_pecentiles)(pv,m,i,10) for i in range(range_1,range_2)])
r_20= Parallel(n_jobs=2)([delayed(power_pecentiles)(pv,m,i,20) for i in range(range_1,range_2)])
r_30 = Parallel(n_jobs=2)([delayed(power_pecentiles)(pv,m,i,30) for i in range(range_1,range_2)])
r_40 =  Parallel(n_jobs=2)([delayed(power_pecentiles)(pv,m,i,40) for i in range(range_1,range_2)])
r_50 = Parallel(n_jobs=2)([delayed(power_pecentiles)(pv,m,i,50) for i in range(range_1,range_2)])
r_60  = Parallel(n_jobs=2)([delayed(power_pecentiles)(pv,m,i,60) for i in range(range_1,range_2)])
r_70 = Parallel(n_jobs=2)([delayed(power_pecentiles)(pv,m,i,70) for i in range(range_1,range_2)])
r_80 = Parallel(n_jobs=2)([delayed(power_pecentiles)(pv,m,i,80) for i in range(range_1,range_2)])
r_90 = Parallel(n_jobs=2)([delayed(power_pecentiles)(pv,m,i,90) for i in range(range_1,range_2)])

x = range(range_1,range_2)

plt.fill_between(x,r_10,y2=r_90,facecolor='black')
plt.fill_between(x,r_20,y2=r_80, facecolor='blue')
plt.fill_between(x,r_30,y2=r_70, facecolor='yellow' )
plt.fill_between(x,r_40,y2=r_60, facecolor='red')
plt.plot(x,r_50,color='black')

plt.savefig('percentiles.png')




#std_dev_results = Parallel(n_jobs=-2)([delayed(power_std_dev)(pv,length,m,i) for i in range(50)])
#exp_results = Parallel(n_jobs=-2)([delayed(power_exp)(length,pv,m,i) for i in range(50)])

#plt.plot(std_dev_results)
#plt.savefig('std_dev_results.png')

#plt.fill_between(x,[a-3*b for a,b in zip(exp_results,std_dev_results)],y2=[a+3*b for a,b in zip(exp_results,std_dev_results)])
#plt.fill_between(x,[a-2*b for a,b in zip(exp_results,std_dev_results)],y2=[a+2*b for a,b in zip(exp_results,std_dev_results)])
#plt.fill_between(x,[a-b for a,b in zip(exp_results,std_dev_results)],y2=[a+b for a,b in zip(exp_results,std_dev_results)])
#plt.plot(exp_results)
#plt.savefig('std_dev.png')
#
#
#dif_exp = [100*(exp_results[i] - exp_results[i-1])/exp_results[i-1] for i in range(2,50)]
#dif_std_dev =  [100*(std_dev_results[i] - std_dev_results[i-1])/exp_results[i-1] for i in range(2,50)]
#
#plt.subplot(121)
#plt.plot(range(2,50),dif_exp)
#plt.subplot(122)
#plt.plot(range(2,50), dif_std_dev)
#plt.savefig('std_dev_percent_change.png')

#results = Parallel(n_jobs=-2)([delayed(power_iqr)(pv,m,i) for i in range(50)])
#plt.plot([item[0] for item in results]) #25
#plt.plot([item[1] for item in results]) #50
#plt.plot([item[2] for item in results]) #75
#plt.xlabel('Moves')
#plt.ylabel('God\'s number')
#plt.savefig('iqr.png')
#results = Parallel(n_jobs=-2)([delayed(power_prob_heat)(pv,m,i) for i in range(50)])



#plt.plot([item[0] for item in results]) #med - std
#plt.plot([item[1] for item in results]) #med
#plt.plot([item[2] for item in results]) #med + std
#plt.ylim((0,14))
#plt.savefig('expected_value_w_std.png')


#ax = sns.heatmap(np.transpose(results),cmap="YlGnBu",yticklabels=False,annot=True,fmt="0.1f",annot_kws={"fontsize":2})
#plt.savefig('test.png',dpi=300)
