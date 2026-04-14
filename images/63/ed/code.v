module top_module(
  input CLK,
  input EN,
  input TE,
  output ENCLK
);reg ENCLK_reg;

  always @(posedge CLK) begin
    if (EN) begin
      ENCLK_reg <= CLK;
    end
  end

  assign ENCLK = TE ? 1'b1 : ENCLK_reg;

endmodule