module top_module(
  input wire A, B, C, D,
  output reg F
);always @(*) begin
    case ({A,B})
      2'b00: F = C & ~D | ~C & D;
      2'b01: F = A & ~B & ~C | ~A & B & ~C | A & B & C | ~A & ~B & C;
      2'b11: F = C & D | ~C & ~D;
      2'b10: F = A & B & ~C | ~A & ~B & ~C | A & ~B & C | ~A & B & C;
    endcase
  end
  
endmodule