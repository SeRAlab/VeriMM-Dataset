module top_module( g, p, g_prec, p_prec, p_out, g_out_BAR );input g, p, g_prec, p_prec;
  output p_out, g_out_BAR;

  // Implementing AOI21 gate
  assign g_out_BAR = ~(g & p & ~g_prec);

  // Implementing AND2 gate
  assign p_out = p & p_prec;
endmodule