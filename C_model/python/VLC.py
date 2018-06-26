import numpy as np

def binary(n,l):
    r = ''
    while n>0:
        if n&1: r = '1'+r
        else: r = '0'+r
        n = n>>1
    r = '0'*(l-len(r))+r
    return r



def debinary(tmp):
    n = 0
    for f in tmp:
        if f == '0':
            n = n*2
        else:
            n = n*2 + 1
    return n

def VLC(X):
    num_max = abs(X).max()
    l = 0
    while num_max > 2**l:
        l = l+1
    # table_num
    if num_max == 0:
        table_num = 0
    elif num_max == 1:
        table_num = 1
    else: table_num = l+1

    n,m = X.shape
    B = 2**l
    with open('codebook.txt','w') as f:
        for i in range(n):
            for j in range(m):
                if abs(X[i,j]) < B:
                    tmp = binary(abs(X[i,j]),l)
                else: tmp = '0'*(l+1)
                if X[i,j]>0:
                    tmp = tmp+'0'
                else: tmp = tmp+'1'
                f.write(tmp)
    return table_num

X = np.array([[np.random.randint(0,33)-16 for i in range(8)] for j in range(8)])
num_max = abs(X).max()
n, m = X.shape
print X
print num_max

table_num = VLC(X)
l = table_num - 1
B = 2**l

with open('codebook.txt','r') as f:
    Y = np.zeros([n,m],dtype=np.int8)
    for i in range(n):
        for j in range(m):
            tmp = f.read(l+1)
            if tmp == '0'*(l+1):
                if f.read(1) == '0':
                    Y[i,j] = int(B)
                else: 
                    Y[i,j] = -int(B)
            elif tmp == '0'*l+'1':
                Y[i,j] = 0
            else:
                if tmp[l] == '0':
                    Y[i,j] = debinary(tmp[:l])
                else:
                    Y[i,j] = -debinary(tmp[:l])
    print Y


