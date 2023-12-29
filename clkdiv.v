module clkdiv (
    input clk,
    input rst,
    output reg [31:0] clkdiv
);
initial clkdiv = 0;
  always @(posedge clk or posedge rst) begin
    if (rst) clkdiv <= 0;
    else clkdiv <= clkdiv + 1'b1;
  end
endmodule
