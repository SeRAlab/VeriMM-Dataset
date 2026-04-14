module top_module(
  input g,
  input p,
  input g_prec,
  output g_out
);wire n5, n6;

  // Inverter
  assign n5 = ~g;

  // NAND2 gate
  assign n6 = ~(g_prec & p);

  // Output
  assign g_out = ~(n6 & n5);

endmodule