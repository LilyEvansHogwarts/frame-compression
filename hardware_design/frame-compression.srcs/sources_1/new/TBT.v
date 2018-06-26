`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/06/17 18:14:29
// Design Name: 
// Module Name: TBT
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module TBT(
    clk,
    rst,
    DataEn,
    DataIn,
    DataOut,
    DataTR,
    DataOutEn
    );

    // set truncated length as 1
    parameter W = 8, l = 1;
    input clk, rst, DataEn;
    input [W-1:0] DataIn;
    output [W-1:0] DataOut;
    output DataTR;
    output DataOutEn;

    //register
    reg [W-1:0] DataOut;
    reg DataTR;
    reg DataOutEn;

    always @(posedge clk)
    begin
        if(rst == 1)
        begin
            DataTR <= 0;
            DataOut <= 0;
            DataOutEn <= 0;
        end
        else if(DataEn == 1)
        begin
            DataOut <= DataIn >> 1;
            DataTR <= DataIn & 1;
        end
        DataOutEn <= DataEn;
    end


endmodule
