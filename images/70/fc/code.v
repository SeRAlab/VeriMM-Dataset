module top_module(
  input xtal_in,
  output clk_out
);reg clk_out_reg;
  always @ (posedge xtal_in) begin
    clk_out_reg <= ~clk_out_reg;
  end
  assign clk_out = clk_out_reg;

endmodule