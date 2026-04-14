module register_adder_clock_gate (
  input CLK,
  input EN,
  input TE,
  output ENCLK
);

  reg gated_clk;

  always @(posedge CLK) begin
    if (EN && !TE) begin
      gated_clk <= 1'b1;
    end else begin
      gated_clk <= 1'b0;
    end
  end

  assign ENCLK = gated_clk & CLK;

endmodule