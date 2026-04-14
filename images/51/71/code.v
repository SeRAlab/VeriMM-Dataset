module top_module( g, p, g_prec, g_out );input g, p;
  input [1:0] g_prec;
  output g_out;
  wire n4;

  assign g_out = p ? (g_prec == 2'b00 ? 1'b0 : (g_prec == 2'b01 ? ~g : (g_prec == 2'b10 ? 1'b1 : g))) : 1'b0;

endmodule