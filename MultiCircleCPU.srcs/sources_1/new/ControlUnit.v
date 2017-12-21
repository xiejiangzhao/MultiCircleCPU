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
    output reg[3:0] state,
    output reg[3:0] next_state
    );
    reg[3:0] state_out;
    parameter [3:0]  sIF=4'b0000,
                 sID=4'b0001,
                sEAL=4'b1000,
                sEBR=4'b0100,
                sELS=4'b0010,
                sMLD=4'b0011,
                sMST=4'b0101,
                sWAL=4'b1001,
                sWLD=4'b0110;
 parameter [5:0] j=6'b111000,
                jr=6'b111001,
               jal=6'b111010,
                lw=6'b110001,
                sw=6'b110000,
               beq=6'b110100,
               bne=6'b110101,
              bgtz=6'b110110,					
               add=6'b000000,
               sub=6'b000001,
               And=6'b010001,
                Or=6'b010000,
               sll=6'b011000,
               slt=6'b100110,
              addi=6'b000010,
               ori=6'b010010,
              slti=6'b100111,
              half=6'b111111;	
  reg [3:0] state,next_state; 
  
    always@(posedge CLK) 
        begin
            if(RST==0)
                begin
                    state=sIF;
                    InsMemRW=1;
                end
            else 
                begin
                    state=next_state;
                    InsMemRW=1;
                end
            state_out=state;
        end

always@(command or state) 
    begin
        case(state)
            sIF:next_state=sID;
            sID:
                if(command[5:3]==3'b111)
                    begin
                        next_state=sIF;
                    end
                else if(command[5:2]==4'b1100)
                    begin
                        next_state=sELS;
                    end
                else if(command[5:2]==4'b1101)
                    begin
                        next_state=sEBR;
                    end
                else 
                    begin
                        next_state=sEAL;
                    end 
            sELS:
                if(command==lw)
                    begin
                        next_state=sMLD;
                    end 
                else 
                    begin
                        next_state=sMST;
                    end
            sEBR:next_state=sIF;    
            sEAL:next_state=sWAL;
            sWAL:next_state=sIF;
            sMLD:next_state=sWLD;
            sWLD:next_state=sIF; 
            sMST:next_state=sIF; 
        endcase
    end
 
always@(state) 
    begin
    //PCWre
        if(command==half)
            PCWre=0;
        else if((state==sID&&command[5:3]==3'b111)||state==sWAL||state==sWLD||state==sMST||state==sEBR)
            PCWre=1;
        else
            PCWre=0;            
    //IRWre
        if(state==sIF)
            IRWre=1;
        else  
            IRWre=0;
    //RegDst
        if((state==sID&&command==jal))
            RegDst=2'b00;
        else if(state==sWLD)
            RegDst=2'b01;
        else if(state==sWAL) 
            begin
                if(command==addi||command==ori||command==slti) 
                    RegDst=2'b01;
                else
                    RegDst=2'b10;
            end
        else
            RegDst=2'b00;
    //ExtSel
        if(state==sEAL||state==sEBR||state==sELS)
            ExtSel=1;
        else
            ExtSel=0;
  
    //PCSrc
        if(state==sID) 
            begin
                if(command==jr)
                    PCSrc=2'b10;
                else
                    PCSrc=2'b11;
            end
        else if(state==sEBR) 
            begin
                if(command==beq)
                    PCSrc=(zero==1)?2'b01:2'b00;
                else if(command==bne)
                    PCSrc=(zero==1)?2'b00:2'b01;
                else
                    PCSrc=(sign==0)?2'b01:2'b00;
            end
        else
            PCSrc=2'b00;
    //ALUSrcA
        if(state==sEAL&&command==sll)
            ALUSrcA=1;
        else
            ALUSrcA=0; 
    //ALUSrcB
        if(state==sELS||(state==sEAL&&command==addi)||(state==sEAL&&command==ori)||(state==sEAL&&command==slti))
            ALUSrcB=1;
        else
            ALUSrcB=0;  
    //ALUOp
        case(command)
            sub: ALUOp=3'b001;
            And: ALUOp=3'b110;
             Or: ALUOp=3'b101;
            slt: ALUOp=3'b011;
            sll: ALUOp=3'b100;
            slti: ALUOp=3'b011;
            ori: ALUOp=3'b101;
            beq: ALUOp=3'b001;
            bne: ALUOp=3'b001;
            bgtz: ALUOp=3'b001;
            default: ALUOp=3'b000; 
        endcase 
  
    //RD.WR 
        RD=0;
        if(state==sMST)
            WR=0;
        else
            WR=1;       
    //DBsrc
        if(state==sMLD&&command==lw)
            DBDataSrc=1;
        else
            DBDataSrc=0;
        
    //WRregdsr //WrRegDSrc 
        if(state==sID&&command==jal)
            WrRegDSrc=0;
        else
            WrRegDSrc=1;
  
    //RegWre
        if((state==sID&&command==jal)||state==sWAL||state==sWLD)
            RegWre=1;
        else
            RegWre=0;
    end     
    initial 
        begin
            PCWre=0;
            IRWre=0;
            RegDst=2'b00;
            ExtSel=0;
            PCSrc=2'b00;
            ALUSrcA=0;
            ALUSrcB=0;
            ALUOp=3'b000;
            RD=1;
            WR=1;
            DBDataSrc=0;
            WrRegDSrc=0;
            RegWre=0;
            state_out=state;
        end
endmodule
