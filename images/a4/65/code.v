module top_module(
  input clk,
  input reset,
  input [7:0] input1,
  input [7:0] input2,
  input enable,
  output reg [15:0] result
);always @(posedge clk, posedge reset) begin
  if (reset) begin
    result <= 0;
  end else if (enable) begin
    result <= input1 * input2;
  end else begin
    result <= 0;
  end
end

endmodule