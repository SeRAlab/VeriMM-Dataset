module top_module(
           CLK_IN,
           reset,
           enb_1_2000_0,
           u,
           y
          );input   CLK_IN;
  input   reset;
  input   enb_1_2000_0;
  input   signed [18:0] u;  // sfix19_En14
  output  signed [18:0] y;  // sfix19_En14

  wire signed [18:0] u_n1;  // sfix19
  assign u_n1 = {1'b0, u[18:1]};

  assign y = (u + u_n1) >> 1;

endmodule