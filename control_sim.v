`timescale 1ps/1ps
module control_sim();
    reg clk;//时钟
    reg rst;//rst为1时重置游戏
    reg up;//up为1时小鸟飞，为0时小鸟下落
    reg pipe_up;
    reg pipe_down;
    reg [1:0] status;
    reg [15:0]score;//分数
    reg [15:0]bird_y; //bird_y为小鸟下落的y坐标，初始为0，小鸟在屏幕中间
    reg [31:0]pipe1;//pipe1存储管道1的x和y，x为屏幕右侧，y为屏幕上方，x为10位，y为10位，x为屏幕左侧，y为屏幕下方
    reg [31:0]pipe2;//pipe2存储管道2的x和y，x为屏幕右侧，y为屏幕上方，x为10位，y为10位，x为屏幕左侧，y为屏幕下方
    reg [31:0]pipe3;//pipe3存储管道3的x和y，x为屏幕右侧，y为屏幕上方，x为10位，y为10位，x为屏幕左侧，y为屏幕下方
    reg [31:0]coin;
    control test3(
        .clk(clk),
        .rst(rst),
        .up(up),
        .pipe_up(pipe_up),
        .pipe_down(pipe_down),
        .status(status),
        .score(score),
        .bird_y(bird_y),
        .pipe1(pipe1),
        .pipe2(pipe2),
        .pipe3(pipe3),
        .coin(coin)
    );
    always begin
        clk = ~clk;
        #20;
    end
    initial begin
        clk=0;
        rst=1'b0;
        pipe_up = 1'b0;
        pipe_down = 1'b0;
        up = 1'b0;
        #100;
        pipe_up = 1'b1;#10;
        pipe_up = 1'b0;#10;
        rst=1'b1;#100;
        up=1'b1;#10;
        up=1'b0;#10;
        up=1'b1;pipe_up=1'b1;#10;
        up=1'b0;pipe_up=1'b0;#10;
        up=1'b1;pipe_down=1'b1;#10;
        up=1'b0;pipe_down=1'b0;#10;
        #1000;
        rst=1'b0;
    end
endmodule