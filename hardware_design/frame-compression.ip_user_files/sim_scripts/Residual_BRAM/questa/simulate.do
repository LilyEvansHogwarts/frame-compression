onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib Residual_BRAM_opt

do {wave.do}

view wave
view structure
view signals

do {Residual_BRAM.udo}

run -all

quit -force
