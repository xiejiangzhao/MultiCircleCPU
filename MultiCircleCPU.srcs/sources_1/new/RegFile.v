`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/12/10 16:34:09
// Design Name: 
// Module Name: RegFile
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


module RegFile(
    input CLK,
    input RST,
    input RegWre,
    input [4:0] RegRed1,
    input [4:0] RegRed2,
    input [4:0] WreReg,
    input [31:0] WreData,
    output [31:0] DataRed1,
    output [31:0] DataRed2
    );
    reg [31:0] register[0:31];
    reg [5:0] i;
    assign DataRed1=(register[RegRed1]==0)?0:register[RegRed1];
    assign DataRed2=(register[RegRed2]==0)?0:register[RegRed2];
    always@(negedge CLK or negedge RST)
        begin
            if (RST==0) 
                begin
                    for(i=0;i<32;i=i+1)
                          register[i]=0;
                end
            else if(RegWre!=0)
                begin
                    register[WreReg]<=WreData;
                end
        end
    initial
        begin
            for(i=0;i<32;i=i+1)
                register[i]=0;
        end
endmodule
