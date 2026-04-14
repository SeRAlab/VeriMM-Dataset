module top_module(op, a, b, result, zero);input [2:0] op;
  input [15:0] a;
  input [15:0] b;
  output reg [15:0] result; // Changed to reg
  output reg zero;          // Changed to reg

  reg [16:0] temp; // to hold intermediate results

  always @* begin
    case(op)
      3'b000: // addition
        temp = a + b;
      3'b001: // subtraction
        temp = a - b;
      3'b010: // bitwise AND
        temp = a & b;
      3'b011: // bitwise OR
        temp = a | b;
      3'b100: // bitwise XOR
        temp = a ^ b;
      3'b101: // logical shift left
        temp = a << b;
      3'b110: // logical shift right
        temp = a >> b;
      3'b111: // arithmetic shift right
        temp = $signed(a) >>> b;
      default: // safeguard for undefined operations
        temp = 0;
    endcase
    result = temp[15:0];
    zero = (result == 0);
  end

endmodule