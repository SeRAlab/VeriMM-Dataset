module top_module(
  input CLK,
  input EN,
  input TE,
  output ENCLK
);wire n2;
  
  // Instantiate a transparent latch instead of TLATNTSCAX2TS
  wire latch_out;
  assign latch_out = (EN) ? CLK : 1'b0; // Simple latch behavior
  
  // Use a regular buffer instead of BUFX6TS
  assign ENCLK = latch_out; // Direct assignment to output

endmodule