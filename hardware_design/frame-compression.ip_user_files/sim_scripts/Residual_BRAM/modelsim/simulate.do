onbreak {quit -f}
onerror {quit -f}

vsim -voptargs="+acc" -t 1ps -L unisims_ver -L unimacro_ver -L secureip -L blk_mem_gen_v8_3_2 -L xil_defaultlib -lib xil_defaultlib xil_defaultlib.Residual_BRAM xil_defaultlib.glbl

do {wave.do}

view wave
view structure
view signals

do {Residual_BRAM.udo}

run -all

quit -force
