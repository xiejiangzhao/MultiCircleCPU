`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/12/10 15:53:32
// Design Name: 
// Module Name: IR
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


module IR(
    input CLK,
    input IRWre,
    input[31:0] DataIn,
    output reg[31:0] DataOut
    );
    always@(posedge CLK)
        begin
            if(IRWre!=0)
                begin
                    DataOut<=DataIn;
                end
        end
endmodule
