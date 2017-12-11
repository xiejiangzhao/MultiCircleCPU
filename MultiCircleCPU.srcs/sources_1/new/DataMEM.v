`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/12/10 16:42:09
// Design Name: 
// Module Name: DataMEM
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


module DataMEM(
    input [31:0] DAddr,
    input [31:0] DataIn,
    input RD,
    input WR,
    output [31:0] DataOut
    );
    reg [7:0] memory[0:63];
    reg [8:0] i;
    assign DataOut[31:24]=(RD==0)?memory[DAddr+3]:8'bz;
    assign DataOut[23:16] = (RD==0)?memory[DAddr + 2]:8'bz;
    assign DataOut[15:8] = (RD==0)?memory[DAddr + 1]:8'bz;
    assign DataOut[7:0] = (RD==0)?memory[DAddr ]:8'bz;
    always@(DAddr or DataIn or RD or WR)
        begin
            if(WR == 0)
                begin
                    memory[DAddr+3]<=DataIn[31:24];
                    memory[DAddr+2]<=DataIn[23:16];
                    memory[DAddr+1]<=DataIn[15:8];
                    memory[DAddr]<=DataIn[7:0];
                end
        end
endmodule
