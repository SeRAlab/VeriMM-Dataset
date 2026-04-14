module alu (
  input [3:0] a,
  input [3:0] b,
  input [1:0] op,
  output reg [3:0] result);always @(*) begin
  case (op)
    2'b00: result = a + b;
    2'b01: result = a - b;
    2'b10: result = a & b;
    2'b11: result = a | b;
    default: result = 4'b0000;
  endcase
end

endmodule