`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/06/18 22:15:18
// Design Name: 
// Module Name: Intra_mode_Test
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


module Intra_mode_Test();

    parameter W = 8;
    reg clk, rst;
    reg [2:0] intra_mode;
    reg DataEn;
    reg [W-1:0] DataIn1, DataIn2, DataIn3, DataIn4;
    wire DataOutEn;
    wire [W-1:0] DataOut1, DataOut2, DataOut3;

    initial
    begin
        clk <= 0;
        rst <= 0;
        intra_mode <= 0;
        # 6
        rst <= 1;
        # 8
        rst <= 0;
        # 4
        DataEn <= 1;
        # 50
        intra_mode <= 1;
        # 50
        intra_mode <= 2;
        # 50 
        intra_mode <= 3;
        # 50
        intra_mode <= 4;
        # 50
        intra_mode <= 5;
    end

    always @(posedge clk)
    begin
        if(rst == 1)
        begin
            DataIn1 <= 0;
            DataIn2 <= 0;
            DataIn3 <= 0;
            DataIn4 <= 0;
        end
        else 
        begin
            DataIn1 <= DataIn1 + 3;
            DataIn2 <= DataIn2 + 4;
            DataIn3 <= DataIn3 + 5;
            DataIn4 <= DataIn4 + 6;
        end
    end
    
always #2 clk = ~clk;

    Intra_mode uut(
        .clk(clk),
        .rst(rst),
        .intra_mode(intra_mode),
        .DataEn(DataEn),
        .DataIn1(DataIn1),
        .DataIn2(DataIn2),
        .DataIn3(DataIn3),
        .DataIn4(DataIn4),
        .DataOutEn(DataOutEn),
        .DataOut1(DataOut1),
        .DataOut2(DataOut2),
        .DataOut3(DataOut3)
    );


endmodule
