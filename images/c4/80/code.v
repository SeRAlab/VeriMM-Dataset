module SNPS_CLOCK_GATE_HIGH_RegisterAdd_W13 ( CLK, EN, ENCLK, TE );
  input CLK, EN, TE;
  output ENCLK;

  reg gated_clk;

  always @ (posedge CLK or negedge EN) begin
    if (!EN) begin
      gated_clk <= 1'b0;
    end else if (!TE) begin
      gated_clk <= CLK;
    end else begin
      gated_clk <= 1'b1;
    end
  end

  assign ENCLK = gated_clk;

endmodule