`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/12/11 08:29:00
// Design Name: 
// Module Name: ControlUnit
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


module ControlUnit(
    input CLK,
    input RST,
    input [5:0] command,
    input zero,
    input sign,
    output reg RegDst,//rt rd
    output reg InsMemRW,//read write
    output reg PCWre,//bugai gai
    output reg ExtSel,//0 sign
    output reg DBDataSrc,//alu lw
    output reg WR,//write
    output reg ALUSrcB,
    output reg ALUSrcA,
    output reg [1:0] PCSrc,
    output reg [2:0] ALUOp,
    output reg RegWre,
    output reg RD 
    );
endmodule
