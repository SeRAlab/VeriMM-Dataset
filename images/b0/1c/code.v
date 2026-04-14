module top_module(
  input [7:0] a,
  input [7:0] b,
  input [2:0] ctrl,
  output reg [7:0] z // Changed z to reg type
);reg [7:0] sum;
  reg [7:0] diff;
  reg [15:0] prod;
  reg [7:0] quotient;
  reg [7:0] remainder;

  always @* begin
    case(ctrl)
      3'b000: begin // sum
        sum = a + b;
        z = sum;
      end
      3'b001: begin // difference
        diff = a - b;
        z = diff;
      end
      3'b010: begin // product
        prod = a * b;
        z = prod[7:0];
      end
      3'b011: begin // quotient
        quotient = a / b;
        z = quotient;
      end
      3'b100: begin // remainder
        remainder = a % b;
        z = remainder;
      end
      3'b101: begin // bitwise AND
        z = a & b;
      end
      3'b110: begin // bitwise OR
        z = a | b;
      end
      3'b111: begin // bitwise XOR
        z = a ^ b;
      end
      default: z = 8'b00000000; // default case to avoid latches
    endcase
  end

endmodule