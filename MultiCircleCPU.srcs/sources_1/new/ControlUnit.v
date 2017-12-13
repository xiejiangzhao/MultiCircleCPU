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
    output reg [1:0] PCSrc,
    output reg[1:0] RegDst,
    output reg InsMemRW,
    output reg PCWre,
    output reg ExtSel,
    output reg DBDataSrc,
    output reg WR,
    output reg ALUSrcB,
    output reg ALUSrcA,
    output reg [2:0] ALUOp,
    output reg RegWre,
    output reg RD,
    output reg WrRegDSrc,
    output reg IRWre,
    output reg[3:0] stage,
    output reg[3:0] next_stage
    );
    parameter S_IF = 0;
    parameter S_ID = 1;
    parameter S_EXE1 = 2;
    parameter S_EXE2 = 3;
    parameter S_EXE3 = 4;
    parameter S_WB1 = 5;
    parameter S_WB2 = 6;
    parameter S_MEM1 = 7;
    parameter S_MEM2 = 8;
    always@(posedge CLK)
        begin
          if(RST==0)
                begin
                    stage<=10;
                    next_stage<=S_IF;
                    PCWre<=0;
                    IRWre<=0;
                    PCSrc=2'b00;
                    InsMemRW<=1;
                    RegWre<=0;
                end
          else
                stage<=next_stage;
        end
    always@(stage or command)
        begin
          case (stage)
            S_IF:
                begin
                    IRWre=1;
                    PCWre=0;
                    next_stage=S_ID;
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
                      default: ;
                    endcase
                    if (command==6'b111000||command==6'b111010) begin
                        PCSrc=2'b11;
                        if(command==6'b111010)
                            RegWre=1;
                        PCWre=1;
                        next_stage=S_IF;
                    end
                    else if(command==6'b111001) begin
                        PCSrc=2'b10;
                        PCWre=1;
                        next_stage=S_IF;
                    end
                    else if(command!=6'b111111) begin
                        if(command==6'b110100||command==6'b110101||command==6'b110110)
                            next_stage<=S_EXE2;
                        else if(command==6'b110000||command==6'b110001)
                            next_stage<=S_EXE3;
                        else 
                            next_stage<=S_EXE1;
                        end
                    else begin
                         next_stage=S_IF;
                    end
                    end
            S_EXE1:
                begin
                    if(command==6'b000000||command==6'b000001||command==6'b010000||command==6'b010001||command==6'b011000||command==6'b100110)
                        RegDst=2'b10;
                    else
                        RegDst=2'b01;
                    next_stage=S_WB1;
                    WrRegDSrc=1;
                end
            S_EXE2:begin
              PCWre=1;
              if(command==6'b110100&&zero==1||command==6'b110101&&zero==0||command==6'b110110&&zero==0&&sign==0)
                    PCSrc=2'b01;
              next_stage=S_IF;
            end
            S_EXE3:begin
              if(command==6'b110000)begin
                    next_stage=S_MEM1;
              end
              else begin
                    next_stage=S_MEM2;
                    DBDataSrc=1;
              end
            end
            S_MEM1:begin
                    WR=0;
                    PCWre=1;
                    next_stage=S_IF;
                   end
            S_MEM2:begin
                    RD=0;
                    RegDst=2'b01;
                    WrRegDSrc=1;
                    next_stage=S_WB2;
            end
            S_WB1:begin
                RegWre=1;
                PCWre=1;
                next_stage=S_IF;
            end
            S_WB2:begin
                PCWre=1;
                RegWre=1;
                next_stage=S_IF;
            end
            default:; 
          endcase
        end
endmodule
