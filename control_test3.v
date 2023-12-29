`timescale 1ps / 1ps
module control_test3(
    );
    reg clk;//时钟
    reg rst;//rst�时游戏重新开�    
	 reg up;//up�时小鸟飞起，连接btn
    wire fail;//fail�时游戏结�    
	 wire [3:0]score;//分数
	 wire [3:0] fall;
    wire [15:0]bird_y; //bird_y为小鸟下侧y坐标，第16位记录小鸟是否在下落，为0时小鸟下�    
	 wire [19:0]pipe1;//pipe1储存管道1的x和y，x占高10位，y占低10�x为管子左边界坐标，y为管子上侧坐�    
	 wire [19:0]pipe2;//pipe2储存管道2的x和y，x占高10位，y占低10位，x为管子左边界坐标，y为管子上侧坐�    
	 wire [19:0]pipe3;//pipe3储存管道3的x和y，x占高10位，y占低10位，x为管子左边界坐标，y为管子上侧坐�    
	 control test3(
        .clk(clk),
        .rst(rst),
        .up(up),
        .fail(fail),
        .score(score),
        .bird_y(bird_y),
        .pipe1(pipe1),
        .pipe2(pipe2),
        .pipe3(pipe3),
		  .bird_falling(fall)
    );
    always begin
		  clk = ~clk;
		  #1;
    end
    initial begin
        up = 1'b1;
		  clk=0;
		  #10;
		  rst=1'b0;
		  #100000000;
		  rst=1'b1;
		  
    end

endmodule
