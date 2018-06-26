from recompression import TBT
from pylab import *
from PIL import Image

# BP mode
mode0 = lambda r1,r2,r3,r4: r1
mode1 = lambda r1,r2,r3,r4: r3
mode2 = lambda r1,r2,r3,r4: (r1+r2)>>1
mode3 = lambda r1,r2,r3,r4: (r3+r4)>>1
mode4 = lambda r1,r2,r3,r4: (r1+r4)>>1
mode5 = lambda r1,r2,r3,r4: (r1+r3)>>1
mode6 = lambda r1,r2,r3,r4: (((r1+r2)>>1) + r3)>>1
mode7 = lambda r1,r2,r3,r4: (((r1+r2)>>1)+((r3+r4)>>1))>>1
ibp_mode = [mode0,mode1,mode2,mode3,mode4,mode5,mode6,mode7]
domain = [[4,5,7],[4,5,7],[0,4,5],[0,2,6],[1,5,6],[1,3,4]]

def TBT_decode(X, TR, l):
    n,m = X.shape
    new_X = np.array([[X[i,j]*(2**l) + TR[i,j] for j in range(m)] for i in range(n)])
    return new_X

def TBT(X, l):
    B = 2**l-1
    n, m = X.shape
    TR = np.array([[X[i,j] & B for j in range(m)] for i in range(n)])
    X = np.array([[X[i,j] >> l for j in range(m)] for i in range(n)])
    return X, TR

def IBP_decode(IP, BP_mode, res):
    X = zeros(res.shape, dtype=np.uint8)
    n,m = res.shape

    # IP
    X[0,0] = IP

    # BP
    for i in range(1,n):
        X[i,0] = X[i-1,0] + res[i,0]
    for i in range(1,m):
        X[0,i] = X[0,i-1] + res[0,i]

    # NP
    X = X.flatten()
    for i in range(1,n):
        for j in range(1,m):
            idx = i*m+j
            r1 = X[idx-1]
            r2 = X[idx-1-m]
            r3 = X[idx-m]
            r4 = X[idx-m+1]
            X[idx] = ibp_mode[BP_mode](r1,r2,r3,r4) + res[i,j]
    X = X.reshape(res.shape)
    return X


def PSNR(X,Y,l):
    MAX = 2**l-1
    delta = X-Y
    MSE = np.sum(delta * delta)/(X.shape[0]*X.shape[1]) + 1e-8
    log10 = lambda x:log(x)/log(10)
    return 10*log10(MAX**2/MSE)

def IBP(X, intra_mode, l, printall = False):
    n, m = X.shape
    res = np.zeros(X.shape,dtype=np.int8)

    # IP 
    IP = X[0,0]

    # BP
    for i in range(1,n):
        res[i,0] = X[i,0] - X[i-1,0]
    for i in range(1,m):
        res[0,i] = X[0,i] - X[0,i-1]

    # NP
    old_X = X[:,:]
    X = X.flatten()
    modelist = domain[intra_mode]
    predicts = zeros([len(modelist),n-1,m-1])
    BP_mode = None
    best_predict = None
    p = 0.0
    for k in range(len(modelist)):
        for i in range(1,n):
            for j in range(1,m):
                idx = i*m+j
                r1 = X[idx-1]
                r2 = X[idx-1-m]
                r3 = X[idx-m]
                r4 = X[idx-m+1]
                predicts[k,i-1,j-1] = ibp_mode[modelist[k]](r1,r2,r3,r4)
        if printall:
            print k
            print predicts[k]

        current = PSNR(old_X[1:,1:], predicts[k], l)
        if current > p:
            p = current
            best_predict = k
            BP_mode = modelist[k]
   
    res[1:,1:] = old_X[1:,1:] - predicts[best_predict]
    return IP, BP_mode, res
        






