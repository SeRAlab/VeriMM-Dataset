module top_module(z, S, A, M);input z;
  input [3:0] S, A;
  output [3:0] M;

  assign M = ({4{~z}} & S)|({4{z}} & A);endmodule