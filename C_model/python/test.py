from hardware_recompression import *
from pylab import *
from PIL import Image
import os

imglist = [f.split('.')[0] for f in os.listdir('./data/')]

d1 = load('distribution.npy')
d2 = load('distribution_hardware.npy')
d3 = load('distribution_mode_hardware.npy')
x = range(33)


delta1 = (d2 - d1).mean(axis=0)
delta2 = (d3 - d1).mean(axis=0)
plot(x,delta1)
plot(x,delta2)
title('improvements based on PSNR')
legend(['hardware+PSNR','hardware+max'],loc='upper right',fontsize=10)
show()



d1 = d1*1.0
for f in d1:
    f = f/f[-1]
    plot(x,f)
title('absolute residual distribution(PSNR)')
legend(imglist,loc='lower right',fontsize=8)
show()
d2 = d2*1.0
for f in d2:
    f = f/f[-1]
    plot(x,f)
title('absolute residual distribution(hardware+PSNR)')
legend(imglist,loc='lower right',fontsize=8)
show()

d3 = d3*1.0
for f in d3:
    f = f/f[-1]
    plot(x,f)
title('absolute residual distribution(hardware+max)')
legend(imglist,loc='lower right',fontsize=8)
show()

num_mode = load('num_mode.npy')
num_mode = 1.0*num_mode
for f in num_mode:
    f = f/sum(f)
    plot(range(8),f)
title('mode distribution')
legend(imglist,loc='Best',fontsize=8)
show()





