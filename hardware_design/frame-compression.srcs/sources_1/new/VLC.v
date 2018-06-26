`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/06/19 19:34:52
// Design Name: 
// Module Name: VLC
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


module VLC(
    clk,
    rst,
    DataEn,
    DataIn,
    DataOutEn,
    DataOut
);

    parameter W = 8;
    input clk, rst;
    input DataEn;
    input [W-1:0] DataIn;
    output DataOutEn;
    // 8*8*8 = 512
    output [511:0] DataOut;

    //reg
    reg [9:0] count;
    reg [511:0] DataOut;
    reg DataOutEn;

    //wire
    reg flag;
    wire [W-1:0] Abs;
    
    assign Abs = DataIn[W-1] ? ~DataIn+1 : DataIn;

    always@(posedge clk)
    begin
        if(rst == 1)
        begin
            DataOut <= 0;
            DataOutEn <= 0;
            count <= 0;
            flag <= 0;
        end
        else if(DataEn)
        begin
            flag <= 1;
            if(Abs == 0) //m = 0
            begin
                DataOut <= (DataOut << 1);
                count <= count + 1;
            end
            else if(Abs < 3) // m = 1
            begin
               DataOut <= (DataOut << 4) + 4'b1000 + DataIn[W-1] + ((Abs - 1) << 1);
               count <= count + 4;
            end
            else if(Abs < 7) // m = 2
            begin
                DataOut <= (DataOut << 6) + 6'b110000 + DataIn[W-1] + ((Abs - 3) << 1);
                count <= count + 6;
            end
            else if(Abs < 15) // m = 3
            begin
                DataOut <= (DataOut << 8) + 8'b11100000 + DataIn[W-1] + ((Abs - 7) << 1);
                count <= count + 8;
            end
            else if(Abs < 31) // m = 4
            begin
                DataOut <= (DataOut << 10) + 10'b1111000000 + DataIn[W-1] + ((Abs - 15) << 1);
                count <= count + 10;
            end
            else // m = 5
            begin 
                DataOut <= (DataOut << 12) + 12'b111110000000 + DataIn[W-1] + (((Abs > 62? 62:Abs) - 31) << 1);
                count <= count + 12;
            end
        end
        else if(flag == 1)
        begin
            DataOutEn <= 1;
            DataOut <= (DataOut << (512 - count));
            flag <= 0;
        end
        else if(DataOutEn && count >= 16)
        begin
            DataOut <= (DataOut << 16);
            count <= count - 16;
        end
        else if(DataOutEn && count < 16)
        begin
            DataOut <= (DataOut << 16);
            count <= 0;
            DataOutEn <= 0;
        end
    end


endmodule
