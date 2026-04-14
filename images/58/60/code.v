module top_module(
  input clk,
  input rst,
  input enable,
  input test_expr,
  input prevConfigInvalid,
  output out
);reg out_reg;

  always @(posedge clk) begin
    if (rst) begin
      out_reg <= 0;
    end else if (enable) begin
      if (test_expr && !prevConfigInvalid) begin
        out_reg <= 1;
      end else begin
        out_reg <= 0;
      end
    end
  end

  assign out = out_reg;

endmodule