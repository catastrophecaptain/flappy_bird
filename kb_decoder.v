module kb_decoder (
    clk,
    kb_clk,
    data,
    up,
    down,
    space
);
  input wire clk;
  input wire kb_clk;
  input wire data;
  output reg up = 0;
  output reg down = 0;
  output reg space = 0;
  wire [7:0] keycode;
  keyboard d_1 (
      .clk(clk),
      .kb_clk(kb_clk),
      .data(data),
      .keycode(keycode),
      .sign(sign)
  );
  always @(posedge clk) begin
    case(keycode)
    8'h29:
    begin
      space <= sign;
    end
    8'h75:
    begin
      up <= sign;
    end
    8'h72:
    begin
      down <= sign;
    end
    endcase
  end
endmodule
