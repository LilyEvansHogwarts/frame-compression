`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/06/20 00:26:05
// Design Name: 
// Module Name: Top_Test
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


module Top_Test();

    parameter W = 8;
    reg clk, rst;
    reg [2:0] intra_mode;
    reg ReadEn;
    reg DataEn;
    reg [W-1:0] DataIn;
    wire TROut;
    wire [2:0] BP_mode;
    wire [2*W-1:0] DataOut;
    //wire [2*W-1:0] Bram_Out1, Bram_Out2, Bram_Out3;
    //wire [1:0] idx;
    //wire [511:0] VLCOut1, VLCOut2, VLCOut3;
    //wire VLCOutEn1, VLCOutEn2, VLCOutEn3;
    //wire [W-1:0] IBPOut1, IBPOut2, IBPOut3;
    //wire IBPOutEn;
    //wire [4:0] Address;
    
    reg flag;

    initial
    begin
        clk <= 0;
        rst <= 0;
        ReadEn <= 0;
        intra_mode <= 0;
        # 6
        rst <= 1;
        # 8 
        rst <= 0;
        # 4
        DataEn <= 1;
        # 128
        DataEn <= 0;
        # 128
        ReadEn <= 1;
        # 88
        ReadEn <= 0;
    end



    always @(posedge clk)
    begin
        if(rst == 1)
        begin
            DataIn <= 126;
            flag <= 0;
        end
        else if(DataIn == 156)
        begin
            flag <= 1;
            DataIn <= DataIn - 3;
        end
        else if(DataIn == 96)
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

    Top uut(
        .clk(clk),
        .rst(rst),
        .intra_mode(intra_mode),
        .ReadEn(ReadEn),
        .DataEn(DataEn),
        .DataIn(DataIn),
        .TROut(TROut),
        .DataOut(DataOut),
        .BP_mode(BP_mode)
        );
        


endmodule
