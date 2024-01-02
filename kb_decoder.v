module kb_decoder (
    clk,  // 输入时钟信号
    kb_clk,  // 输入键盘时钟信号
    data,  // 输入数据
    up,  // 输出上键信号
    down,  // 输出下键信号
    space  // 输出空格键信号
);
  input wire clk;
  input wire kb_clk;
  input wire data;
  output reg up = 0;  // 初始化上键信号为0
  output reg down = 0;  // 初始化下键信号为0
  output reg space = 0;  // 初始化空格键信号为0
  wire [7:0] keycode;  // 键码
  keyboard d_1 (  // 实例化keyboard模块
      .clk(clk),
      .kb_clk(kb_clk),
      .data(data),
      .keycode(keycode),
      .sign(sign)
  );
  always @(posedge clk) begin  // 在时钟上升沿时
    case (keycode)  // 根据键码执行不同的操作
      8'h29: // 如果键码为8'h29（空格键）
    begin
        space <= sign;  // 更新空格键信号
      end
      8'h75: // 如果键码为8'h75（上键）
    begin
        up <= sign;  // 更新上键信号
      end
      8'h72: // 如果键码为8'h72（下键）
    begin
        down <= sign;  // 更新下键信号
      end
    endcase
  end
endmodule
