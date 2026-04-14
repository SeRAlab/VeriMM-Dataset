module top_module(
  input CLK,
  input EN,
  input TE,
  input reset,
  output ENCLK
);reg ENCLK_reg;

  always @(posedge CLK, posedge reset) begin
    if (reset) begin
      ENCLK_reg <= 1'b0;
    end else if (EN && TE) begin
      ENCLK_reg <= ~ENCLK_reg;
    end
  end

  assign ENCLK = ENCLK_reg;

endmodule