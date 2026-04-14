module top_module(
  input clk,
  input [7:0] operand_a,
  input [7:0] operand_b,
  output reg [6:0] out
);always @(posedge clk) begin
  out <= operand_a + operand_b;
end

endmodule