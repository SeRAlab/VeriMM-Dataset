module top_module(
  input wire A,
  input wire B,
  input wire C,
  output reg F
);always @*
    case ({A,B,C})
      3'b000: F = 1'b0;
      3'b001: F = 1'b1;
      3'b010: F = 1'b0;
      3'b011: F = 1'b1;
      3'b100: F = 1'b1;
      3'b101: F = 1'b0;
      3'b110: F = 1'b1;
      3'b111: F = 1'b0;
    endcase

endmodule