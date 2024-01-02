`timescale 1ps / 1ps
module dsiplay_test1 ();
  reg clk;
  reg [1:0] status;
  reg [15:0] score;
  reg [15:0] mario;
  reg [31:0] pipe_1;
  reg [31:0] pipe_2;
  reg [31:0] pipe_3;
  reg [31:0] coin;
  wire [6:0] seg;
  wire dp;
  wire [3:0] AN;
  wire [11:0] rgb;
  wire hs;
  wire vs;
  display test1 (
      .clk(clk),
      .score(score),
      .mario(mario),
      .pipe_1(pipe_1),
      .pipe_2(pipe_2),
      .pipe_3(pipe_3),
      .seg(seg),
      .dp(dp),
      .AN(AN),
      .rgb(rgb),
      .hs(hs),
      .vs(vs),
      .coin(coin),
      .status(status)
  );
  always begin
    #1 clk = 1'b1;
    #1 clk = 1'b0;
  end
  initial begin
    score  = 16'h0000;
    mario  = 16'd10;
    pipe_1 = 32'd51258;
    pipe_2 = 32'd204880;
    pipe_3 = 32'd409700;
    status = 2'b11;
    coin   = 32'd0;
  end
endmodule
