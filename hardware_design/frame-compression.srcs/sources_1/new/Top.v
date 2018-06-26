`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/06/20 00:07:22
// Design Name: 
// Module Name: Top
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


module Top(
    clk,
    rst,
    intra_mode,
    ReadEn,
    DataEn,
    DataIn,
    TROut,
    DataOut,
    BP_mode
    );

    parameter W = 8;
    input clk, rst;
    input DataEn;
    input [W-1:0] DataIn;
    input [2:0] intra_mode;
    input ReadEn;
    output TROut;
    output [2:0] BP_mode;
    output [2*W-1:0] DataOut;
    //output [2*W-1:0] Bram_Out1, Bram_Out2, Bram_Out3;
    //output [1:0] idx;
 //   output [511:0] VLCOut1, VLCOut2, VLCOut3;
 //   output VLCOutEn1, VLCOutEn2, VLCOutEn3;
    //output [W-1:0] IBPOut1, IBPOut2, IBPOut3;
    //output IBPOutEn;
   // output [4:0] Address;
 
    //wire
    wire [W-1:0] TBTOut;
    wire TBTOutEn;
    wire IBPOutEn;
    wire [W-1:0] IBPOut1, IBPOut2, IBPOut3;
    wire [2:0] BP_mode;
    wire [511:0] VLCOut1, VLCOut2, VLCOut3;
    wire VLCOutEn;
    wire [2*W-1:0] BramIn;

    //register
    reg [W-1:0] max1, max2, max3;
    reg [1:0] idx;
    reg flag;
    reg [4:0] Address;

    wire [W-1:0] tmp1, tmp2 , tmp3;
    assign tmp1 = IBPOut1[W-1] ? ~IBPOut1+1 : IBPOut1;
    assign tmp2 = IBPOut2[W-1] ? ~IBPOut2+1 : IBPOut2;
    assign tmp3 = IBPOut3[W-1] ? ~IBPOut3+1 : IBPOut3;
    assign BP_mode = ((intra_mode == 0)||(intra_mode == 1))? (idx == 1? 4 : idx == 2? 5 : idx == 3? 7 : 0) : 
                     (intra_mode == 2)? (idx == 1? 0 : idx == 2? 4 : idx == 3? 5 : 0) : 
                     (intra_mode == 3)? (idx == 1? 0 : idx == 2? 2 : idx == 3? 6 : 0) : 
                     (intra_mode == 4)? (idx == 1? 1 : idx == 2? 5 : idx == 3? 6 : 0) : 
                     (intra_mode == 5)? (idx == 1? 1 : idx == 2? 3 : idx == 3? 4 : 0) : 0;

    always @(posedge clk)
    begin
        if(rst == 1)
        begin
            max1 <= 0;
            max2 <= 0;
            max3 <= 0;
            flag <= 0;
            idx <= 0;
        end
        else if(IBPOutEn)
        begin
            flag <= 1;
            max1 <= (max1 > tmp1) ? max1 : tmp1;
            max2 <= (max2 > tmp2) ? max2 : tmp2;
            max3 <= (max3 > tmp3) ? max3 : tmp3;
        end
        else if(flag == 1)
        begin
            flag <= 0;
            if((max1 <= max2) && (max1 <= max3))
                idx <= 1;
            else if((max2 <= max1) && (max2 <= max3))
                idx <= 2;
            else 
                idx <= 3;
        end
    end





    TBT t1(
        .clk(clk),
        .rst(rst),
        .DataEn(DataEn),
        .DataIn(DataIn),
        .DataOut(TBTOut),
        .DataTR(TROut),
        .DataOutEn(TBTOutEn)
    );

    IBP t2(
        .clk(clk),
        .rst(rst),
        .intra_mode(intra_mode),
        .DataEn(TBTOutEn),
        .DataIn(TBTOut),
        .DataOutEn(IBPOutEn),
        .DataOut1(IBPOut1),
        .DataOut2(IBPOut2),
        .DataOut3(IBPOut3)
    );

    VLC t3(
        .clk(clk),
        .rst(rst),
        .DataEn(IBPOutEn),
        .DataIn(IBPOut1),
        .DataOutEn(VLCOutEn),
        .DataOut(VLCOut1)
    );
    
    VLC t4(
        .clk(clk),
        .rst(rst),
        .DataEn(IBPOutEn),
        .DataIn(IBPOut2),
        .DataOutEn(),
        .DataOut(VLCOut2)
    );

    VLC t5(
        .clk(clk),
        .rst(rst),
        .DataEn(IBPOutEn),
        .DataIn(IBPOut3),
        .DataOutEn(),
        .DataOut(VLCOut3)
    );
    
    Residual_BRAM b(
        .clka(clk),
        .addra(Address),
        .ena(VLCOutEn | ReadEn),
        .wea(VLCOutEn),
        .dina(BramIn),
        .douta(DataOut)
    );

    always@(posedge clk)
    begin
        if(VLCOutEn | ReadEn)
            Address <= Address + 1;
        else
            Address <= 0;
    end

    assign BramIn = (idx == 1)? VLCOut1[511:496] : (idx == 2)? VLCOut2[511:496] : (idx == 3)? VLCOut3[511:496] : 0;




endmodule
