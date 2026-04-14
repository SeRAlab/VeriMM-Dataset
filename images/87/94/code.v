module top_module(A, B, C, F);input A, B, C;
   output F;
   
   assign F = ~(A & B & C) & ~(A & ~B & C) & ~(A & B & ~C) & ~(A & ~B & ~C);
   
endmodule