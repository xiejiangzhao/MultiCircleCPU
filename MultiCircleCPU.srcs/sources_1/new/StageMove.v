`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/12/15 09:19:20
// Design Name: 
// Module Name: StageMove
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


module StageMove(
    input CLK,
    input[5:0] opcode,
    input [3:0] stage,
    output reg[3:0] next_stage
    );
        parameter[3:0] S_IF = 'b0000;
        parameter[3:0] S_ID = 'b0001;
        parameter[3:0] S_EXE1 = 'b0010;
        parameter[3:0] S_EXE2 = 'b0011;
        parameter[3:0] S_EXE3 = 'b0100;
        parameter[3:0] S_WB1 = 'b0101;
        parameter[3:0] S_WB2 = 'b0110;
        parameter[3:0] S_MEM1 = 'b0111;
        parameter[3:0] S_MEM2 = 'b1000;
    always@(stage)
        begin  
                            case (stage)
                              S_IF:begin
                              next_stage=S_ID;
                              end
                              S_ID:begin
                                if (opcode==6'b111000||opcode==6'b111010) begin
                                    next_stage=S_IF;
                                    end
                                else if(opcode==6'b111001) begin
                                    next_stage=S_IF;
                                    end
                                else if(opcode!=6'b111111) begin
                                     if(opcode==6'b110100||opcode==6'b110101||opcode==6'b110110)
                                            next_stage=S_EXE2;
                                     else if(opcode==6'b110000||opcode==6'b110001)
                                            next_stage=S_EXE3;
                                     else 
                                            next_stage=S_EXE1;
                                        end
                                     else begin
                                            next_stage=S_IF;
                                     end
                              end
                              S_EXE1:next_stage=S_WB1;
                              S_EXE2:next_stage=S_IF;
                              S_EXE3:begin
                                if(opcode==6'b110000)begin
                                            next_stage=S_MEM1;
                                    end
                                    else begin
                                            next_stage=S_MEM2;
                                    end
                                end
                              S_MEM1:next_stage=S_IF;
                              S_MEM2:next_stage=S_WB2;
                              S_WB1:next_stage=S_IF;
                              S_WB2:next_stage=S_IF;
                              default: begin
                                 next_stage=S_IF;
                                 end
                            endcase
                        end
               
endmodule
