@echo off
set xv_path=C:\\Xilinx\\Vivado\\2016.1\\bin
call %xv_path%/xsim Top_Test_behav -key {Behavioral:sim_1:Functional:Top_Test} -tclbatch Top_Test.tcl -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
