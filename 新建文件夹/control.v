`timescale 1ps / 1ps
module control (
    input wire clk,  //时钟
    input wire rst,  //rst为1时游戏重新开始
    input up,  //up为1时小鸟飞起，连接btn
    output reg fail,  //fail为1时游戏结束
    output reg [15:0] score,  //分数
    output reg [15:0]bird_y, //bird_y为小鸟下侧y坐标，第16位记录小鸟是否在下落，为0时小鸟下落
    output reg [19:0]pipe1,//pipe1储存管道1的x和y，x占高10位，y占低10位,x为管子左边界坐标，y为管子上侧坐标
    output reg [19:0]pipe2,//pipe2储存管道2的x和y，x占高10位，y占低10位，x为管子左边界坐标，y为管子上侧坐标
    output reg [19:0]pipe3//pipe3储存管道3的x和y，x占高10位，y占低10位，x为管子左边界坐标，y为管子上侧坐标
);
  wire [31:0] clk_div;
  wire up1;
  reg [9:0] pipe1_x;  //pipe1_x为管道1的x左边界坐标
  reg [9:0] pipe1_y;  //pipe1_y为管道1的y上边界坐标
  reg [9:0] pipe2_x;  //pipe2_x为管道2的x左边界坐标
  reg [9:0] pipe2_y;  //pipe2_y为管道2的y上边界坐标
  reg [9:0] pipe3_x;  //pipe3_x为管道3的x左边界坐标
  reg [9:0] pipe3_y;  //pipe3_y为管道3的y上边界坐标
  wire [9:0] bird_x = 9'd10;  //bird_x为小鸟左边界坐标，小鸟是不动的
  wire [9:0] gap = 9'd50;  //gap为管道间隙，供小鸟通过
  wire [9:0] bird_width = 9'd16;  //bird_width为小鸟宽度
  wire [9:0] bird_height = 9'd16;  //bird_height为小鸟高度
  wire [9:0] pipe_width = 9'd50;  //pipe_width为管道宽度
  reg [3:0] bird_falling;  //bird_falling为小鸟距离开始下落的时间，为0时小鸟下落
  wire clk_100ms;

  clk_div m0 (
      .clk(clk),
      .rst(1'b0),
      .clk_div(clk_div)
  );  //时钟分频，将时钟分频为1ms
  pbdebounce m1 (
      .clk_1ms(clk_div[17]),
      .btn(up),
      .pbreg(up1)
  );  //按钮去抖动，将按钮信号去抖动
  clk_100ms m2 (
      .clk(clk),
      .clk_100ms(clk_100ms)
  );  //100ms时钟
  always @(posedge clk_100ms or negedge rst) begin
    if (!rst) begin
      bird_y <= 16'd240;  //
      pipe1_x <= 20'd270;
      pipe2_x <= 20'd430;
      pipe3_x <= 20'd590;
      fail <= 0;
      score <= 16'd0;
      bird_falling <= 4'b0000;  //小鸟距离开始下落的时间，为0时小鸟下落
      pipe1_y <= 50 + clk_div % 371;  // 生成 50 到 420 的随机数
      pipe2_y <= 50 + clk_div % 371;  // 生成 50 到 420 的随机数
      pipe3_y <= 50 + clk_div % 371;  // 生成 50 到 420 的随机数
    end else begin
      if (up1 && !fail) begin  //按钮按下是up为1，小鸟飞起3个周期
        bird_falling <= 4'b011;
        bird_y[15]   <= 1'b1;
      end
      if (!bird_falling || fail) begin  //小鸟下落
        bird_y <= bird_y - 1;
        bird_y[15] <= 1'b0;
      end else begin  //小鸟按惯性上升
        bird_y <= bird_y + 1;
        bird_falling <= bird_falling - 1;
      end
      if (!fail) begin  //若游戏未结束，管道移动
        pipe1_x <= pipe1_x - 1;
        pipe2_x <= pipe2_x - 1;
        pipe3_x <= pipe3_x - 1;
      end
      if (pipe1_x <= 0) begin  //管道移出屏幕后重新生成
        pipe1_x <= 20'd640;
        pipe1_y <= 50 + clk_div % 371;  // 生成 50 到 420 的随机数
      end
      if (pipe2_x <= 0) begin  //管道移出屏幕后重新生成
        pipe2_x <= 20'd640;
        pipe2_y <= 50 + clk_div % 371;  // 生成 50 到 420 的随机数
      end
      if (pipe3_x <= 0) begin  //管道移出屏幕后重新生成
        pipe3_x <= 20'd640;
        pipe3_y <= 50 + clk_div % 371;  // 生成 50 到 420 的随机数
      end
      if ((((bird_y <= pipe1_y)||(bird_y+bird_height>=pipe1_y+gap))&&(bird_x<=pipe1_x+pipe_width)&&(bird_x+bird_width>=pipe1_x))
                ||(((bird_y <= pipe2_y)||(bird_y+bird_height>=pipe2_y+gap))&&(bird_x<=pipe2_x+pipe_width)&&(bird_x+bird_width>=pipe2_x))
                ||(((bird_y <= pipe3_y)||(bird_y+bird_height>=pipe3_y+gap))&&(bird_x<=pipe3_x+pipe_width)&&(bird_x+bird_width>=pipe3_x))) begin
        //若小鸟与管道相撞，游戏结束
        fail <= 1;
      end else begin
        score <= score + 1;
        //若小鸟通过管道，分数加1
      end
    end
    pipe1 <= {pipe1_x, pipe1_y};
    pipe2 <= {pipe2_x, pipe2_y};
    pipe3 <= {pipe3_x, pipe3_y};
    //将管道的x和y合并输出
  end
endmodule
