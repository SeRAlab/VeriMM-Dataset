module top_module(
  input [7:0] num1,
  input [7:0] num2,
  input [7:0] num3,
  input [7:0] num4,
  output reg [7:0] min_val
);always @(*) begin
  min_val = num1; // Start with num1 as the initial minimum
  if (num2 < min_val) min_val = num2;
  if (num3 < min_val) min_val = num3;
  if (num4 < min_val) min_val = num4;
end

endmodule