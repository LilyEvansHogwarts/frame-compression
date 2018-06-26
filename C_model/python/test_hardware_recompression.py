from hardware_recompression import *
from PIL import Image
from pylab import *
from scipy import misc
import os
'''
im = array(Image.open('empire.jpg').convert('L'))
misc.toimage(im, cmin=0, cmax=255).save('gray_empire.jpg')
n, m = im.shape

new_im = zeros([n,m])
for i in range(n/8):
    for j in range(m/8):
        X = im[i*8:(i+1)*8, j*8:(j+1)*8]
        X, TR = TBT(X, 1)
        IP, BP_mode, res = IBP(X, 0, 7)
        X = IBP_decode(IP, BP_mode, res)
        X = TBT_decode(X, TR, 1)
        new_im[i*8:(i+1)*8, j*8:(j+1)*8] = X

misc.toimage(new_im, cmin=0, cmax=255).save('new_empire.jpg')

im = array(Image.open('empire.jpg').convert('L'))
'''
# get image list
image_path = './data/'
imglist = [os.path.join(image_path,f) for f in os.listdir(image_path)]


distr = [] # document the residual distribution
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

    # compress the original image
    res = zeros(im.shape,dtype=np.int8)
    for i in range(n):
        for j in range(m):
            X = im[i*8:(i+1)*8,j*8:(j+1)*8]
            X, TR = TBT(X,1)
            best_tmp = None
            best = 255
            for l in [0,2,3,4,5]:
                IP, BP_mode, tmp = IBP(X,l,7)
                if abs(tmp).max() < best:
                    best = abs(tmp).max()
                    best_tmp = tmp
            res[i*8:(i+1)*8,j*8:(j+1)*8] = best_tmp
            if sum(abs(best_tmp)>32):
                print IP, BP_mode, i,j
                print best_tmp
    
    # get distribution
    current_distr = []
    for i in range(1,33):
        current_distr.append(sum(abs(res)<i))
    current_distr.append(res.shape[0]*res.shape[1])
    print res.shape
    print current_distr
    distr.append(current_distr)
save('distribution_hardware.npy',distr)

# plot the distribution
x_value = range(33)
for f in distr:
    plot(x_value, f)
show()

