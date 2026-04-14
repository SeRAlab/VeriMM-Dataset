module top_module(a_in, b_in, c_in, s_out, c_out);input   a_in, b_in, c_in;
  output  s_out, c_out;

  assign s_out = a_in ^ b_in ^ c_in;
  assign c_out = (a_in & b_in) | (b_in & c_in) | (c_in & a_in);

endmodule