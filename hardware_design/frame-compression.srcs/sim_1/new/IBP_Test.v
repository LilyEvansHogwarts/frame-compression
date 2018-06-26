`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/06/17 19:18:39
// Design Name: 
// Module Name: IBP_Test
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


module IBP_Test();

    parameter W = 8;
    reg clk, rst, DataEn;
    reg [2:0] intra_mode;
    reg [W-1:0] DataIn;
    wire DataOutEn;
    wire [W-1:0] DataOut1, DataOut2, DataOut3;
    // wire [W-1:0] BP_res1, BP_res2, NP_res1, NP_res2, NP_res3;
    // wire [W-1:0] IntraOut1, IntraOut2, IntraOut3;

    always #2 clk = ~clk;

    initial
    begin
        clk <= 0;
        rst <= 0;
        DataEn <= 0;
        intra_mode <= 0;
        #6
        rst <= 1;
        #8
        rst <= 0;
        #4
        DataEn <= 1;
        # 52
        intra_mode <= 1;
        # 52
        intra_mode <= 2;
        # 52
        intra_mode <= 3;
        # 52
        intra_mode <= 4;
        # 52
        intra_mode <= 5;
        # 52 
        intra_mode <= 0;
        # 52
        DataEn <= 0;
    end

    always@(posedge clk)
    begin
        if(rst == 1)
            DataIn <= 0;
        else if(DataIn < 128)
            DataIn <= DataIn + 3;
        else 
            DataIn <= 1;
    end



    IBP uut(
        .clk(clk),
        .rst(rst),
        .intra_mode(intra_mode),
        .DataEn(DataEn),
        .DataIn(DataIn),
        .DataOutEn(DataOutEn),
        .DataOut1(DataOut1),
        .DataOut2(DataOut2),
        .DataOut3(DataOut3)
    );


endmodule
