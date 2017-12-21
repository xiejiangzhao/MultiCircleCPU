`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/12/14 19:22:52
// Design Name: 
// Module Name: SegLED
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


module SegLED(
    input [3:0] display_data,
    output reg [6:0] dispcode
);
    always @( display_data ) 
    begin
        case (display_data)
            4'b0000 : dispcode = 7'b0000001; //0 ??'0'- ??????'1'- ?¡§??
            4'b0001 : dispcode = 7'b1001111; //1
            4'b0010 : dispcode = 7'b0010010; //2
            4'b0011 : dispcode = 7'b0000110; //3
            4'b0100 : dispcode = 7'b1001100; //4
            4'b0101 : dispcode = 7'b0100100; //5
            4'b0110 : dispcode = 7'b0100000; //6
            4'b0111 : dispcode = 7'b0001111; //7
            4'b1000 : dispcode = 7'b0000000; //8
            4'b1001 : dispcode = 7'b0000100; //9
            4'b1010 : dispcode = 7'b0001000; //A
            4'b1011 : dispcode = 7'b1100000; //b
            4'b1100 : dispcode = 7'b0110001; //C
            4'b1101 : dispcode = 7'b1000001; //d
            4'b1110 : dispcode = 7'b0110000; //E
            4'b1111 : dispcode = 7'b0111000; //F
            default : dispcode = 7'b1111111; // ????
        endcase
    end
endmodule