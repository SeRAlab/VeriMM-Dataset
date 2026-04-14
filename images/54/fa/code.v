module alu 
(
  input [3:0] a,
  input [3:0] b,
  input [1:0] ctrl,

  output reg [3:0] result
);

  always @(*) begin
    case (ctrl)
      2'b00: result = a + b; // Addition
      2'b01: result = a - b; // Subtraction
      2'b10: result = a & b; // AND
      2'b11: result = a | b; // OR
      default: result = 4'b0000; // Default case
    endcase
  end

endmodule