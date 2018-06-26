`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/06/18 19:26:08
// Design Name: 
// Module Name: Intra_mode
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


module Intra_mode(
    clk,
    rst,
    intra_mode,
    DataEn,
    DataIn1,
    DataIn2,
    DataIn3,
    DataIn4,
    DataOutEn,
    DataOut1,
    DataOut2,
    DataOut3
    );

    parameter W = 8;
    input clk, rst;
    input [2:0] intra_mode;
    input DataEn;
    input [W-1:0] DataIn1, DataIn2, DataIn3, DataIn4;
    output DataOutEn;
    output [W-1:0] DataOut1, DataOut2, DataOut3;

    //register
    reg [W-1:0] DataOut1, DataOut2, DataOut3;
    reg DataOutEn;
    
    //wire
    wire [W-1:0] mode0, mode1, mode2, mode3, mode4, mode5, mode6, mode7;

    assign mode0 = DataIn1;
    assign mode1 = DataIn3;
    assign mode2 = (DataIn1+DataIn2)>>1;
    assign mode3 = (DataIn3+DataIn4)>>1;
    assign mode4 = (DataIn1+DataIn4)>>1;
    assign mode5 = (DataIn1+DataIn3)>>1;
    assign mode6 = (((DataIn1+DataIn2)>>1) + DataIn3)>>1;
    assign mode7 = (((DataIn1+DataIn2)>>1) + ((DataIn3+DataIn4)>>1))>>1;

    always@(posedge clk)
    begin
        DataOutEn <= DataEn;
        if(rst == 1)
        begin
            DataOutEn <= 0;
            DataOut1 <= 0;
            DataOut2 <= 0;
            DataOut3 <= 0;
        end
        else if(DataEn)
        begin
            case(intra_mode)
                0: begin
                       DataOut1 <= mode4;
                       DataOut2 <= mode5;
                       DataOut3 <= mode7;
                   end
                1: begin
                       DataOut1 <= mode4;
                       DataOut2 <= mode5;
                       DataOut3 <= mode7;
                   end
                2: begin
                       DataOut1 <= mode0;
                       DataOut2 <= mode4;
                       DataOut3 <= mode5;
                   end
                3: begin
                       DataOut1 <= mode0;
                       DataOut2 <= mode2;
                       DataOut3 <= mode6;
                   end
                4: begin 
                       DataOut1 <= mode1;
                       DataOut2 <= mode5;
                       DataOut3 <= mode6;
                   end
                5: begin 
                       DataOut1 <= mode1;
                       DataOut2 <= mode3;
                       DataOut3 <= mode4;
                   end
                default:
                   begin 
                       DataOut1 <= mode4;
                       DataOut2 <= mode5;
                       DataOut3 <= mode7;
                   end
            endcase
        end
    end


endmodule
