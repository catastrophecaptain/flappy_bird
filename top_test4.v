`timescale 1ns / 1ns
module top_test4 ();
    reg clk;
    reg up;
    reg clr;
     wire [6:0] seg;
     wire dp;
     wire [3:0] AN;
     wire [11:0] rgb;
     wire hs;
     wire vs;
     wire btn;
     top test4(
         .clk(clk),
         .up(up),
         .clr(clr),
         .seg(seg),
         .dp(dp),
         .AN(AN),
         .rgb(rgb),
         .hs(hs),
         .vs(vs),
         .btn(btn)
     );
    always begin
        clk = 1'b0;
        #1 clk = 1'b1;
        #1 clk = 1'b0;
    end
    initial begin
        up = 1'b0;
        clr = 1'b0;
		  #10; clr=1'b1;
    end
endmodule
