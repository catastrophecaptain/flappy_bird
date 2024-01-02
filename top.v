module top (
    input wire clk,  // 时钟信号
    input wire clr,  // 清除信号
    input wire mode, // 模式信号
    input wire kb_clk, // 键盘时钟信号
    input wire data, // 数据信号
    output wire [6:0] seg, // 七段显示器信号
    output wire dp, // 小数点信号
    output wire [3:0] AN, // 公共阳极信号
    output wire [11:0] rgb, // RGB信号
    output wire hs, // 水平同步信号
    output wire vs, // 垂直同步信号
    output wire btn, // 按钮信号
    output wire audio // 音频信号
);
    wire [1:0]status; // 状态信号
    assign btn=1'b0; // 按钮信号赋值为0
    wire [15:0] score; // 分数信号
    wire [15:0] mario; // 马里奥信号
    wire [31:0] pipe_1; // 管道1信号
    wire [31:0] pipe_2; // 管道2信号
    wire [31:0] pipe_3; // 管道3信号
    wire [31:0] coin; // 硬币信号
    wire space,up,down; // 空格，上，下信号
    kb_decoder kb_decoder ( // 键盘解码器模块
        .clk(clk),
        .kb_clk(kb_clk),
        .data(data),
        .up(up),
        .down(down),
        .space(space)
    );
    control control ( // 控制模块
        .clk(clk),
        .rst(clr),
        .up(space),
        .coin(coin),
        .status(status),
        .score(score),
        .bird_y(mario),
        .pipe1(pipe_1),
        .pipe2(pipe_2),
        .pipe3(pipe_3),
        .pipe_up(up),
        .pipe_down(down)
    );
    display display ( // 显示模块
        .clk(clk),
        .score(score),
        .status(status),
        .mario(mario),
        .pipe_1(pipe_1),
        .pipe_2(pipe_2),
        .pipe_3(pipe_3),
        .seg(seg),
        .dp(dp),
        .AN(AN),
        .rgb(rgb),
        .hs(hs),
        .vs(vs),
        .coin(coin)
    );
    BuzzerController buzzer_controller ( // 蜂鸣器控制器模块
        .clk(clk),
        .buzzer(audio)
    );
endmodule
