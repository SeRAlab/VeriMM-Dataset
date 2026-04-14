module top_module(
  input clk,
  input enable,
  input te,
  output enclk
);reg enclk_reg;

  always @(posedge clk) begin
    if (enable) begin
      enclk_reg <= 1'b1;
    end else begin
      enclk_reg <= 1'b0;
    end
  end

  always @(posedge te) begin
    if (!enable) begin
      enclk_reg <= 1'b0;
    end
  end

  assign enclk = enclk_reg;

endmodule