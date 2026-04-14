module top_module(a, b, g_out, p_out);input a, b;
  output g_out, p_out;

  wire and_out, or_out;

  // AND gate using built-in Verilog operator
  assign and_out = a & b;

  // OR gate using built-in Verilog operator
  assign or_out = a | b;

  // Assign outputs
  assign g_out = and_out;
  assign p_out = or_out;

endmodule