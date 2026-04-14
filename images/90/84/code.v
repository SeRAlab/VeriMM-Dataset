module top_module(
  input clk,
  input [1:0] a,
  input [1:0] b,
  output reg [1:0] sum
);reg [1:0] stage1_sum;
reg [1:0] stage2_sum;

always @(posedge clk) begin
  stage1_sum <= a ^ b;
  stage2_sum <= stage1_sum ^ sum;
  sum <= stage2_sum;
end

endmodule