module top_module(a, b, c_in, g_out, p_out, s);input [3:0] a, b;
  input c_in;
  output g_out, p_out;
  output [3:0] s;

  wire [3:0] g, p;
  wire c1;

  assign g = a & b; // Generate
  assign p = a ^ b; // Propagate

  assign c1 = g | (p & c_in); // Carry out
  assign g_out = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]);
  assign p_out = p[3] & p[2] & p[1] & p[0];
  assign s = p ^ {c_in, c1}; // Sum output

endmodule