module top_module(Ci_inverse,M_inverse,p,g,o);input Ci_inverse,M_inverse;
  input [3:0] p;
  input [3:0] g;
  output [3:0] o;

  wire w31,w32,w33;
  wire w21,w22,w23,w24;
  wire w11,w12,w13;
  wire w01,w02;

  assign w31 = g[2]&p[3];
  assign w32 = g[1]&p[3]&p[2];
  assign w33 = g[0]&p[3]&p[2]&p[1];

  assign w21 = p[2]&p[1]&p[0]&Ci_inverse&M_inverse;
  assign w22 = g[2]&M_inverse;
  assign w23 = p[2]&g[1]&M_inverse;
  assign w24 = p[2]&p[1]&g[0]&M_inverse;

  assign w11 = p[1]&p[0]&Ci_inverse&M_inverse;
  assign w12 = g[1]&M_inverse;
  assign w13 = p[1]&g[0]&M_inverse;

  assign w01 = p[0]&Ci_inverse&M_inverse;
  assign w02 = g[0]&M_inverse;

  assign o[3] = ~(g[3]|w31|w32|w33);
  assign o[2] = ~(w21|w22|w23|w24);
  assign o[1] = ~(w11|w12|w13);
  assign o[0] = ~(w01|w02);

endmodule