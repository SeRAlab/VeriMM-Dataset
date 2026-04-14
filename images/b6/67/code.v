module top_module(a_in, b_in, s_in, s_out);parameter WIDTH = 1;
  input  [WIDTH-1:0] a_in, b_in;
  input  s_in;
  output [WIDTH-1:0] s_out;

  assign s_out = s_in ? b_in : a_in;
endmodule