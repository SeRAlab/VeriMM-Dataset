module top_module(
  input [7:0] in0,
  input [7:0] in1,
  input [7:0] in2,
  input [7:0] in3,
  input [1:0] sel,
  input clk, // Added clk input
  output reg [7:0] out
);reg [7:0] stage1_out;
reg [7:0] stage2_out;

always @(*) begin
  case(sel)
    2'b00: stage1_out = in0;
    2'b01: stage1_out = in1;
    2'b10: stage1_out = in2;
    2'b11: stage1_out = in3;
    default: stage1_out = 8'b0; // Added default case for safety
  endcase
end

always @(posedge clk) begin
  stage2_out <= stage1_out;
end

always @(posedge clk) begin
  out <= stage2_out;
end

endmodule