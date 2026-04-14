module top_module(
  input wire A, B, C,
  output reg F
);//Add any additional wires or registers if needed
  wire m0, m1, m2, m3;

  //Defining the min-terms
  assign m0 = A & B & C;
  assign m1 = A & B & ~C;
  assign m2 = A & ~B & C;
  assign m3 = A & ~B & ~C;

  //Implementing the function using a case statement
  always @ (A, B, C)
    case ({A, B, C})
      3'b000: F = m3;
      3'b001: F = m2;
      3'b010: F = m1;
      3'b011: F = m0;
      3'b100: F = m3;
      3'b101: F = m2;
      3'b110: F = m1;
      3'b111: F = m0;
    endcase

endmodule