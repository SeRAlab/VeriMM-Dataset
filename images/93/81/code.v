module top_module(
  input A,
  input B,
  input C_in,
  input clk,                  // Added clk input
  output reg Sum,
  output reg C_out
);reg stage1_Sum, stage1_C_out, stage2_Sum, stage2_C_out;

always @(*) begin
  stage1_Sum = A ^ B;
  stage1_C_out = A & B;
  stage2_Sum = stage1_Sum ^ C_in;
  stage2_C_out = (stage1_Sum & C_in) | (stage1_C_out);
end

always @(posedge clk) begin
  Sum <= stage2_Sum;
  C_out <= stage2_C_out;
end

endmodule