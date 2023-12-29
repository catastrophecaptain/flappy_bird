`timescale 1ns / 1ps
module DispNum(
clk,
HEXS,
LES,
points,
RST,
AN,
Segment
    );
    input wire clk,RST;
    input wire[3:0]LES,points;
    output wire[3:0]AN;
    input wire[15:0] HEXS;
    output wire[7:0] Segment;
    wire[31:0]clkd;
    wire [3:0]HEX;
    wire point,LE;
    clkdiv d0(clk,RST,clkd);
    dispsync d1(HEXS,clkd[17:16],points,LES,HEX,point,LE,AN);
    MyMC14495 d2(HEX[0],HEX[1],HEX[2],HEX[3],point,LE,Segment[0],Segment[1],Segment[2],Segment[3],Segment[4],Segment[5],Segment[6],Segment[7]);
endmodule
