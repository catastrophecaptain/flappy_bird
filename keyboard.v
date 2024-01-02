module keyboard (
    input wire clk,  // 输入时钟信号
    input wire kb_clk,  // 输入键盘时钟信号
    input wire data,  // 输入数据
    output reg [7:0] keycode,  // 输出键码
    output reg sign  // 输出信号
);
  reg [1:0] state = 0;  // 状态机的状态，00等待，01输入，10确认，11结束
  reg [7:0] code_temp = 0;  // 临时存储键码
  reg [2:0] cnt = 0;  // 计数器
  reg confirm = 0;  // 确认信号
  reg [2:0] kb_clk_old = 0;  // 存储旧的键盘时钟信号
  initial begin
    keycode = 8'h00;  // 初始化键码为0
    sign = 0;  // 初始化信号为0
  end
  always @(posedge clk) begin  // 在时钟上升沿时
    kb_clk_old <= {kb_clk_old[1:0], kb_clk};  // 更新键盘时钟信号
    case (state)  // 根据状态机的状态执行不同的操作
      2'b00: begin  // 等待状态
        if (kb_clk_old[2] & ~kb_clk_old[1]) begin
          if (!data) begin
            if ((&code_temp[7:4]) && ~(|code_temp[3:0])) begin
              sign <= 0;
            end else begin
              sign <= 1;
            end
            state   <= 2'b01;  // 转到输入状态
            confirm <= 0;

          end
        end
        keycode <= 8'h00;  // 清空键码
      end
      2'b01: begin  // 输入状态
        if (kb_clk_old[2] & ~kb_clk_old[1]) begin
          if (&cnt) begin
            state <= 2'b10;  // 转到确认状态
            cnt   <= 0;
          end else begin
            cnt <= cnt + 1;  // 计数器加1
          end
          if (data) begin
            confirm <= ~confirm;  // 翻转确认信号
          end
          code_temp <= {code_temp[6:0], data};  // 更新临时键码
        end
        keycode <= 8'h00;  // 清空键码
      end
      2'b10: begin  // 确认状态
        if (kb_clk_old[2] & ~kb_clk_old[1]) begin
          if ((confirm ^ data)) begin
            state <= 2'b11;  // 转到结束状态
          end else begin
            state <= 2'b00;  // 转到等待状态
            code_temp <= 8'h00;  // 清空临时键码
          end
        end
        keycode <= 8'h00;  // 清空键码
      end
      2'b11: begin  // 结束状态
        state <= 2'b00;  // 转到等待状态
        {keycode[0],keycode[1],keycode[2],keycode[3],keycode[4],keycode[5],keycode[6],keycode[7]} <= code_temp; // 更新键码
        {code_temp[0],code_temp[1],code_temp[2],code_temp[3],code_temp[4],code_temp[5],code_temp[6],code_temp[7]} <= code_temp; // 更新临时键码
      end
    endcase
  end
endmodule
