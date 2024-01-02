module top (
    input wire clk,
    input wire clr,
    input wire mode,
    input wire kb_clk,
    input wire data,
    output wire [6:0] seg,
    output wire dp,
    output wire [3:0] AN,
    output wire [11:0] rgb,
    output wire hs,
    output wire vs,
    output wire btn,
    output wire audio
);
    wire [1:0]status;
    assign btn=1'b0;
    wire [15:0] score;
    wire [15:0] mario;
    wire [31:0] pipe_1;
    wire [31:0] pipe_2;
    wire [31:0] pipe_3;
    wire [31:0] coin;
    wire space,up,down;
    kb_decoder kb_decoder (
        .clk(clk),
        .kb_clk(kb_clk),
        .data(data),
        .up(up),
        .down(down),
        .space(space)
    );
    control control (
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
    display display (
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
    BuzzerController buzzer_controller (
        .clk(clk),
        .buzzer(audio)
    );
endmodule
