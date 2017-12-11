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
    output reg RegDst,
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
    output reg[2:0] stage,
    output reg[2:0] next_stage
    );
    //reg[2:0] stage,next_stage;
    parameter[2:0] i_sif=3'b000;
    parameter[2:0] i_sid=3'b001;
    parameter[2:0] i_exe1=3'b010;
    parameter[2:0] i_exe2=3'b011;
    parameter[2:0] i_exe3=3'b100;
    parameter[2:0] i_smem=3'b101;
    parameter[2:0] i_wb1=3'b110;
    parameter[2:0] i_wb2=3'b111;
    parameter[5:0] i_add=6'b000000;
    parameter[5:0] i_sub=6'b000001;
    parameter[5:0] i_addi=6'b000010;
    parameter[5:0] i_or=6'b010000;
    parameter[5:0] i_and=6'b010001;
    parameter[5:0] i_ori=6'b010010;
    parameter[5:0] i_sll=6'b011000;
    parameter[5:0] i_slt=6'b100110;
    parameter[5:0] i_slti=6'b100111;
    parameter[5:0] i_sw=6'b110000;
    parameter[5:0] i_lw=6'b110001;
    parameter[5:0] i_beq=6'b110100;
    parameter[5:0] i_bne=6'b110101;
    parameter[5:0] i_bgtz=6'b110110;
    parameter[5:0] i_j=6'b111000;
    parameter[5:0] i_jr=6'b111001;
    parameter[5:0] i_jal=6'b111010;
    parameter[5:0] i_halt=6'b111111;
    always@(posedge CLK)
        begin
          if(RST==0)
                begin
                    stage=3'b111;
                    next_stage=3'b000;
                    IRWre=1;
                end
          else
                stage=next_stage;
        end
    always@(stage)
        begin
            case (stage)
              i_sif:next_stage<=i_sid;
              i_sid:
                begin
                    if(command==i_lw||i_sw)
                        begin
                          next_stage<=i_exe3;
                        end
                    else if(command==i_beq||i_bne)
                        begin
                          next_stage<=i_exe2;
                        end
                    else if(command==i_j||i_jal||i_jr)
                        begin
                          next_stage<=i_sif;
                        end
                    else
                          next_stage<=i_exe1;
                end
              i_exe1:next_stage<=i_wb1;
              i_exe2:next_stage<=i_sif;
              i_exe3:
                    next_stage<=i_smem;
              i_smem:
                    if(command==i_lw)
                        next_stage<=i_wb2;
                    else
                        next_stage<=i_sif;
              i_wb1:
                    next_stage<=i_sif;
              i_exe1:next_stage<=i_sif;
              default: next_stage<=i_sif;
            endcase
        end
    always@(stage)
      begin
        if(stage==i_sif) PCWre<=1;
            else PCWre<=0;
        if(stage==i_exe1&&command==i_sll) ALUSrcA<=1;
            else ALUSrcA<=0;
        if(command==i_addi||i_ori||i_slti||command==i_sw||i_lw) ALUSrcB<=1;
            else ALUSrcB<=0;
        if(command==i_lw) DBDataSrc<=1;
            else DBDataSrc<=0;
        if(command==i_jal||stage==i_wb1||stage==i_wb2) RegWre<=1;
            else RegWre<=0;
        if(stage==i_wb1||stage==i_wb2) WrRegDSrc<=1;
            else WrRegDSrc<=0;
        InsMemRW<=1;
        if(stage==i_smem&&command==i_lw) RD=0;
            else RD=1;
        if(stage==i_smem&&command==i_sw) WR=0;
            else WR=1;
        if(stage==i_sif) IRWre<=1;
            else IRWre<=0;
        if(command==i_ori) ExtSel<=0;
            else ExtSel<=1;
        if(command==i_j||i_jal) PCSrc<=2'b11;
            else if(command==i_jr) PCSrc<=2'b10;
            else if(command==i_beq&&zero==1||command==i_bne&&zero==0||command==i_bgtz&&zero==0&&sign==0) PCSrc<=2'b01;
            else PCSrc<=2'b00;
        if(command==i_jal) RegDst<=2'b00;
            else if(command==i_addi||i_ori||i_slti||i_lw) RegDst<=2'b01;
            else RegDst<=2'b10;
        if (command==i_add||command==i_addi) 
            begin
              ALUOp<=3'b000;
            end
        else if(command==i_sub)
            begin
              ALUOp<=3'b001;
            end
      end    
endmodule
