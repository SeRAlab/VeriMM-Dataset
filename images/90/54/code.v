module top_module(
  input wire A, B, C, D, E,
  output reg F
);parameter ONE = 1'b1;
  parameter ZERO = 1'b0;

  always @* begin
    case({A, B, C, D})
      4'b0000: F = E ? ONE : ZERO;
      4'b0001: F = E ? ONE : ZERO;
      4'b0011: F = E ? ZERO : ONE;
      4'b0010: F = E ? ZERO : ONE;
      4'b0110: F = E ? ONE : ZERO;
      4'b0111: F = E ? ONE : ZERO;
      4'b0101: F = E ? ZERO : ONE;
      4'b0100: F = E ? ZERO : ONE;
      default: F = ZERO;
    endcase
  end

endmodule