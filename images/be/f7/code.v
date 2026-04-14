module top_module(c_in, a, b, s, c_out);input c_in, a, b;
  output s, c_out;
  
  assign {c_out, s} = a + b + c_in;endmodule