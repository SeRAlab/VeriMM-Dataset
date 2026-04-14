module top_module(
  we, d, wadr, re, q, radr, radr_d, wadr_d, d_d, we_d, re_d, q_d
);output we;
  output [15:0] d;
  output [10:0] wadr;
  output re;
  input [15:0] q;
  output [10:0] radr;
  input [10:0] radr_d;
  input [10:0] wadr_d;
  input [15:0] d_d;
  input we_d;
  input re_d;
  output [15:0] q_d;



  
  assign we = (we_d);
  assign d = (d_d);
  assign wadr = (wadr_d);
  assign re = (re_d);
  assign q_d = q;
  assign radr = (radr_d);endmodule