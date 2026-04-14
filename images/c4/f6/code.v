module clock_gating_cell (
  input clk, // clock signal
  input en, // enable signal
  output gclk // gated clock signal
);

  assign gclk = clk & en;

endmodule