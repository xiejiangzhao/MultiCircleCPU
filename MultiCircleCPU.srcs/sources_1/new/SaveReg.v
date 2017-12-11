`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/12/10 20:16:30
// Design Name: 
// Module Name: SaveReg
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


module SaveReg(
    input CLK,
    input [31:0] DataIn,
    output reg[31:0] DataOut
    );
    always@(posedge CLK)
        begin
          DataOut=DataIn;
        end
endmodule
