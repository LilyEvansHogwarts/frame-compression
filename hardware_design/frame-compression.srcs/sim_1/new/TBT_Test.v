`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/06/17 18:25:15
// Design Name: 
// Module Name: TBT_Test
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


module TBT_Test();

    parameter W = 8;
    reg clk, rst;
    reg DataEn;
    reg [W-1:0] DataIn;
    wire [W-1:0] DataOut;
    wire DataTR;
    wire DataOutEn;

    initial
    begin
        clk <= 0;
        rst <= 0;
        DataEn <= 0;
        #6 
        rst <= 1;
        #8
        rst <= 0;
        #8
        DataEn <= 1;
    end

    always @(posedge clk)
    begin
        if(rst == 1)
            DataIn <= 0;
        else
            DataIn <= DataIn + 3;
    end

    always #2 clk = ~clk;

    TBT utt(
        .clk(clk),
        .rst(rst),
        .DataEn(DataEn),
        .DataIn(DataIn),
        .DataOut(DataOut),
        .DataTR(DataTR),
        .DataOutEn(DataOutEn)
    );



endmodule
