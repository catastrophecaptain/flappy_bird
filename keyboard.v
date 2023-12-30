module keyboard (
    input wire clk,
    input wire kb_clk,
    input wire data,
    output reg [7:0] keycode
);
  reg [1:0] state = 0;  // 00 wait 01 input 10 confirm 11 conculde
  reg [7:0] code_temp = 0;
  reg [2:0] cnt = 0;
  reg confirm=0;
  always @(negedge kb_clk or posedge clk) begin
    if (clk) begin
      if(state==2'b11)begin
        keycode <= code_temp;
        state <= 2'b00;
      end else begin
        keycode <=0;
      end
    end else begin
      case (state)
        2'b00: begin
          if (!data) begin
            state <= 2'b01;
            confirm <= 0;
          end
        end
        2'b01: begin
          if (&cnt) begin
            state <= 2'b10;
            cnt   <= 0;
          end else begin
            cnt <= cnt + 1;
          end
          if(data)begin
            confirm <= ~confirm;
          end
          code_temp = {code_temp[6:0], data};
        end
        2'b10: begin
          if (confirm^data) begin
            state <= 2'b11;
          end
          else begin
            state <= 2'b00;
          end
        end
      endcase
    end
  end
endmodule
