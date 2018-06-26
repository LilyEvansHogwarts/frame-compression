`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/06/23 13:18:13
// Design Name: 
// Module Name: test
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


module test();

    parameter W = 8;
    reg clk,rst;
    reg DataEn;
    reg [W-1:0] DataIn;
    reg [2:0] intra_mode;
    reg flag1;
    reg [W-1:0] max1, max2, max3;
    reg [1:0] idx;
    reg flag;
    reg [4:0] Address;
    reg ReadEn;

    wire [W-1:0] TBTOut;
    wire TROut;
    wire TBTOutEn;
    wire IBPOutEn;
    wire [W-1:0] IBPOut1, IBPOut2, IBPOut3;
    wire VLCOutEn;
    wire [511:0] VLCOut1, VLCOut2, VLCOut3;
    wire [2*W-1:0] BramIn, DataOut;

    wire [W-1:0] tmp1, tmp2, tmp3;
    assign tmp1 = IBPOut1[W-1]? ~IBPOut1+1 : IBPOut1;
    assign tmp2 = IBPOut2[W-1]? ~IBPOut2+1 : IBPOut2;
    assign tmp3 = IBPOut3[W-1]? ~IBPOut3+1 : IBPOut3;

    wire [2:0] BP_mode;
    assign BP_mode = ((intra_mode == 0)||(intra_mode == 1))? (idx == 1? 4 : idx == 2? 5 : idx == 3? 7 : 0) : 
                     (intra_mode == 2)? (idx == 1? 0 : idx == 2? 4 : idx == 3? 5 : 0) : 
                     (intra_mode == 3)? (idx == 1? 0 : idx == 2? 2 : idx == 3? 6 : 0) : 
                     (intra_mode == 4)? (idx == 1? 1 : idx == 2? 5 : idx == 3? 6 : 0) : 
                     (intra_mode == 5)? (idx == 1? 1 : idx == 2? 3 : idx == 3? 4 : 0) : 0;

    assign BramIn = (idx == 1)? VLCOut1[511:496] : (idx == 2)? VLCOut2[511:496] : (idx == 3)? VLCOut3[511:496] : 0;

    initial
    begin
        clk <= 0;
        rst <= 0;
        intra_mode <= 0;
        ReadEn <= 0;
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
            flag1 <= 0;
            DataIn <= 126;
        end
        else if(DataIn == 156)
        begin
            DataIn <= DataIn - 3;
            flag1 <= 1;
        end
        else if(DataIn == 96)
        begin
            DataIn <= DataIn + 3;
            flag1 <= 0;
        end
        else if(flag1 == 0)
            DataIn <= DataIn + 3;
        else
            DataIn <= DataIn - 3;
    end

    always@(posedge clk)
    begin
        if(rst == 1)
        begin
            max1 <= 0;
            max2 <= 0;
            max3 <= 0;
            idx <= 0;
            flag <= 0; 
        end
        else if(IBPOutEn)
        begin
            flag <= 1;
            max1 <= (max1 > tmp1)? max1 : tmp1;
            max2 <= (max2 > tmp2)? max2 : tmp2;
            max3 <= (max3 > tmp3)? max3 : tmp3;
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


    always #2 clk = ~clk;

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

    Residual_BRAM b1(
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
