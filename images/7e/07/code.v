module top_module(
  input wire A, B, C, D, E,
  output reg F
);always @(*) begin
    case ({A,B,C,D,E})
      5'b00000: F = 1'b0;
      5'b00001: F = 1'b1;
      5'b00011: F = 1'b1;
      5'b00010: F = 1'b0;
      5'b01000: F = 1'b1;
      5'b01001: F = 1'b0;
      5'b01011: F = 1'b0;
      5'b01010: F = 1'b1;
      5'b11000: F = 1'b0;
      5'b11001: F = 1'b1;
      5'b11011: F = 1'b1;
      5'b11010: F = 1'b0;
      5'b10000: F = 1'b1;
      5'b10001: F = 1'b0;
      5'b10011: F = 1'b0;
      5'b10010: F = 1'b1;
      default: F = 1'b0;
    endcase
  end

endmodule