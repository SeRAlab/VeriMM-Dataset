module top_module(
  input CLK,
  input EN,
  input TE,
  output ENCLK
);wire n1, n2, n3;

  // Invert the enable signal
  not #(0.1) inv_EN(EN, n1);

  // When EN is low, ENCLK should be low regardless of the state of CLK
  and #(0.1) and1(n1, 1'b0, n2);

  // When TE is low, ENCLK should be low regardless of the state of CLK
  and #(0.1) and2(TE, CLK, n3); // Fixing the second AND gate to use CLK input

  // When EN is high and TE is high, ENCLK should be the same as CLK
  assign ENCLK = (n2 & n3) ? 1'b0 : CLK; // Combine the control signals properly

endmodule