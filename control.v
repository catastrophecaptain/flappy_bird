`timescale 1ps / 1ps
module control (
    input wire clk,  //时钟
    input wire rst,  //rst为1时游戏重新开始
    input up,  //up为1时小鸟飞起，连接btn
    //input mode,  //mode为1时双人模式，为0时单人模式
    //output reg [1:0]status,  
    output reg [15:0] score,  //分数
    output reg [15:0]bird_y, //bird_y为小鸟下侧y坐标，第16位记录小鸟是否在下落，为0时小鸟下落，为1时小鸟上升
    output reg [31:0]pipe1,//pipe1储存管道1的x和y和gap，x占高10位，y占低10位，x为管子左边界坐标，y为管子上侧坐标
    output reg [31:0]pipe2,//pipe2储存管道2的x和y和gap，x占高10位，y占低10位，x为管子左边界坐标，y为管子上侧坐标
    output reg [31:0]pipe3,//pipe3储存管道3的x和y和gap，x占高10位，y占低10位，x为管子左边界坐标，y为管子上侧坐标
    output reg [31:0]coin//coin储存金币的x和y，y占高10位，x占低10位，x为金币左边界坐标，y为金币下侧坐标
	 //output reg [3:0]bird_falling
);
  wire [31:0] clk_div;
  wire up1;
  reg fail;//fail为1游戏结束
  reg pass1;
  reg pass2;
  reg pass3; //pass1,pass2,pass3为小鸟是否通过管道，为1时通过
  reg longpress;
  reg [9:0] pipe1_x;  //pipe1_x为管1的x左边界坐标
  reg [9:0] pipe1_y;  //pipe1_y为管1的y上边界坐标
  reg [9:0] pipe2_x;  //pipe2_x为管2的x左边界坐标
  reg [9:0] pipe2_y;  //pipe2_y为管2的y上边界坐标
  reg [9:0] pipe3_x;  //pipe3_x为管3的x左边界坐标
  reg [9:0] pipe3_y;  //pipe3_y为管3的y上边界坐标
  wire [9:0] bird_x = 9'd40;  //bird_x为小鸟左边界坐标，小鸟是不动的，所以x坐标为常数
  wire [9:0] gap = 9'd50;  //gap为管道间隙，供小鸟通过
  wire [9:0] bird_width = 9'd16;  //bird_width为小鸟宽度
  wire [9:0] bird_height = 9'd16;  //bird_height为小鸟高度
  wire [9:0] pipe_width = 9'd50;  //pipe_width为管道宽度
  wire [7:0] pipe_head=8'd30;
  wire [7:0] coin_length=8'd16;
  reg [7:0]gap1;  //gap1为管道1的间隙，供小鸟通过
  reg [7:0]gap2;  //gap2为管道2的间隙，供小鸟通过
  reg [7:0]gap3;  //gap3为管道3的间隙，供小鸟通过
  reg [3:0] bird_falling;  //bird_falling为小鸟距离开始下落的时间，为0时小鸟下落
  wire clk_100ms;

  clk_div m0 (
      .clk(clk),
      .rst(1'b0),
      .clk_div(clk_div)
  );  //时钟分频，将时钟分频100ms
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
      bird_y <= 16'd240;  //小鸟初始位置
      pipe1_x <= 20'd210;
      pipe2_x <= 20'd420;
      pipe3_x <= 20'd630;
      pass1 <= 0;
      pass2 <= 0;
      pass3 <= 0;//pass1,pass2,pass3为小鸟是否通过管道，为1时通过
      longpress <= 0;
      fail <= 0;
      score <= 16'd0;
      bird_falling <= 4'b0000;  //小鸟距离开始下落的时间，为0时小鸟下落
      coin[31] <= 1'b1;
      coin[9:0] <= 10'd660+clk_div % 20;
      coin[19:10] <= 20+(clk_div+50)%(440-coin_length);
      pipe1_y <= pipe_head + clk_div % (330-pipe_head-pipe_head);  // 生成pipe_head到480-150-pipe_head的随机数
      pipe2_y <= pipe_head + (clk_div+10) % (330-pipe_head-pipe_head);  // 生成pipe_head到480-150-pipe_head的随机数
      pipe3_y <= pipe_head + (clk_div+20) % (330-pipe_head-pipe_head);  // 生成pipe_head到480-150-pipe_head的随机数
      gap1 <= 100 + clk_div % 50;
      gap2 <= 100 + (clk_div+10) % 50;
      gap3 <= 100 + (clk_div+20) % 50;
      pipe1 <= {gap1,pipe1_x, pipe1_y};
      pipe2 <= {gap2,pipe2_x, pipe2_y};
      pipe3 <= {gap3,pipe3_x, pipe3_y};
    end else begin
      if (up1 && !fail && !longpress) begin  //按钮按下时up为1，小鸟飞行4个周期
        bird_falling <= 4'd4;
        bird_y[15]   <= 1'b1;
        longpress <= 1;
      end
      else if ((~(|bird_falling))||fail) begin  //小鸟下落
        bird_y <= bird_y - 3;
        bird_y[15] <= 1'b0;
      end
		  else begin  //小鸟按惯性向上飞
        bird_y <= bird_y + bird_falling;
        bird_falling <= bird_falling - 1;
      end
      if (!up1) begin
        longpress <= 0;
      end
      if (!fail) begin  //若游戏未结束，管道移动
        pipe1_x <= pipe1_x - 2;
        pipe2_x <= pipe2_x - 2;
        pipe3_x <= pipe3_x - 2;
        coin[9:0] <= coin[9:0] - 2;
      end
      if (pipe1_x <= 0) begin  //管道移出屏幕后重新生成
        pipe1_x <= 20'd640;
        pipe1_y <= pipe_head + clk_div % (330-pipe_head-pipe_head);  // 生成pipe_head到480-150-pipe_head的随机数
        gap1 <= 100 + clk_div % 50;
        pass1 <= 0;
        coin[31] <= 1'b1;
        coin[9:0] <= 10'd660+clk_div % 20;
        coin[19:10] <= 20+(clk_div+50)%(440-coin_length);
      end
      if (pipe2_x <= 0) begin  //管道移出屏幕后重新生成 
        pipe2_x <= 20'd640;
        pipe2_y <= pipe_head + clk_div % (330-pipe_head-pipe_head);  // 生成pipe_head到480-150-pipe_head的随机数
        gap2 <= 100 + clk_div % 50;
        pass2 <= 0;
      end
      if (pipe3_x <= 0) begin  //管道移出屏幕后重新生成
        pipe3_x <= 20'd640;
        pipe3_y <= pipe_head + clk_div % (330-pipe_head-pipe_head);  // 生成pipe_head到480-150-pipe_head的随机数
        gap3 <= 100 + clk_div % 50;
        pass3 <= 0;
      end
      if ((((bird_y <= pipe1_y)||(bird_y+bird_height>=pipe1_y+gap1))&&(bird_x<=pipe1_x+pipe_width)&&(bird_x+bird_width>=pipe1_x))
                ||(((bird_y <= pipe2_y)||(bird_y+bird_height>=pipe2_y+gap2))&&(bird_x<=pipe2_x+pipe_width)&&(bird_x+bird_width>=pipe2_x))
                ||(((bird_y <= pipe3_y)||(bird_y+bird_height>=pipe3_y+gap3))&&(bird_x<=pipe3_x+pipe_width)&&(bird_x+bird_width>=pipe3_x))) begin
        //若小鸟与管道相撞，游戏结束
        fail <= 1;
      end
      else if (!fail) begin
        if((~pass1)&&(bird_x>=pipe1_x+pipe_width)) begin
          score <= score + 1;
          pass1 <= 1;
        end
        if((~pass2)&&(bird_x>=pipe2_x+pipe_width)) begin
          score <= score + 1;
          pass2 <= 1;
        end
        if((~pass3)&&(bird_x>=pipe3_x+pipe_width)) begin
          score <= score + 1;
          pass3 <= 1;
        end
        //若小鸟通过管道，分数加1
      end
      if(coin[31]&&((bird_y<=coin[19:10]+coin_length)&&(bird_y+bird_height>=coin[19:10])&&(bird_x<=coin[9:0]+coin_length)&&(bird_x+bird_width>=coin[9:0]))) begin
        coin[31] <= 1'b0;
        score <= score + 2;
      end
      pipe1 <= {gap1,pipe1_x, pipe1_y};
      pipe2 <= {gap2,pipe2_x, pipe2_y};
      pipe3 <= {gap3,pipe3_x, pipe3_y};
    end
  end
endmodule
