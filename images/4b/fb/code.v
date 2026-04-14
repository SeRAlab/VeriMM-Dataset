module top_module(A, B, S, Cout);input [3:0] A, B;
  output [3:0] S;
  output Cout;

  assign {Cout, S} = A + B;

endmodule