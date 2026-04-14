module top_module(a, b, g_out, p_out);input a, b;
  output g_out, p_out;
  wire n3;

  assign n3 = ~a;              // Replace INV_X1 with a simple NOT operation
  assign g_out = a & b;       // Replace AND2_X1 with a simple AND operation
  assign p_out = a ^ n3;      // Replace XNOR2_X1 with XOR operation (XNOR can be used with A and B where A = a and B = n3)

endmodule