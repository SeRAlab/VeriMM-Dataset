module top_module(
  input [7:0] a,
  input [7:0] b,
  input [1:0] opcode,
  output reg [7:0] result
);always @(*)
begin
  case(opcode)
    2'b00: result = a + b; // addition
    2'b01: result = a - b; // subtraction
    2'b10: result = a * b; // multiplication
    2'b11: result = a / b; // division
  endcase
end

endmodule