module clock_gate (
  input CLK,
  input EN,
  input TE,
  output ENCLK
);

  wire AND_out;
  wire D_flipflop_out;

  // First stage: AND gate
  assign AND_out = EN & TE;

  // Second stage: D flip-flop
  always @(posedge CLK) begin
    if (EN) begin
      D_flipflop_out <= AND_out;
    end
  end

  // Output
  assign ENCLK = D_flipflop_out;

endmodule