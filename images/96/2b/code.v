module top_module(a, b, op, result);input signed [12:0] a, b;
  input [4:0] op;
  output reg signed [12:0] result; // Change output to reg
  
  always @(*) begin
    case (op)
      5'b00000: result = a + b;
      5'b00001: result = a - b;
      5'b00010: result = a & b;
      5'b00011: result = a | b;
      5'b00100: result = a ^ b;
      5'b00101: result = (b[2:0] > 0) ? (a << b[2:0]) : a;
      5'b00110: result = (b[2:0] > 0) ? (a >> b[2:0]) : a;
      default: result = 0;
    endcase
  end
endmodule