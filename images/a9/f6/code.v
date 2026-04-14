module top_module(
  input a,
  input b,
  output g_out,
  output p_out
);// XOR gate to produce p_out
wire p_wire;
assign p_wire = a ^ b;

// AND gate to produce g_out
wire g_wire;
assign g_wire = a & b;

// Output signals
assign p_out = p_wire;
assign g_out = g_wire;

endmodule