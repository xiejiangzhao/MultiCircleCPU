`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/12/10 11:39:53
// Design Name: 
// Module Name: PC
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


module PC(
    input CLK,
    input RST,
    input PCWre,
    input [31:0] PC_Next,
    output reg [31:0] PC_Now
    );
    always@(posedge CLK)
            begin
                if(RST == 0)
                    begin
                        PC_Now <= 0;
                    end
                else
                    begin
                        if(PCWre != 0)
                            begin
                                  PC_Now <= PC_Next;
                            end     
                    end
            end
        initial
            begin
                PC_Now = 0;
            end
endmodule
