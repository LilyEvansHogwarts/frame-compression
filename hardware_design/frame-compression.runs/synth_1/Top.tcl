# 
# Synthesis run script generated by Vivado
# 

set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
create_project -in_memory -part xc7vx485tffg1157-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir C:/Users/shzhang/Desktop/frame-compression/frame-compression.cache/wt [current_project]
set_property parent.project_path C:/Users/shzhang/Desktop/frame-compression/frame-compression.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
add_files -quiet C:/Users/shzhang/Desktop/frame-compression/frame-compression.srcs/sources_1/ip/Residual_BRAM/Residual_BRAM.dcp
set_property used_in_implementation false [get_files C:/Users/shzhang/Desktop/frame-compression/frame-compression.srcs/sources_1/ip/Residual_BRAM/Residual_BRAM.dcp]
read_verilog -library xil_defaultlib {
  C:/Users/shzhang/Desktop/frame-compression/frame-compression.srcs/sources_1/new/Intra_mode.v
  C:/Users/shzhang/Desktop/frame-compression/frame-compression.srcs/sources_1/new/VLC.v
  C:/Users/shzhang/Desktop/frame-compression/frame-compression.srcs/sources_1/new/TBT.v
  C:/Users/shzhang/Desktop/frame-compression/frame-compression.srcs/sources_1/new/IBP.v
  C:/Users/shzhang/Desktop/frame-compression/frame-compression.srcs/sources_1/new/Top.v
}
foreach dcp [get_files -quiet -all *.dcp] {
  set_property used_in_implementation false $dcp
}

synth_design -top Top -part xc7vx485tffg1157-1


write_checkpoint -force -noxdef Top.dcp

catch { report_utilization -file Top_utilization_synth.rpt -pb Top_utilization_synth.pb }
