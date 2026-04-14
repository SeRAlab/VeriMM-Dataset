module top_module( g, p, g_prec, p_prec, g_out, p_out );input g, p, g_prec, p_prec;
  output g_out, p_out;
  wire   n5, g_prec_inv, g_out_inv, g_out_mux, g_out_final, g_out_mux2, n6;

  // Check if g_prec is 1 and p is 0
  // If so, set g_out to 0
  assign n5 = ~(g_prec & p) | g; // AOI21 equivalent
  assign g_out = ~(n5); // INV equivalent

  // Check if g_prec is 1 and p is 1
  // If so, set g_out to the inverse of g_prec
  assign g_prec_inv = ~g_prec; // INV equivalent
  assign n6 = g_prec_inv & p; // AND2 equivalent
  assign g_out_inv = ~n6; // INV equivalent
  assign g_out_mux = (p) ? g_prec : g_out; // MUX2 equivalent
  assign g_out_final = g_out_inv | g_out_mux; // OR2 equivalent

  // Check if g_prec is 0
  // If so, set g_out to g
  assign g_out_mux2 = (g_prec) ? g : g; // MUX2 equivalent, this line is effectively redundant.

  // Check if p_prec is 1
  // If so, set p_out to the logical AND of p_prec and p
  assign p_out = p_prec & p; // AND2 equivalent

endmodule