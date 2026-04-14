module SNPS_CLOCK_GATE_HIGH_RegisterAdd_W31_0_3 ( CLK, EN, ENCLK, TE );
  input CLK, EN, TE;
  output ENCLK;

  reg ENCLK_reg;

  always @(posedge CLK) begin
    if (EN && TE) begin
      ENCLK_reg <= CLK;
    end else begin
      ENCLK_reg <= 1'b0;
    end
  end

  assign ENCLK = ENCLK_reg;

endmodule