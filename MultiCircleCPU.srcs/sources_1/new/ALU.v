`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/12/10 16:39:54
// Design Name: 
// Module Name: ALU
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


module ALU(
input [2:0] ALUOp,
    input [31:0] A,
    input [31:0] B,
    output sign,
    output zero,
    output reg [31:0] result
    );
    assign sign = result[31];
    assign zero = result == 0?1:0;
    always@(A or B or ALUOp)
        begin
            case(ALUOp)
            3'b000:result=A+B;
            3'b001:result=A-B;
            3'b010:result=B<<A;
            3'b011:result=A|B;
            3'b100:result=A&B;
            3'b101:result=A<B?1:0;
            3'b110:
                begin
                    if(A<B&&(A[31]==B[31]))
                        begin
                            result<=1;
                        end
                    else if(A[31]&&!B[31])
                        begin
                            result<=1;
                        end
                    else
                        begin
                            result<=0;
                        end
                end
             3'b111:result<=A^B;
            endcase
        end
    initial
        begin
        result=0;
        end
endmodule
