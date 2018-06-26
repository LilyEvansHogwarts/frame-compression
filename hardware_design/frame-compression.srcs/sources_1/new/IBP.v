`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/06/17 19:01:05
// Design Name: 
// Module Name: IBP
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


module IBP(
    clk,
    rst,
    intra_mode,
    DataEn,
    DataIn,
    DataOutEn,
    DataOut1,
    DataOut2,
    DataOut3
    );
    
    //Length means the length of the block
    parameter W = 8, Length = 9; 
    //each row has 8 elements. Thus, the shiftregister requires 9 registers.
    input clk, rst, DataEn;
    input [W-1:0] DataIn;
    input [2:0] intra_mode;
    output [W-1:0] DataOut1, DataOut2, DataOut3;
    // output [W-1:0] IntraOut1, IntraOut2, IntraOut3;
    output reg DataOutEn;
    // output [W-1:0] BP_res1, BP_res2, NP_res1, NP_res2, NP_res3;

    //register
    wire OutEn;
    reg [W-1:0] Mem[Length-1:0];
    wire [W-1:0] intraOut1, intraOut2, intraOut3;

    //wire
    wire [W-1:0] Out1, Out2, Out3, Out4;
    
    assign Out1 = DataEn ? Mem[0] : 0;
    assign Out2 = DataEn ? Mem[Length-1] : 0;
    assign Out3 = DataEn ? Mem[Length-2] : 0;
    assign Out4 = DataEn ? Mem[Length-3] : 0;
    
    // residual
    wire [W-1:0] BP_res1, BP_res2, NP_res1, NP_res2, NP_res3;

    assign BP_res1 = DataOutEn ? Mem[0] - Mem[Length-1] : 0;
    assign BP_res2 = DataOutEn ? Mem[0] - Mem[1] : 0;
    assign NP_res1 = DataOutEn ? Mem[0] - IntraOut1 : 0;
    assign NP_res2 = DataOutEn ? Mem[0] - IntraOut2 : 0;
    assign NP_res3 = DataOutEn ? Mem[0] - IntraOut3 : 0;
    
    always@(posedge clk)
    begin
        DataOutEn <= DataEn;
        if(rst == 1)
        begin
            DataOutEn <= 0;
            Mem[0] <= 0;
        end
        else if(DataEn)
        begin
            Mem[0] <= DataIn;
        end
    end
    
    // shiftregister
    genvar i;
    generate
        for(i = 1;i < Length;i = i+1)
        begin: reset
            always@(posedge clk)
            begin
                if(rst == 1)
                    Mem[i] <= 0;
                else if(DataEn == 1)
                    Mem[i] <= Mem[i-1];
            end
        end
    endgenerate


    Intra_mode uut(
        .clk(clk),
        .rst(rst),
        .intra_mode(intra_mode),
        .DataEn(DataOutEn),
        .DataIn1(Out1),
        .DataIn2(Out2),
        .DataIn3(Out3),
        .DataIn4(Out4),
        .DataOutEn(OutEn),
        .DataOut1(IntraOut1),
        .DataOut2(IntraOut2),
        .DataOut3(IntraOut3)
    );

    // residual coordinate
    reg [W-1:0] col, row;

    always@(posedge clk)
    begin
        if(rst == 1)
        begin
            col <= 0;
            row <= 0;
        end
        else if(DataOutEn)
        begin
            if(col == 7)
            begin
                col <= 0;
                row <= row + 1;
            end
            else
                col <= col + 1;
        end
    end

    assign DataOut1 = (row == 0 && col == 0)? Mem[0] : row == 0? BP_res2 : col == 0? BP_res1 : NP_res1;
    assign DataOut2 = (row == 0 && col == 0)? Mem[0] : row == 0? BP_res2 : col == 0? BP_res1 : NP_res2;
    assign DataOut3 = (row == 0 && col == 0)? Mem[0] : row == 0? BP_res2 : col == 0? BP_res1 : NP_res3;

endmodule
