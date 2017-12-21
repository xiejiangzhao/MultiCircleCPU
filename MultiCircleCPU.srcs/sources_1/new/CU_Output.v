`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/12/15 19:16:11
// Design Name: 
// Module Name: CU_Output
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


module CU_Output(
    input [3:0] stage,
    input [5:0] command,
    input zero,
    input sign,
    output reg[1:0] PCSrc,
    output reg[1:0] RegDst,
    output reg InsMemRW,
    output reg PCWre,
    output reg ExtSel,
    output reg DBDataSrc,
    output reg WR,
    output reg ALUSrcB,
    output reg ALUSrcA,
    output reg[2:0] ALUOp,
    output reg RegWre,
    output reg RD,
    output reg WrRegDSrc,
    output reg IRWre
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
    always@(stage or command)
        begin
          case (stage)
            S_IF:
                begin
                    IRWre=1;
                    PCWre=0;
                    //next_stage=S_ID;
                    ALUSrcA=0;
                    ALUSrcB=0;
                    DBDataSrc=0;
                    RegWre=0;
                    WrRegDSrc=0;
                    InsMemRW=1;
                    RD=1;
                    WR=1;
                    ExtSel=1;
                    PCSrc=2'b00;
                    RegDst=2'b00;
                    ALUOp=3'b000;
                end
            S_ID:
                begin
                    IRWre=0;
                    case (command)
                        6'b000001:begin
                            ALUOp=3'b001;
                        end
                        6'b000010:begin
                            ALUSrcB=1'b1;
                        end
                        6'b010000:begin
                            ALUOp=3'b101;
                        end
                        6'b010001:begin
                            ALUOp=3'b110;
                        end
                        6'b010010:begin
                            ALUOp=3'b101;
                            ALUSrcB=1;
                        end
                        6'b011000:begin
                            ExtSel=0;
                            ALUSrcA=1;
                            ALUOp=3'b100;
                        end
                        6'b100110:begin
                            ALUOp=3'b011;
                        end
                        6'b100111:begin
                            ALUOp=3'b011;
                            ALUSrcB=1;
                        end
                        6'b110100:begin
                            ALUOp=3'b001;
                        end
                        6'b110101:begin
                            ALUOp=3'b001;
                        end
                        6'b110110:begin
                            ALUOp=3'b001;
                        end
                        6'b110001:begin
                            ALUSrcB=1;
                        end
                        6'b110000:begin
                            ALUSrcB=1;
                        end
                        6'b111000:begin
                          PCSrc=2'b11;
                          PCWre=1;
                        end
                        6'b111010:begin
                          PCSrc=2'b11;
                          RegWre=1;
                          PCWre=1;
                        end
                        6'b111001:begin
                          PCSrc=2'b10;
                          PCWre=1;
                        end
                      default: ;
                    endcase
                    end
            S_EXE1:
                begin
                    if(command==6'b000000||command==6'b000001||command==6'b010000||command==6'b010001||command==6'b011000||command==6'b100110)
                        RegDst=2'b10;
                    else
                        RegDst=2'b01;
                    WrRegDSrc=1;
                end
            S_EXE2:begin
              PCWre=1;
              if(command==6'b110100&&zero==1||command==6'b110101&&zero==0||command==6'b110110&&zero==0&&sign==0)
                    PCSrc=2'b01;
            end
            S_EXE3:begin
              if(command==6'b110000)begin
                    //next_stage=S_MEM1;
              end
              else begin
                    //next_stage=S_MEM2;
                    DBDataSrc=1;
              end
            end
            S_MEM1:begin
                    WR=0;
                    PCWre=1;
                    //next_stage=S_IF;
                   end
            S_MEM2:begin
                    RD=0;
                    RegDst=2'b01;
                    WrRegDSrc=1;
                    //next_stage=S_WB2;
            end
            S_WB1:begin
                RegWre=1;
                PCWre=1;
                //next_stage=S_IF;
            end
            S_WB2:begin
                PCWre=1;
                RegWre=1;
                //next_stage=S_IF;
            end
            default:
            begin
             PCWre<=0;
                IRWre<=0;
                               PCSrc<=2'b00;
                               InsMemRW<=1;
                               RegWre<=0;
            end 
          endcase
        end
endmodule
