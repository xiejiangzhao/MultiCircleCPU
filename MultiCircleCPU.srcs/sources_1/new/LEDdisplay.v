`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/12/14 19:21:46
// Design Name: 
// Module Name: LEDdisplay
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


module LEDdisplay(
    input CLK,
    input RST,
    input [15:0] data,
    output reg[10:0] display
    );
    reg[5:0] i=0;
    reg [19:0]count=0;
    reg [2:0] sel=0;
    parameter T1MS=50000;
    wire[6:0] display1,display2,display3,display4;
    SegLED LED1(.display_data(data[15:12]),.dispcode(display1));
    SegLED LED2(.display_data(data[11:8]),.dispcode(display2));
    SegLED LED3(.display_data(data[7:4]),.dispcode(display3));
    SegLED LED4(.display_data(data[3:0]),.dispcode(display4));
    always@(negedge CLK)
        begin
          if(RST==0)
            begin
                for(i=0;i<11;i=i+1)
                    display[i]=0;
            end
          else
            begin
                case (sel)
                  0:display<={4'b0111,display1};
                  1:display<={4'b1011,display2};
                  2:display<={4'b1101,display3};
                  3:display<={4'b1110,display4};
                  default: display<=11'b1111_111111;
                endcase
            end
        end
     always@(posedge CLK)
        begin
            count<=count+1;
        if(count==T1MS)
        begin
            count<=0;
            sel<=sel+1;
        if(sel==4)
            sel<=0;
        end
        end  
endmodule
