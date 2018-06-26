import os
from PIL import Image
from pylab import *
from math import log

distr = load('distribution_mode_hardware.npy')

# diff
tmp_distr = []
for f in distr:
    tmp = [f[0]]
    for j in range(1,len(f)):
        tmp.append(f[j]-f[j-1])
    tmp_distr.append(tmp)

distr = array(tmp_distr)

# percent
distr = 1.0*distr

s = distr.sum(axis=1)
for i in range(distr.shape[0]):
    distr[i] = distr[i]/s[i]

# theoretical best
log2 = lambda x:log(x)/log(2)
entro = []
for f in distr:
    tmp = 0.0
    for i in f:
        tmp = tmp - i*log2(i)
    entro.append(tmp)
entro = array(entro)
print entro
print entro/8
scatter(range(18),entro/8)

# exp-golomb
golomb = []
code = array([2*floor(log2(i+1))+2 for i in range(33)])
code[0] = 1
for f in distr:
    golomb.append(dot(f,code))
print golomb

golomb = array(golomb)
print golomb/8
scatter(range(18),golomb/8)

VLC = load('VLC_bit.npy')
scatter(range(18),VLC/8)


legend(['theoretical best','exp-golomb','VLC'],loc='upper right',fontsize=8)
title('compression ratio')
show()
