`timescale 1ps/1ps
module pbdebounce(
    input wire clk_1ms,
    input wire btn,
    output reg pbreg
);
    reg [7:0] pbshift;
    always @(posedge clk_1ms) begin
        pbshift=pbshift <<1;
        pbshift[0]=btn;
        if(pbshift==8'b00000000)
            pbreg=1'b0;
        else if(pbshift==8'b11111111)
            pbreg=1'b1;
    end
endmodule