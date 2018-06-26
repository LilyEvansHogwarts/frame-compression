onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+Residual_BRAM -L unisims_ver -L unimacro_ver -L secureip -L blk_mem_gen_v8_3_2 -L xil_defaultlib -O5 xil_defaultlib.Residual_BRAM xil_defaultlib.glbl

do {wave.do}

view wave
view structure
view signals

do {Residual_BRAM.udo}

run -all

endsim

quit -force
