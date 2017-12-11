`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/12/10 16:44:29
// Design Name: 
// Module Name: Extend
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


module Extend(
    input ExtSel,
    input [15:0] Data,
    output reg [31:0]  result
    );
    always@(ExtSel or Data)
        begin
            if(ExtSel==0||Data[15]==0)
                begin
                    result<={16'h0,Data};
                end
            else
                begin
                   result<={16'hFFFF,Data};
                end
        end
    initial
        begin
            result=0;
        end
endmodule
