module top_module(
  input [3:0] a,
  input [3:0] b,
  input mode,
  input clk,
  output reg [3:0] result
);always @(posedge clk) begin
    if (mode == 1) // addition mode
      result <= a + b;
    else // subtraction mode
      result <= a - b;
  end

endmodule