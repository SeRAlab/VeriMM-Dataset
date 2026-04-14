module top_module(
  input CLK, EN, TE,
  output ENCLK
);// Define the latch behavior if TLATNTSCAX2TS is not a defined module
  reg ENCLK_reg;

  always @(posedge CLK or posedge TE) begin
    if (TE) begin
      ENCLK_reg <= 1'b0; // Reset output when TE is high
    end else if (EN) begin
      ENCLK_reg <= CLK; // Pass CLK through when EN is high
    end
  end

  assign ENCLK = ENCLK_reg;

endmodule