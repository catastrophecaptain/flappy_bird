`timescale 1ps / 1ps
module display (
    input wire clk,
    input wire fail,
    input wire [15:0] score,
    input wire [15:0] mario,
    input wire [31:0] pipe_1,
    input wire [31:0] pipe_2,
    input wire [31:0] pipe_3,
    output wire [6:0] seg,
    output wire dp,
    output wire [3:0] AN,
    output wire [11:0] rgb,
    output wire hs,
    output wire vs
);
// mario[9:0] y, mario[15] state
// pipe[9:1] height of one of two pipes in a group, pipe[19:10] address of pipes, pipe[27:20] height gap of pipes in group
  wire [31:0] clk_extend;
  wire [11:0] color_mario, color_pipe_head, color_pipe_body;
  wire [11:0] color_back;
  reg  [11:0] ignore;
  wire [ 9:0] x;
  wire [ 9:0] y;
  wire video_on, rdn, f_tick;
  reg clr;
  wire [9:0] pipe_height;
  wire [9:0] pipe_address;
  wire ishead, ispipe, isbody;
  wire ismario;
  wire [11:0] rgb_temp;
  initial begin
    ignore = 12'h06f;
    clr = 1'b0;
  end
  //   always @(negedge clk) begin
  // clr <= 1'b1;
  //   end
  assign y[9] = 1'b0;
  DispNum d_0 (
      .clk(clk),
      .RST(1'b0),
      .LES(4'b0000),
      .points(4'b0000),
      .AN(AN),
      .Segment({dp, seg}),
      .HEXS(score)
  );
  //   /*clkdiv d_1 (
  //   .clk(clk),
  //   .rst(1'b0), 
  //   .clkdiv(clk_extend)
  //   );*/
  wire [9:0] back_width=76,back_height=57,display_width=640,display_height=480;
  back_rom d_2 (
      .a  ((((y * back_height) / display_height) * back_width) + (x * back_width / display_width)),
      .spo(color_back)
  );
  mario_rom d_3 (
      .a  ((y - mario[9:0]) * 16 + (x - 10'd10)),
      .spo(color_mario)
  );
  pipe_head_rom d_4 (
      .a((((y>=pipe_height-10'd23&&y<pipe_height)?y-pipe_height+23:579-pipe_height-y)*50+(x - pipe_address))),
      .spo(color_pipe_head)
  );
  pipe_body_rom d_5 (
      .spo(color_pipe_body),
      .a  (x - pipe_address)
  );
  vga_sync vga_sync (
      .vga_clk(clk),
      .clrn(clr),
      .d_in(rgb_temp),
      .hs(hs),
      .vs(vs),
      .r(rgb[3:0]),
      .g(rgb[7:4]),
      .b(rgb[11:8]),
      .rdn(rdn),
      .col_addr(x),
      .row_addr(y[8:0])
  );
  assign {ispipe, pipe_height, pipe_address} = 
    ((0 <= x - pipe_1[19:10]) && (x - pipe_1[19:10] <= 49)) ? {1'b1, pipe_1[9:0], pipe_1[19:10]} :
    ((0 <= x - pipe_2[19:10]) && (x - pipe_2[19:10] <= 49)) ? {1'b1, pipe_2[9:0], pipe_2[19:10]} :
    ((0 <= x - pipe_3[19:10]) && (x - pipe_3[19:10] <= 49)) ? {1'b1, pipe_3[9:0], pipe_3[19:10]} :
                                                              {1'b0, 10'b0, 10'b0};
  assign ishead = ((y >=pipe_height - 10'd23) && (y < pipe_height)) || 
                ((y + pipe_height >= 10'd579) && (y + pipe_height < 10'd579 + 10'd23)) ? 1'b1 : 1'b0;
  assign isbody = (y < pipe_height - 10'd23) || (y + pipe_height >= 10'd579 + 10'd23) ? 1'b1 : 1'b0;
  assign ismario = ((10 <= x) && (x <= 25) && (y >= mario[9:0]) && (y <= mario[9:0] + 15) && (|(color_mario^ignore))) ? 1'b1 : 1'b0;
  assign rgb_temp = rdn?12'h000:ismario ? color_mario : ispipe&&ishead ? color_pipe_head : ispipe&&isbody ? color_pipe_body : color_back;

endmodule
