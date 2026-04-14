module top_module(
  input [31:0] a,
  input [31:0] b,
  output reg [31:0] remainder
);// Inputs: two unsigned integers a and b, where a > b
// Outputs: an unsigned integer representing the remainder of a divided by b

always @(*) begin
  remainder = a - (a / b) * b;
end

endmodule