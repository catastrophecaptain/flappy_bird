`timescale 1ps/1ps
module clk_div(
    input clk,
    input rst,
    output reg[31:0]clk_div
);
initial begin
clk_div=32'b0;
end
    always @(posedge clk or posedge rst) begin
        if(rst)
            clk_div[30:0]<=32'd0;
        else
            clk_div[30:0]<=clk_div[30:0]+1;
    end
endmodule