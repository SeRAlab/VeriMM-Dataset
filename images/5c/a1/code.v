module top_module(a, b, g_out, p_out);input a, b;
  output g_out, p_out;

  // XOR operation
  assign p_out = a ^ b;

  // AND operation
  assign g_out = a & b;
endmodule