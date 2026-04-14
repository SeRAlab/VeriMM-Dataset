module top_module(a, b, op, out, valid);input [7:0] a, b;
  input [1:0] op;
  output reg [7:0] out;
  output reg valid;
  
  always @(*) begin
    case (op)
      2'b00: out = a + b; // addition
      2'b01: out = a - b; // subtraction
      2'b10: out = a * b; // multiplication
      2'b11: out = a / b; // division
    endcase
    
    valid = 1'b1;
  end
endmodule