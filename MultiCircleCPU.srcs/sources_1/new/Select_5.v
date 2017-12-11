`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/12/10 16:46:33
// Design Name: 
// Module Name: Select_5
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


module Select_5(
    input Opt,
    input[4:0] DataA,
    input[4:0] DataB,
    output[4:0] DataC
    );
    assign DataC = (Opt == 1'b0 ? DataA : DataB);
endmodule
