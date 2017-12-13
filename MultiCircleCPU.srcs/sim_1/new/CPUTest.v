`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/12/10 15:38:08
// Design Name: 
// Module Name: CPUTest
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


module CPUTest(
    output reg CLK
    );
    always #4 CLK=~CLK;
    reg RST;
    //PC
    wire PCWre;
    wire[31:0] IAddr,PC_next;
    //PC_Control
    wire[31:0] J_Addr,Extend_Addr;
    wire[1:0] PC_Src;
    //InsMem
    wire InsMemRW;
    wire[31:0] IData;
    //IR
    wire[31:0] IRData;
    wire IRWre;
    //to Sep instruction
    wire[5:0] opcode=IRData[31:26];
    wire[4:0] rs=IRData[25:21];
    wire[4:0] rt=IRData[20:16];
    wire[4:0] rd=IRData[15:11];
    wire[4:0] sa=IRData[10:6];
    wire[15:0] other=IRData[15:0];
    assign J_Addr=IRData[25:0];
    //Write Reg
    wire[1:0] RegDst;
    wire[4:0] WreReg;
    wire[4:0] SelectTemp;
    assign SelectTemp=(RegDst[0]==0)?5'b11111:rt;
    assign WreReg=(RegDst[1]==0)?SelectTemp:rd;
    //Write Data
    wire[31:0] DataOut;
    wire[31:0] WreData;
    wire WrRegDSrc;
    //RegFile
    wire RegWre;
    wire[31:0] DataRed1;
    wire[31:0] DataRed2;
    //ADR
    wire[31:0] ADRData;
    SaveReg ADR(CLK,DataRed1,ADRData);
    //BDR
    wire[31:0] BDRData;
    SaveReg BDR(CLK,DataRed2,BDRData);
    //To ALU
    wire[31:0] ALUA,ALUB;
    wire ALUSrcA,ALUSrcB;
    //ALU
    wire Sign,Zero;
    wire[31:0] Result;
    wire[2:0] ALUOp;
    //ALUoutDR
    wire[31:0] ALUResData;
    SaveReg ALUoutDR(CLK,Result,ALUResData);
    //DataMEM
    wire RD,WR;
    wire[31:0] DataMEMOut;
    //DBDR
    wire[31:0] DBDRIn;
    wire DBDataSrc;
    Select_32 DBDR_Select_(DBDataSrc,Result,DataMEMOut,DBDRIn);
    wire[31:0] DBDROut;
    SaveReg DBDR(CLK,DBDRIn,DBDROut);
    //Extend
    wire ExtSel;
    Extend Extend_(ExtSel,other,Extend_Addr);
    PC PC_(CLK,RST,PCWre,PC_next,IAddr);
    PC_Control PC_Control_(IAddr,J_Addr,Extend_Addr,DataRed1,PC_Src,PC_next);
    InsMem InsMem_(IAddr,InsMemRW,IData);
    IR IR_(CLK,IRWre,IData,IRData);
    Select_32 WreDataSelect_(WrRegDSrc,IAddr+'b100,DBDROut,DataOut);
    RegFile RegFile_(CLK,RST,RegWre,rs,rt,WreReg,DataOut,DataRed1,DataRed2);
    Select_32 ALU_Select1(ALUSrcA,ADRData,{27'b0,sa},ALUA);
    Select_32 ALU_Select2(ALUSrcB,BDRData,Extend_Addr,ALUB);
    ALU ALU_(ALUOp,ALUA,ALUB,Sign,Zero,Result);
    DataMEM DataMEM_(ALUResData,BDRData,RD,WR,DataMEMOut);
    wire[2:0] stage,next_stage;
    ControlUnit ControlUnit_(CLK,RST,opcode,Zero,Sign,PC_Src,RegDst,InsMemRW,PCWre,ExtSel,DBDataSrc,WR,ALUSrcB,ALUSrcA,ALUOp,RegWre,RD,WrRegDSrc,IRWre,stage,next_stage);
    initial
        begin
            CLK=0;
            RST=0;
            #20 RST=1;
        end
endmodule