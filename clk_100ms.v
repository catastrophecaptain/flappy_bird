`timescale 1ps/1ps
module clk_100ms(clk,clk_100ms);
    input wire clk;
    output reg clk_100ms=0;
    reg[31:0]cnt;
    always@(posedge clk)begin
    if(cnt<5_000_00)begin
        cnt<=cnt+1'b1;
    end else begin
        cnt<=0;
        clk_100ms<=~clk_100ms;
        end
    end
endmodule