module top_module(
  input clk,
  input reset,
  input enable,
  input data,
  output reg out
);always @(posedge clk) begin
  if (reset) begin
    out <= 1'b0;
  end else if (enable) begin
    out <= data;
  end
end

endmodule