module keyboard (
    input wire clk,
    input wire kb_clk,
    input wire data,
    output reg [7:0] keycode,
    output reg sign
);
  reg [1:0] state = 0;  // 00 wait 01 input 10 confirm 11 conculde
  reg [7:0] code_temp = 0;
  reg [2:0] cnt = 0;
  reg confirm = 0;
  reg [2:0] kb_clk_old = 0;
  initial begin
    keycode = 8'h00;
    sign = 0;
  end
  always @(posedge clk) begin
    kb_clk_old <= {kb_clk_old[1:0], kb_clk};
    case (state)
      2'b00: begin
        if (kb_clk_old[2] & ~kb_clk_old[1]) begin
          if (!data) begin
            if ((&code_temp[7:4]) && ~(|code_temp[3:0])) begin
              sign <= 0;
            end else begin
              sign <= 1;
            end
            state   <= 2'b01;
            confirm <= 0;
          end
        end
        keycode <= 8'h00;
      end
      2'b01: begin
        if (kb_clk_old[2] & ~kb_clk_old[1]) begin
          if (&cnt) begin
            state <= 2'b10;
            cnt   <= 0;
          end else begin
            cnt <= cnt + 1;
          end
          if (data) begin
            confirm <= ~confirm;
          end
          code_temp <= {code_temp[6:0], data};
        end
        keycode <= 8'h00;
      end
      2'b10: begin
        if (kb_clk_old[2] & ~kb_clk_old[1]) begin
          if ((confirm ^ data)) begin
            state <= 2'b11;
          end else begin
            state <= 2'b00;
            code_temp <= 8'h00;
          end
        end
        keycode <= 8'h00;
      end
      2'b11:
      begin
        state <= 2'b00;
        {keycode[0],keycode[1],keycode[2],keycode[3],keycode[4],keycode[5],keycode[6],keycode[7]} <= code_temp;
        {code_temp[0],code_temp[1],code_temp[2],code_temp[3],code_temp[4],code_temp[5],code_temp[6],code_temp[7]} <= code_temp;
      end
    endcase
  end
endmodule