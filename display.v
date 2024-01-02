`timescale 1ps / 1ps
module display (
    input wire clk,  // 输入时钟信号
    input wire [1:0] status,  // 输入状态信号
    input wire [15:0] score,  // 输入得分信号
    input wire [15:0] mario,  // 输入马里奥信号
    input wire [31:0] pipe_1,  // 输入管道1信号
    input wire [31:0] pipe_2,  // 输入管道2信号
    input wire [31:0] pipe_3,  // 输入管道3信号
    input wire [31:0] coin,  // 输入金币信号
    output wire [6:0] seg,  // 输出段信号
    output wire dp,  // 输出小数点信号
    output wire [3:0] AN,  // 输出AN信号
    output wire [11:0] rgb,  // 输出RGB信号
    output wire hs,  // 输出水平同步信号
    output wire vs  // 输出垂直同步信号
);
  // mario[9:0] y, mario[15] state
  // pipe[9:1] height of one of two pipes in a group, pipe[19:10] address of pipes, pipe[27:20] height gap of pipes in group
  wire [31:0] clk_extend;  // 扩展时钟信号
  wire [11:0] color_mario, color_pipe_head, color_pipe_body, color_mario_down, color_mario_up,color_coin,color_start,color_title,color_mode;  // 颜色信号
  wire [11:0] color_back;  // 背景颜色信号
  reg  [11:0] ignore;  // 忽略信号
  wire [ 9:0] x;  // x坐标信号
  wire [ 9:0] y;  // y坐标信号
  wire video_on, rdn, f_tick;  // 视频开关信号，读取使能信号，帧刷新信号
  reg clr = 1;  // 清除信号
  wire [9:0] pipe_height, pipe_address, pipe_gap;  // 管道高度信号，管道地址信号，管道间隙信号
  wire ishead, ispipe, isbody;  // 是否为头部信号，是否为管道信号，是否为身体信号
  wire ismario, iscoin;  // 是否为马里奥信号，是否为金币信号
  wire isstart, istitle, ishighlight, ismode;  // 是否为开始信号，是否为标题信号，是否为高亮信号，是否为模式信号
  wire [11:0] rgb_temp;  // RGB临时信号
  wire [16:0] score_d;  // 得分显示信号
  integer
      back_width = 256,
      back_height = 192,
      display_width = 640,
      display_height = 480;  // 背景宽度，背景高度，显示宽度，显示高度
  integer
      character_width = 16,
      character_height = 16,
      character_address = 70;  // 字符宽度，字符高度，字符地址
  integer pipes_width = 50, pipes_head_height = 23;  // 管道宽度，管道头部高度
  integer
      coin_width = 16,
      coin_height = 16,
      coin_status = 0;  // 定义硬币的宽度、高度和状态

  integer
      title_width = 183,  // 标题的宽度
      title_height = 14,  // 标题的高度
      title_width_start = 45,  // 标题的起始宽度
      title_height_start = 80,  // 标题的起始高度
      title_multi = 3;  // 标题的倍数

  integer
      mode_width = 112,  // 模式的宽度
      mode_height = 32,  // 模式的高度
      mode_width_start = 208,  // 模式的起始宽度
      mode_height_start = 340,  // 模式的起始高度
      mode_line_height = 14,  // 模式的行高
      mode_multi = 2;  // 模式的倍数
  // title x:65-613 y: 40-81
  // mode  x:228-451 y:300-363 
  initial begin
    ignore = 12'h00f;  // 初始化ignore变量为十六进制的00f
  end
  assign y[9] = 1'b0;  // 将y的第9位赋值为0
  assign pipe_gap[9:8] = 0;  // 将pipe_gap的第9位和第8位赋值为0

  // 定义一个DispNum模块实例d_0，用于处理分数的显示
  DispNum d_0 (
      .clk(clk),
      .RST(1'b0),
      .LES(4'b0000),
      .points(4'b0000),
      .AN(AN),
      .Segment({dp, seg}),
      .HEXS(score_d)
  );

  // 定义一个clkdiv模块实例d_1，用于处理时钟分频
  clkdiv d_1 (
      .clk(clk),
      .rst(1'b0),
      .clkdiv(clk_extend)
  );

  // 定义一个back_rom模块实例d_2，用于处理背景的显示
  back_rom d_2 (
      .a  ((((y * back_height) / display_height) * back_width) + (x * back_width / display_width)),
      .spo(color_back)
  );

  // 定义一个mario_rom模块实例d_3，用于处理马里奥的显示
  mario_rom d_3 (
      .a  (((y - mario[9:0]) * character_width + (x - character_address))),
      .spo(color_mario_down)
  );

  // 定义一个mario_up_rom模块实例d_6，用于处理马里奥跳跃的显示
  mario_up_rom d_6 (
      .a  (((y - mario[9:0]) * character_width + (x - character_address))),
      .spo(color_mario_up)
  );

  // 定义一个pipe_head_rom模块实例d_4，用于处理管道头部的显示
  pipe_head_rom d_4 (
      .a((((y>=pipe_height-pipes_head_height&&y<pipe_height)?
    y-pipe_height+pipes_head_height:pipe_height+pipe_gap+pipes_head_height-2-y)*pipes_width
    +(x - pipe_address))),
      .spo(color_pipe_head)
  );

  // 定义一个pipe_body_rom模块实例d_5，用于处理管道身体的显示
  pipe_body_rom d_5 (
      .spo(color_pipe_body),
      .a  (x - pipe_address)
  );

  // 定义一个coin_rom模块实例d_7，用于处理硬币的显示
  coin_rom d_7 (
      .spo(color_coin),
      .a  ((y - coin[19:10]) * coin_width * 4 + coin_width * coin_status + x - coin[9:0])
  );

  // 定义一个title_rom模块实例d_8，用于处理标题的显示
  title_rom d_8 (
      .spo(color_title),
      .a  ((y - title_height_start)/title_multi * title_width + (x-title_width_start)/title_multi)
  );

  // 定义一个mode_rom模块实例d_9，用于处理模式的显示
  mode_rom d_9 (
      .spo(color_mode),
      .a  ((y - mode_height_start) / mode_multi * mode_width + (x - mode_width_start) / mode_multi)
  );
  // 调用VGA接口模块
  vga_sync vga_sync (
      .vga_clk(clk_extend[1]),
      .clrn(clr),
      .d_in(rgb_temp),
      .hs(hs),
      .vs(vs),
      .r(rgb[11:8]),
      .g(rgb[7:4]),
      .b(rgb[3:0]),
      .rdn(rdn),
      .col_addr(x),
      .row_addr(y[8:0])
  );
  // 金币4个旋转状态的周期性变更
  always @(posedge clk_extend[22]) begin
    if (coin_status[0] && coin_status[1]) begin
      coin_status <= 0;
    end else begin
      coin_status <= coin_status + 1;
    end
  end
  // 将16进制的score转换为10进制的score_d
  assign score_d[3:0] = score % 10;
  assign score_d[7:4] = score / 10 % 10;
  assign score_d[11:8] = score / 100 % 10;
  assign score_d[15:12] = score / 1000 % 10;
  //判断是否在游戏开始界面
  assign isstart = (status[0] && ~status[1]) || (~status && status[1]);
  //判断坐标是否在标题区域
  assign istitle = (x >= title_width_start && x < title_width_start + title_multi * title_width) 
                 && (y >= title_height_start && y < title_height_start + title_multi * title_height)&&(|(color_title^ignore));
  //判断坐标是否在模式选择区域
  assign ismode = (x >= mode_width_start && x < mode_width_start + mode_multi * mode_width) 
                && (y >= mode_height_start && y < mode_height_start + mode_multi * mode_height)&&(|(color_mode^ignore));
  //判断坐标是否在高亮区域
  assign ishighlight = (status[0] && ~status[1] && ((x >= mode_width_start && x < mode_width_start + mode_multi * mode_width) 
                                                  && (y >= mode_height_start && y < mode_height_start + mode_line_height * mode_multi)))
                     || (~status[0] && status[1] && ((x >= mode_width_start && x < mode_width_start + mode_multi * mode_width) 
                                                      && (y >= mode_height_start + mode_multi * (mode_height - mode_line_height) 
                                                          && y < mode_height_start + mode_multi * mode_height)));
  //判断坐标是否在管子区域，并且确定该管子的参数
  assign {ispipe, pipe_gap[7:0], pipe_address, pipe_height} = 
    ((0 <= x - pipe_1[19:10]) && (x - pipe_1[19:10] < pipes_width)) ? {1'b1, pipe_1[27:20], pipe_1[19:10], pipe_1[9:0]} :
    ((0 <= x - pipe_2[19:10]) && (x - pipe_2[19:10] < pipes_width)) ? {1'b1, pipe_2[27:20], pipe_2[19:10], pipe_2[9:0]} :
    ((0 <= x - pipe_3[19:10]) && (x - pipe_3[19:10] < pipes_width)) ? {1'b1, pipe_3[27:20], pipe_3[19:10], pipe_3[9:0]} :
    {1'b0, 28'b0};
  //判断马里奥的状态
  assign color_mario = mario[15] ? color_mario_up : color_mario_down;
  //判断坐标是否在管子头部区域
  assign ishead = (((y >= pipe_height - pipes_head_height) && (y < pipe_height)) 
                 || ((-y + pipe_height + pipe_gap + pipes_head_height - 2 >= 10'd0) 
                     && (-y + pipe_height + pipe_gap - 2 + pipes_head_height < pipes_head_height)) 
                 && (|(color_pipe_head ^ ignore))) ? 1'b1 : 1'b0;
  //判断坐标是否在管子身体区域
  assign isbody = (y < pipe_height - pipes_head_height) 
                || (pipe_height + pipe_gap + pipes_head_height - 2 < y) 
                && (|(color_pipe_body ^ ignore)) ? 1'b1 : 1'b0;
  //判断坐标是否在马里奥区域
  assign ismario = ((character_address <= x) && (x < character_address + character_width) 
                  && (y >= mario[9:0]) && (y < mario[9:0] + character_height) 
                  && (|(color_mario ^ ignore))) ? 1'b1 : 1'b0;
  //判断坐标是否在金币区域
  assign iscoin = coin[31] && ((|(color_coin ^ ignore)) 
                             && (x - coin[9:0] < coin_width) 
                             && (y - coin[19:10] < coin_height) 
                             && (x - coin[9:0] >= 0) 
                             && (y - coin[19:0] >= 0));
  //融合开始界面图层
  assign color_start = istitle ? color_title : ismode ? color_mode : ishighlight ? 12'h888 : 12'h000;
  //融合所有图层
  assign rgb_temp = 
    rdn ? 12'h000 :
    isstart ? color_start :
    ismario ? color_mario :
    iscoin ? color_coin :
    ispipe && ishead ? color_pipe_head :
    ispipe && isbody ? color_pipe_body :
    color_back;
endmodule
