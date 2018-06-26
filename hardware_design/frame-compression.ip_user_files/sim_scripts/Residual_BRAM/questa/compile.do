vlib work
vlib msim

vlib msim/blk_mem_gen_v8_3_2
vlib msim/xil_defaultlib

vmap blk_mem_gen_v8_3_2 msim/blk_mem_gen_v8_3_2
vmap xil_defaultlib msim/xil_defaultlib

vlog -work blk_mem_gen_v8_3_2 -64 \
"../../../ipstatic/blk_mem_gen_v8_3_2/simulation/blk_mem_gen_v8_3.v" \

vlog -work xil_defaultlib -64 \
"../../../../frame-compression.srcs/sources_1/ip/Residual_BRAM/sim/Residual_BRAM.v" \


vlog -work xil_defaultlib "glbl.v"

