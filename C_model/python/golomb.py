from mode_hardware_recompression import *
from pylab import *
from PIL import Image
import os

def count_VLC(X):
    bit_sum = 0
    for i in range(2):
        for j in range(2):
            tmp = abs(X[i*4:(i+1)*4,j*4:(j+1)*4])
            if tmp.max() == 1:
                bit_sum = bit_sum + 16 + sum(tmp == 1)
            elif tmp.max() == 2:
                bit_sum = bit_sum + 32 + sum(tmp == 2)
            elif tmp.max() <= 4:
                bit_sum = bit_sum + 32 + sum(tmp == 4)
            elif tmp.max() <= 8:
                bit_sum = bit_sum + 64 + sum(tmp == 8)
            elif tmp.max() <= 16:
                bit_sum = bit_sum + 80 + sum(tmp == 16)
            else:
                bit_sum = bit_sum + 80 + sum((tmp > 11) & (tmp < 16)) + 3*sum((tmp < 31) & (tmp > 15)) + 5*sum(tmp > 30)
    return bit_sum





# get image list
image_path = './data/'
imglist = [os.path.join(image_path,f) for f in os.listdir(image_path)]

domain = domain.append([0,1,2,3,4,5,6,7])

total_mode = []
distr = [] # document the residual distribution

bit_consume = []
for f in imglist:
    print f
    current_distr = zeros(33)
    im = array(Image.open(f).convert('L'))
    n, m = im.shape
    print im.shape
    n = n/8
    m = m/8
    im = im[:n*8,:m*8]
    print im.shape
  
    num_bit = 0.0
    num_mode = zeros(8)
    # compress the original image
    res = zeros(im.shape,dtype=np.int8)
    for i in range(n):
        for j in range(m):
            X = im[i*8:(i+1)*8,j*8:(j+1)*8]
            X, TR = TBT(X,1)
            IP, BP_mode, tmp = IBP(X,6,7)
            res[i*8:(i+1)*8,j*8:(j+1)*8] = tmp
            num_mode[BP_mode] = num_mode[BP_mode] + 1
            if sum(abs(tmp)>32):
                print IP, BP_mode, i,j
                print tmp
            num_bit = num_bit + count_VLC(tmp)
    bit_consume.append(num_bit)
    print num_bit
    print num_mode
    total_mode.append(num_mode)
    # get distribution
    current_distr = []
    for i in range(1,33):
        current_distr.append(sum(abs(res)<i))
    current_distr.append(res.shape[0]*res.shape[1])
    print res.shape
    print current_distr
    distr.append(current_distr)
save('distribution_mode_hardware.npy',distr)
save('num_mode.npy',total_mode)
save('bit_consume.npy',bit_consume)

# plot the distribution
x_value = range(33)
for f in distr:
    plot(x_value, f)
show()

# plot the mode distribution
x_value = range(8)
for f in total_mode:
    plot(x_value,f)
show()





