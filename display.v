`timescale 1ps / 1ps
module display (
    input wire clk,
    input wire [1:0] status,
    input wire [15:0] score,
    input wire [15:0] mario,
    input wire [31:0] pipe_1,
    input wire [31:0] pipe_2,
    input wire [31:0] pipe_3,
    input wire [31:0] coin,
    output wire [6:0] seg,
    output wire dp,
    output wire [3:0] AN,
    output wire [11:0] rgb,
    output wire hs,
    output wire vs
);
  // mario[9:0] y, mario[15] state
  // pipe[9:1] height of one of two pipes in a group, pipe[19:10] address of pipes, pipe[27:20] height gap of pipes in group
  // title x:65-613 y: 40-81
  // mode  x:228-451 y:300-363
  wire [31:0] clk_extend;
  wire [11:0] color_mario, color_pipe_head, color_pipe_body, color_mario_down, color_mario_up,color_coin,color_start,color_title,color_mode;
  wire [11:0] color_back;
  reg  [11:0] ignore;
  wire [ 9:0] x;
  wire [ 9:0] y;
  wire video_on, rdn, f_tick;
  reg clr = 1;
  wire [9:0] pipe_height, pipe_address, pipe_gap;
  wire ishead, ispipe, isbody;
  wire ismario, iscoin;
  wire isstart, istitle, ishighlight, ismode;
  wire [11:0] rgb_temp;
  integer back_width = 76, back_height = 57, display_width = 640, display_height = 480;
  integer character_width = 16, character_height = 16, character_address = 70;
  integer pipes_width = 50, pipes_head_height = 23;
  integer coin_width = 16, coin_height = 16, coin_status = 0;
  integer
      title_width = 183,
      title_height = 14,
      title_width_start = 45,
      title_height_start = 80,
      title_multi = 3;
  integer
      mode_width = 112,
      mode_height = 32,
      mode_width_start = 208,
      mode_height_start = 340,
      mode_line_height = 14,
      mode_multi = 2;
  initial begin
    ignore = 12'h00f;
  end
  assign y[9] = 1'b0;
  assign pipe_gap[9:8] = 0;
  DispNum d_0 (
      .clk(clk),
      .RST(1'b0),
      .LES(4'b0000),
      .points(4'b0000),
      .AN(AN),
      .Segment({dp, seg}),
      .HEXS(score)
  );
  clkdiv d_1 (
      .clk(clk),
      .rst(1'b0),
      .clkdiv(clk_extend)
  );
  back_rom d_2 (
      .a  ((((y * back_height) / display_height) * back_width) + (x * back_width / display_width)),
      .spo(color_back)
  );
  mario_rom d_3 (
      .a  (((y - mario[9:0]) * character_width + (x - character_address))),
      .spo(color_mario_down)
  );
  mario_up_rom d_6 (
      .a  (((y - mario[9:0]) * character_width + (x - character_address))),
      .spo(color_mario_up)
  );
  pipe_head_rom d_4 (
      .a((((y>=pipe_height-pipes_head_height&&y<pipe_height)?
      y-pipe_height+pipes_head_height:pipe_height+pipe_gap+pipes_head_height-2-y)*pipes_width
      +(x - pipe_address))),
      .spo(color_pipe_head)
  );
  pipe_body_rom d_5 (
      .spo(color_pipe_body),
      .a  (x - pipe_address)
  );
  coin_rom d_7 (
      .spo(color_coin),
      .a  ((y - coin[19:10]) * coin_width * 4 + coin_width * coin_status + x - coin[9:0])
  );
  title_rom d_8 (
      .spo(color_title),
      .a  ((y - title_height_start)/title_multi * title_width + (x-title_width_start)/title_multi)
  );  // mod
  mode_rom d_9 (
      .spo(color_mode),
      .a  ((y - mode_height_start) / mode_multi * mode_width + (x - mode_width_start) / mode_multi)
  );  //mod
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
  always @(posedge clk_extend[22]) begin
    if (coin_status[0] && coin_status[1]) begin
      coin_status <= 0;
    end else begin
      coin_status <= coin_status + 1;
    end
  end
  assign isstart = (status[0] && ~status[1]) || (~status && status[1]);

  assign istitle = (x >= title_width_start && x < title_width_start + title_multi * title_width) 
                 && (y >= title_height_start && y < title_height_start + title_multi * title_height)&&(|(color_title^ignore));

  assign ismode = (x >= mode_width_start && x < mode_width_start + mode_multi * mode_width) 
                && (y >= mode_height_start && y < mode_height_start + mode_multi * mode_height)&&(|(color_mode^ignore));

  assign ishighlight = (status[0] && ~status[1] && ((x >= mode_width_start && x < mode_width_start + mode_multi * mode_width) 
                                                  && (y >= mode_height_start && y < mode_height_start + mode_line_height * mode_multi)))
                     || (~status[0] && status[1] && ((x >= mode_width_start && x < mode_width_start + mode_multi * mode_width) 
                                                      && (y >= mode_height_start + mode_multi * (mode_height - mode_line_height) 
                                                          && y < mode_height_start + mode_multi * mode_height)));

  assign {ispipe, pipe_gap[7:0], pipe_address, pipe_height} = 
    ((0 <= x - pipe_1[19:10]) && (x - pipe_1[19:10] < pipes_width)) ? {1'b1, pipe_1[27:20], pipe_1[19:10], pipe_1[9:0]} :
    ((0 <= x - pipe_2[19:10]) && (x - pipe_2[19:10] < pipes_width)) ? {1'b1, pipe_2[27:20], pipe_2[19:10], pipe_2[9:0]} :
    ((0 <= x - pipe_3[19:10]) && (x - pipe_3[19:10] < pipes_width)) ? {1'b1, pipe_3[27:20], pipe_3[19:10], pipe_3[9:0]} :
    {1'b0, 28'b0};

  assign color_mario = mario[15] ? color_mario_up : color_mario_down;

  assign ishead = (((y >= pipe_height - pipes_head_height) && (y < pipe_height)) 
                 || ((-y + pipe_height + pipe_gap + pipes_head_height - 2 >= 10'd0) 
                     && (-y + pipe_height + pipe_gap - 2 + pipes_head_height < pipes_head_height)) 
                 && (|(color_pipe_head ^ ignore))) ? 1'b1 : 1'b0;

  assign isbody = (y < pipe_height - pipes_head_height) 
                || (pipe_height + pipe_gap + pipes_head_height - 2 < y) 
                && (|(color_pipe_body ^ ignore)) ? 1'b1 : 1'b0;

  assign ismario = ((character_address <= x) && (x < character_address + character_width) 
                  && (y >= mario[9:0]) && (y < mario[9:0] + character_height) 
                  && (|(color_mario ^ ignore))) ? 1'b1 : 1'b0;

  assign iscoin = coin[31] && ((|(color_coin ^ ignore)) 
                             && (x - coin[9:0] < coin_width) 
                             && (y - coin[19:10] < coin_height) 
                             && (x - coin[9:0] >= 0) 
                             && (y - coin[19:0] >= 0));

  assign color_start = istitle ? color_title : ismode ? color_mode : ishighlight ? 12'h888 : 12'h000;

  assign rgb_temp = 
    rdn ? 12'h000 :
    isstart ? color_start :
    ismario ? color_mario :
    iscoin ? color_coin :
    ispipe && ishead ? color_pipe_head :
    ispipe && isbody ? color_pipe_body :
    color_back;
endmodule
