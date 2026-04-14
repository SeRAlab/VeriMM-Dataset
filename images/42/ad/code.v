module top_module(
  input clk,
  input enable,
  output gated_clk
);reg gated_clk_reg;

  always @(posedge clk) begin
    if (enable) begin
      gated_clk_reg <= 1'b1;
    end else begin
      gated_clk_reg <= gated_clk;
    end
  end

  assign gated_clk = enable ? clk : gated_clk_reg;

endmodule