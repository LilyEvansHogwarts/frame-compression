`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/06/19 20:37:59
// Design Name: 
// Module Name: VLC_Test
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


module VLC_Test();
    
    parameter W = 8;
    reg clk, rst;
    reg DataEn;
    reg [W-1:0] DataIn;
    wire DataOutEn;
    wire [511:0] DataOut;
    
    reg flag;

    reg [4:0] Address;
    wire [15:0] Out;
    reg ReadEn;

    initial
    begin
        clk <= 0;
        rst <= 0;
        ReadEn <= 0;
        # 6
        rst <= 1;
        # 8
        rst <= 0;
        # 4
        DataEn <= 1;
        # 192
        DataEn <= 0;
        # 128
        ReadEn <= 1;
        # 104
        ReadEn <= 0;
    end


    always@(posedge clk)
    begin
        if(rst == 1)
        begin
            DataIn <= 220;
            flag <= 0;
        end
        else if(DataIn == 36)
        begin
            flag <= 1;
            DataIn <= DataIn - 3;
        end
        else if(DataIn == 220)
        begin
            flag <= 0;
            DataIn <= DataIn + 3;
        end
        else if(flag == 0)
            DataIn <= DataIn + 3;
        else 
            DataIn <= DataIn - 3;
    end

    always #2 clk = ~clk;

    VLC uut(
        .clk(clk),
        .rst(rst),
        .DataEn(DataEn),
        .DataIn(DataIn),
        .DataOutEn(DataOutEn),
        .DataOut(DataOut)
    );

    Residual_BRAM t1(
        .clka(clk),
        .ena(DataOutEn | ReadEn),
        .wea(DataOutEn),
        .dina(DataOut[511:496]),
        .addra(Address),
        .douta(Out)
    );
    
    always @(posedge clk)
    begin
        if(DataOutEn | ReadEn)
            Address <= Address + 1;
        else
            Address <= 0;
    end



endmodule
