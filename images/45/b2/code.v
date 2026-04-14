module top_module(
  re, q, radr, radr_d, re_d, q_d
);output re;
  input [15:0] q;
  output [3:0] radr;
  input [3:0] radr_d;
  input re_d;
  output [15:0] q_d;



  
  assign re = (re_d);
  assign q_d = q;
  assign radr = (radr_d);endmodule