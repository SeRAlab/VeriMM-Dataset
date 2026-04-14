module top_module(
  input signed [w-1:0] A,
  input signed [w-1:0] B,
  input [1:0] op,
  output signed [w-1:0] out
);parameter k = 8; // position of the fractional point
parameter w = 16; // total number of bits used to represent the fixed-point numbers

// op[0] = 0 for addition, 1 for subtraction
// op[0] = 2 for multiplication, 3 for division

reg signed [w-1:0] result;

always @* begin
  case(op)
    2'b00: result = A + B; // addition
    2'b01: result = A - B; // subtraction
    2'b10: result = $signed($signed(A) * $signed(B)) >> k; // multiplication
    2'b11: result = $signed($signed(A) << k) / $signed(B); // division
  endcase
end

assign out = result;

endmodule