module MyMC14495 (
    D0,
    D1,
    D2,
    D3,
    point,
    LE,
    a,
    b,
    c,
    d,
    e,
    f,
    g,
    p
);
  input wire D0, D1, D2, D3, point, LE;
  output wire a, b, c, d, e, f, g, p;
  wire D0_N, D1_N, D2_N, D3_N;
  INV
      d_1_1 (
          p,
          point
      ),
      d_1_2 (
          D0_N,
          D0
      ),
      d_1_3 (
          D1_N,
          D1
      ),
      d_1_4 (
          D2_N,
          D2
      ),
      d_1_5 (
          D3_N,
          D3
      );
  assign a = (D3_N & D2_N & D1_N & D0 | D3_N & D2 & D1_N & D0_N | D3 & D2_N & D1 & D0 | D3 & D2 & D1_N & D0)|LE;
  assign b = (D3_N & D2 & D1_N & D0 | D2 & D1 & D0_N | D3 & D2 & D0_N | D3 & D1 & D0) | LE;
  assign c = (D3_N & D2_N & D1 & D0_N | D3 & D2 & D0_N | D3 & D2 & D1) | LE;
  assign d = (D3_N & D2_N & D1_N& D0 | D3_N & D2 & D1_N & D0_N | D2 & D1 & D0 | D3 & D2_N & D1 & D0_N)|LE;
  assign e = (D3_N & D0 | D3_N & D2 & D1_N | D2_N & D1_N & D0) | LE;
  assign f = (D3_N & D2_N & D0 | D3_N & D2_N & D1 | D3_N & D1 & D0 | D3 & D2 & D1_N & D0) | LE;
  assign g = (D3_N & D2_N & D1_N | D3_N & D2 & D1 & D0 | D3 & D2 & D1_N & D0_N) | LE;

endmodule
