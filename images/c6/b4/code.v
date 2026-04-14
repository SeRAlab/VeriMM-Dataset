module clock_gate_high (
  input CLK, EN, TE,
  output ENCLK
);

  assign ENCLK = (EN & TE & CLK);

endmodule