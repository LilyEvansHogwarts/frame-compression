`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/06/20 01:34:03
// Design Name: 
// Module Name: BRAM_Test
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


module BRAM_Test();

    parameter W = 8;
    reg clk, rst;
    reg WriteEn, ReadEn;
    reg [W-1:0] DataIn;
    wire [W-1:0] DataOut;
    reg [4:0] Address;

    always #2 clk = ~clk;

    always@(posedge clk)
    begin
        DataIn <= DataIn + 1;
        if(WriteEn | ReadEn)
            Address <= Address + 1;
        else
            Address <= 0;
    end

    initial
    begin
        clk <= 0;
        WriteEn <= 0;
        ReadEn <= 0;
        Address <= 0;
        DataIn <= 0;
        # 6
        WriteEn <= 1;
        # 128
        WriteEn <= 0;
        # 12
        ReadEn <= 1;
        # 128
        ReadEn <= 0;
    end




    Residual_BRAM uut(
        .clka(clk),
        .ena(WriteEn | ReadEn),
        .wea(WriteEn),
        .dina(DataIn),
        .douta(DataOut),
        .addra(Address)
    );



endmodule
